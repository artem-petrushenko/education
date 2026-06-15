part of 'chat_bloc.dart';

abstract class ChatEvent {}

class ConnectToChat extends ChatEvent {}

class SendMessage extends ChatEvent {
  final String message;

  SendMessage(this.message);
}
