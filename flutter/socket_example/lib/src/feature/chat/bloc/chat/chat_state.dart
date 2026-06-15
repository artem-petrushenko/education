part of 'chat_bloc.dart';

abstract class ChatState {
  final List<String> history;

  ChatState(this.history);
}

// Состояние в момент подключения
class ChatConnecting extends ChatState {
  ChatConnecting() : super([]);
}

// Состояние, когда сокет успешно слушает эфир
class ChatConnected extends ChatState {
  ChatConnected(super.history);
}
