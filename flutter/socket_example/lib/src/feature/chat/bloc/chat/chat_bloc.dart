import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_example/src/feature/chat/data/repository/chat_repository.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _repository;

  ChatBloc({required ChatRepository repository})
    : _repository = repository,
      super(ChatConnecting()) {
    on<ConnectToChat>(_onConnectToChat);
    on<SendMessage>(_onSendMessage);
  }

  Future<void> _onConnectToChat(ConnectToChat event, Emitter<ChatState> emit) async {
    emit(ChatConnected([]));
    await emit.forEach<dynamic>(
      _repository.messagesStream,
      onData: (data) =>
          ChatConnected(List<String>.from(state.history)..add('Сервер вернул: "$data"')),
      onError: (error, stackTrace) =>
          ChatConnected(List<String>.from(state.history)..add('🔴 Критическая ошибка системы')),
    );
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) {
    _repository.sendMessage(event.message);
    final updatedHistory = List<String>.from(state.history)..add('Вы: ${event.message}');
    emit(ChatConnected(updatedHistory));
  }
}
