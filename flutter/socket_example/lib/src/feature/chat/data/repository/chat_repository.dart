import 'package:socket_example/src/feature/chat/data/data_provider/chat_data_provider.dart';

class ChatRepository {
  final ChatDataProvider _dataProvider;

  ChatRepository({required ChatDataProvider dataProvider}) : _dataProvider = dataProvider;

  Stream<dynamic> get messagesStream => _dataProvider.chatMessagesStream;

  void sendMessage(String message) {
    _dataProvider.sendChatMessage(message);
  }
}
