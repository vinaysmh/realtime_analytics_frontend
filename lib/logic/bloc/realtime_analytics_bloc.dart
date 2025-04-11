import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/analytics_repository.dart';
import '../../models/analytics_data.dart';

// Events
abstract class RealtimeAnalyticsEvent {}

class StartRealtimeAnalytics extends RealtimeAnalyticsEvent {}

// States
abstract class RealtimeAnalyticsState {}

class RealtimeAnalyticsInitial extends RealtimeAnalyticsState {}

class RealtimeAnalyticsProgress extends RealtimeAnalyticsState {}

class RealtimeAnalyticsSuccess extends RealtimeAnalyticsState {
  final AnalyticsData data;
  RealtimeAnalyticsSuccess(this.data);
}

class RealtimeAnalyticsFailure extends RealtimeAnalyticsState {}

// BLoC
class RealtimeAnalyticsBloc extends Bloc<RealtimeAnalyticsEvent, RealtimeAnalyticsState> {
  final AnalyticsRepository analyticsRepository;

  RealtimeAnalyticsBloc(this.analyticsRepository) : super(RealtimeAnalyticsInitial()) {
    on<StartRealtimeAnalytics>((event, emit) async {
      emit(RealtimeAnalyticsProgress());
      analyticsRepository.startRealtime();
    });
  }
}
