import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/analytics_repository.dart';
import '../../../models/analytics_data.dart';

// Events
abstract class AnalyticsEvent {}

class StartAnalyticsPolling extends AnalyticsEvent {}

class StopAnalyticsPolling extends AnalyticsEvent {}

// States
abstract class AnalyticsState {}

class PolledAnalyticsInitial extends AnalyticsState {}

class PolledAnalyticsProgress extends AnalyticsState {}

class PolledAnalyticsSuccess extends AnalyticsState {
  final AnalyticsData data;
  PolledAnalyticsSuccess(this.data);
}

class PolledAnalyticsFailure extends AnalyticsState {}

// BLoC
class PolledAnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsRepository analyticsRepository;

  PolledAnalyticsBloc(this.analyticsRepository) : super(PolledAnalyticsInitial()) {
    on<StartAnalyticsPolling>((event, emit) {
      emit(PolledAnalyticsProgress());
      analyticsRepository.startPolling();
    });

    on<StopAnalyticsPolling>((event, emit) {
      analyticsRepository.stop();
    });
  }
}
