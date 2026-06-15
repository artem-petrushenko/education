import 'package:socket_example/src/feature/chat/data/client/app_web_socket_client.dart';

class ChatDataProvider {
  final AppWebSocketClient _networkClient;

  ChatDataProvider({required AppWebSocketClient networkClient}) : _networkClient = networkClient;

  Stream<dynamic> get chatMessagesStream => _networkClient.rawStream;

  void sendChatMessage(String rawText) {
    _networkClient.send(rawText);
  }
}
