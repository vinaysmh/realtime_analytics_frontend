import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WsClientService {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  ///Timeout for WSS requests in case of server sleeping as it happens with render
  final Duration _timeout = const Duration(minutes: 2);

  void connect(String url) {
    try {
      _channel = WebSocketChannel.connect(Uri.parse("wss://$url"));
      _subscription = _channel!.stream.timeout(
        _timeout,
        onTimeout: (EventSink sink) {
          log('WebSocket timed out during stream', name: '[WsClientService]');
          sink.addError(TimeoutException('WebSocket stream timed out'));
        },
      ).listen(
        (raw) {
          try {
            final json = jsonDecode(raw);
            _controller.add(json);
          } catch (e) {
            log('WS decode error', error: e, name: '[WsClientService]');
          }
        },
        onError: (e) {
          log('WS connection error', error: e, name: '[WsClientService]');
        },
        onDone: () {
          log('WS connection closed', name: '[WsClientService]');
        },
      );
    } catch (e) {
      log('WS connect failure', error: e, name: '[WsClientService]');
    }
  }

  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close(status.goingAway);
    _controller.close();
  }
}
