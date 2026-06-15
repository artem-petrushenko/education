import 'package:flutter/material.dart';
import 'package:socket_example/src/feature/chat/widget/widget/chat_body.dart';
import 'package:socket_example/src/feature/chat/widget/widget/chat_field.dart';
import 'package:socket_example/src/feature/chat/widget/widget/connectivity_status.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebSocket'), actions: [ConnectivityStatus()]),
      persistentFooterButtons: [ChatField()],
      body: ChatBody(),
    );
  }
}
