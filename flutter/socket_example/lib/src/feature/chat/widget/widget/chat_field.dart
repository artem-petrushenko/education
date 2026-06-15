import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_example/src/feature/chat/bloc/chat/chat_bloc.dart';

class ChatField extends StatefulWidget {
  const ChatField({super.key});

  @override
  State<ChatField> createState() => _ChatFieldState();
}

class _ChatFieldState extends State<ChatField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Сообщение в сокет...'),
          ),
        ),
        IconButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              context.read<ChatBloc>().add(SendMessage(_controller.text));
              _controller.clear();
            }
          },
          icon: const Icon(Icons.send),
        ),
      ],
    );
  }
}
