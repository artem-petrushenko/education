import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_example/src/feature/chat/bloc/chat/chat_bloc.dart';

class ChatBody extends StatelessWidget {
  const ChatBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatConnecting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: state.history.length,
          itemBuilder: (context, index) {
            final msg = state.history[index];
            final isEcho = msg.startsWith('Сервер');
            return ListTile(
              title: Text(msg),
              leading: Icon(
                isEcho ? Icons.cloud_download : Icons.cloud_upload,
                color: isEcho ? Colors.green : Colors.blue,
              ),
            );
          },
        );
      },
    );
  }
}
