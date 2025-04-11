import 'dart:async';
import 'dart:developer';

import '../../apis/endpoints.dart';
import '../../core/network/http_client.dart';
import '../../core/network/ws_client.dart';
import '../../models/analytics_data.dart';

class AnalyticsRepository {
  final HttpClientService _httpClient;
  final WsClientService _wsClient;

  AnalyticsRepository(this._httpClient, this._wsClient);

  Timer? _timer;
  final _controller = StreamController<AnalyticsData>.broadcast();
  Stream<AnalyticsData> get analyticsStream => _controller.stream;

  /// Polling every 10 seconds via HTTP
  void startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 10), (_) async {
      try {
        final json = await _httpClient.getJson(ApiConstants.analyticsPath);
        final data = AnalyticsData.tryParse(json);
        if (data != null) {
          _controller.sink.add(data);
        }
      } catch (e) {
        log("Polling error", error: e, name: '[AnalyticsRepository]');
      }
    });
  }

  /// Real-time updates via WebSocket using WsClientService
  void startRealtime() {
    _wsClient.connect(ApiConstants.analyticsPath);
    _wsClient.stream.listen((json) {
      try {
        final data = AnalyticsData.tryParse(json);
        if (data != null) {
          _controller.sink.add(data);
        }
      } catch (e) {
        log('Realtime parsing error', error: e, name: '[AnalyticsRepository]');
      }
    });
  }

  /// Stop polling
  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
