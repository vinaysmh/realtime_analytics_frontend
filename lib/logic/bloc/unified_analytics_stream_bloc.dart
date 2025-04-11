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

class UnifiedAnalyticsLoading extends UnifiedAnalyticsState {}

class UnifiedAnalyticsSuccess extends UnifiedAnalyticsState {
  final List<AnalyticsData> dataList;
  UnifiedAnalyticsSuccess(this.dataList);
}

class UnifiedAnalyticsFailure extends UnifiedAnalyticsState {}

// Bloc
class UnifiedAnalyticsBloc extends Bloc<UnifiedAnalyticsEvent, UnifiedAnalyticsState> {
  final AnalyticsRepository repository;

  StreamSubscription<AnalyticsData>? _subscription;
  final List<AnalyticsData> _dataList = [];

  UnifiedAnalyticsBloc(this.repository) : super(UnifiedAnalyticsInitial()) {
    on<StartUnifiedAnalytics>((event, emit) async {
      emit(UnifiedAnalyticsLoading());

      try {
        await emit.forEach<AnalyticsData>(repository.analyticsStream, onData: (data) {
          _dataList.add(data);
          return UnifiedAnalyticsSuccess(_dataList); // emit updated list
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
