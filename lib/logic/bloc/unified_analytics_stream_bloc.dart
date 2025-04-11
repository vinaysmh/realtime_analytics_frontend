import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/analytics_repository.dart';
import '../../models/analytics_data.dart';

// Events
abstract class UnifiedAnalyticsEvent {}

class StartUnifiedAnalytics extends UnifiedAnalyticsEvent {}

class StopUnifiedAnalytics extends UnifiedAnalyticsEvent {}

// States
abstract class UnifiedAnalyticsState {}

class UnifiedAnalyticsInitial extends UnifiedAnalyticsState {}

class UnifiedAnalyticsProgress extends UnifiedAnalyticsState {}

class UnifiedAnalyticsSuccess extends UnifiedAnalyticsState {
  final int activeUsers;
  final double sessionProgress;
  final double avgSessionDuration;
  final List<AnalyticsData> dataList;
  UnifiedAnalyticsSuccess({
    required this.dataList,
    required this.activeUsers,
    required this.sessionProgress,
    required this.avgSessionDuration,
  });
}

class UnifiedAnalyticsFailure extends UnifiedAnalyticsState {}

// Bloc
class UnifiedAnalyticsBloc extends Bloc<UnifiedAnalyticsEvent, UnifiedAnalyticsState> {
  final AnalyticsRepository repository;

  StreamSubscription<AnalyticsData>? _subscription;
  final List<AnalyticsData> _dataList = [];

  UnifiedAnalyticsBloc(this.repository) : super(UnifiedAnalyticsInitial()) {
    on<StartUnifiedAnalytics>((event, emit) async {
      emit(UnifiedAnalyticsProgress());

      try {
        await emit.forEach<AnalyticsData>(repository.analyticsStream, onData: (data) {
          _dataList.add(data);
          //trim the data list to the last 60 elements
          if (_dataList.length > 60) {
            _dataList.removeRange(0, _dataList.length - 60);
          }
          double sessionDuration = averageSessionDurationInSeconds(_dataList);
          final progress = (sessionDuration / 600).clamp(0.0, 1.0); // progress out of 10 minutes

          return UnifiedAnalyticsSuccess(
            dataList: _dataList,
            sessionProgress: progress,
            avgSessionDuration: sessionDuration,
            activeUsers: _dataList.last.activeUsers,
          ); // emit updated data points to use in UI
        }, onError: (error, stackTrace) {
          log('user_changed_bloc.dart >> [Stream emit Exception]', error: error, stackTrace: stackTrace, name: '[UnifiedAnalyticsBloc]');
          return UnifiedAnalyticsFailure();
        });
      } catch (_) {
        emit(UnifiedAnalyticsFailure());
      }
    });

    on<StopUnifiedAnalytics>((event, emit) async {
      await _subscription?.cancel();
      emit(UnifiedAnalyticsInitial());
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

double averageSessionDurationInSeconds(List<AnalyticsData> dataList) {
  final durations = dataList.map((e) => e.avgSessionDuration);
  if (durations.isEmpty) return 0;

  /// Calculate the average session duration in seconds
  return (durations.reduce((a, b) => a + b) / durations.length * 60).roundToDouble();
}
