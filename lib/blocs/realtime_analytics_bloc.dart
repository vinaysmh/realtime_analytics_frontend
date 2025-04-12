import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../constants/endpoints.dart';
import '../models/analytics_data.dart';
import '../utils/analytics_data_utils.dart';

// BLoC
class RealtimeAnalyticsBloc extends Bloc<RealtimeAnalyticsEvent, RealtimeAnalyticsState> {
  ///Timeout for WSS requests in case of server sleeping as it happens with render
  final Duration _timeout = const Duration(minutes: 2);

  /// List to store the data
  final List<AnalyticsData> _dataList = [];
  RealtimeAnalyticsBloc() : super(RealtimeAnalyticsInitial()) {
    on<StartRealtimeAnalytics>((event, emit) async {
      emit(RealtimeAnalyticsProgress());
      // Start the WebSocket connection
      WebSocketChannel realtimeSocket = WebSocketChannel.connect(Uri.parse("wss://${ApiConstants.analyticsPath}"));
      // Listen to the stream and emit the data
      await emit.forEach(
        realtimeSocket.stream.timeout(_timeout),
        onData: (data) {
          try {
            Map<String, dynamic> realtimeData = jsonDecode(data);
            final analyticsData = AnalyticsData.tryParse(realtimeData);
            if (analyticsData != null) {
              _dataList.add(analyticsData);
            }
            final utils = AnalyticsDataUtils(_dataList);
            return RealtimeAnalyticsSuccess(utils.getFiniteList);
          } catch (e) {
            return (RealtimeAnalyticsFailure());
          }
        },
        onError: (e, s) {
          /// In case of error, return the last data
          if (_dataList.isNotEmpty) {
            final utils = AnalyticsDataUtils(_dataList);
            return RealtimeAnalyticsSuccess(utils.getFiniteList);
          }
          return (RealtimeAnalyticsFailure());
        },
      );
    });
  }
}

// Events
abstract class RealtimeAnalyticsEvent {}

class StartRealtimeAnalytics extends RealtimeAnalyticsEvent {}

// States
abstract class RealtimeAnalyticsState {}

class RealtimeAnalyticsInitial extends RealtimeAnalyticsState {}

class RealtimeAnalyticsProgress extends RealtimeAnalyticsState {}

class RealtimeAnalyticsSuccess extends RealtimeAnalyticsState {
  final List<AnalyticsData> dataList;
  RealtimeAnalyticsSuccess(this.dataList);
}

class RealtimeAnalyticsFailure extends RealtimeAnalyticsState {}
