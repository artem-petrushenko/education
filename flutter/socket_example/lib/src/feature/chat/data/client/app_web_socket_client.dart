import 'dart:async';
import 'dart:io';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum WebSocketStatus { connecting, connected, disconnected }

class AppWebSocketClient {
  final String _url;
  WebSocketChannel? _channel;
  StreamSubscription? _socketSubscription;

  Timer? _heartbeatTimer;
  Timer? _pongTimeoutTimer;
  Timer? _reconnectTimer;

  bool _isClosedManually = false;
  bool _isConnecting = false;

  final StreamController<dynamic> _messageController = StreamController<dynamic>.broadcast();
  final StreamController<WebSocketStatus> _statusController = StreamController<WebSocketStatus>.broadcast();
  WebSocketStatus _currentStatus = WebSocketStatus.disconnected;

  AppWebSocketClient({required String url}) : _url = url;

  Stream<dynamic> get rawStream => _messageController.stream;
  Stream<WebSocketStatus> get statusStream => _statusController.stream;
  WebSocketStatus get currentStatus => _currentStatus;

  void init() {
    _isClosedManually = false;
    _connect();
  }

  Future<void> _connect() async {
    if (_isClosedManually || _isConnecting) return;

    _isConnecting = true;
    _updateStatus(WebSocketStatus.connecting);
    print('🔌 [WS] Попытка подключения к $_url...');

    try {
      final nativeSocket = await WebSocket.connect(_url).timeout(
        const Duration(seconds: 5),
      );

      if (_isClosedManually) {
        nativeSocket.close();
        return;
      }

      _channel = IOWebSocketChannel(nativeSocket);
      _updateStatus(WebSocketStatus.connected);
      print('🟢 [WS] Соединение установлено!');

      _startHeartbeat();

      _socketSubscription = _channel!.stream.listen(
            (data) {
          final message = data.toString();

          if (message == 'ping') {
            print('🎯 [WS] Получен Pong (сервер жив).');
            _pongTimeoutTimer?.cancel();
            _pongTimeoutTimer = null;
            return;
          }

          _messageController.add(data);
        },
        onError: (error) {
          print('❌ [WS] Ошибка стрима: $error');
          _handleReconnect();
        },
        onDone: () {
          print('💤 [WS] Соединение закрыто сервером.');
          _handleReconnect();
        },
      );
    } catch (e) {
      print('❌ [WS] Ошибка подключения: $e');
      _handleReconnect();
    } finally {
      _isConnecting = false;
    }
  }

  void _startHeartbeat() {
    _stopHeartbeat();

    _heartbeatTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_currentStatus == WebSocketStatus.connected) {
        print('📡 [WS] Отправка кастомного "ping"...');

        _pongTimeoutTimer?.cancel();

        _channel?.sink.add('ping');

        _pongTimeoutTimer = Timer(const Duration(seconds: 4), () {
          print('🚨 [WS] Pong не получен вовремя! Интернет завис.');
          _handleReconnect();
        });
      }
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _pongTimeoutTimer?.cancel();
    _pongTimeoutTimer = null;
  }

  void _handleReconnect() {
    _resetConnection();
    _updateStatus(WebSocketStatus.disconnected);

    if (_isClosedManually) return;

    _reconnectTimer?.cancel();

    print('🔄 [WS] Переподключение через 5 секунд...');
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      _connect();
    });
  }

  void _resetConnection() {
    _stopHeartbeat();
    _socketSubscription?.cancel();
    _socketSubscription = null;
    _channel?.sink.close();
    _channel = null;
  }

  void send(String payload) {
    if (_currentStatus == WebSocketStatus.connected) {
      _channel?.sink.add(payload);
    }
  }

  void _updateStatus(WebSocketStatus status) {
    if (_currentStatus == status) return;
    _currentStatus = status;
    _statusController.add(status);
  }

  void close() {
    _isClosedManually = true;
    _isConnecting = false;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _resetConnection();
    _messageController.close();
    _statusController.close();
  }
}