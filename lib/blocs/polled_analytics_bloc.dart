import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../models/analytics_data.dart';
import '../constants/endpoints.dart';
import '../utils/analytics_data_utils.dart';

// BLoC
class PolledAnalyticsBloc extends Bloc<PolledAnalyticsEvent, PolledAnalyticsState> {
  ///Timeout for HTTP requests in case of server sleeping as it happens with render
  final Duration _timeout = const Duration(minutes: 2);

  /// List to store the data
  final List<AnalyticsData> _dataList = [];

  /// Stream to emit the data
  final _polledAnalyticsStream = StreamController<List<AnalyticsData>>.broadcast();
  PolledAnalyticsBloc() : super(PolledAnalyticsInitial()) {
    on<StartAnalyticsPolling>((event, emit) async {
      emit(PolledAnalyticsProgress());
      // Start the polling
      Timer.periodic(const Duration(seconds: 3), (_) async {
        final response = await http.get(Uri.parse("https://${ApiConstants.analyticsPath}")).timeout(_timeout);
        if (response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
          final analyticsData = AnalyticsData.tryParse(data);

          if (analyticsData != null) {
            _dataList.add(analyticsData);
          }
          final utils = AnalyticsDataUtils(_dataList);
          _polledAnalyticsStream.sink.add(utils.getFiniteList);
        }
      });
      // Listen to the stream and emit the data
      await emit.forEach(
        _polledAnalyticsStream.stream.timeout(_timeout),
        onData: (data) {
          try {
            return PolledAnalyticsSuccess(data);
          } catch (e) {
            return (PolledAnalyticsFailure());
          }
        },
        onError: (e, s) {
          /// In case of error, return the last data
          if (_dataList.isNotEmpty) {
            return PolledAnalyticsSuccess(_dataList);
          }

          return (PolledAnalyticsFailure());
        },
      );
    });
  }
}

// Events
abstract class PolledAnalyticsEvent {}

class StartAnalyticsPolling extends PolledAnalyticsEvent {}

// States
abstract class PolledAnalyticsState {}

class PolledAnalyticsInitial extends PolledAnalyticsState {}

class PolledAnalyticsProgress extends PolledAnalyticsState {}

class PolledAnalyticsSuccess extends PolledAnalyticsState {
  final List<AnalyticsData> dataList;
  PolledAnalyticsSuccess(this.dataList);
}

class PolledAnalyticsFailure extends PolledAnalyticsState {}
