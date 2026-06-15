import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_example/src/feature/chat/bloc/chat/chat_bloc.dart';
import 'package:socket_example/src/feature/chat/bloc/connection/connection_bloc.dart';
import 'package:socket_example/src/feature/chat/data/client/app_web_socket_client.dart';
import 'package:socket_example/src/feature/chat/data/repository/chat_repository.dart';
import 'package:socket_example/src/feature/chat/data/data_provider/chat_data_provider.dart';
import 'package:socket_example/src/feature/chat/widget/chat_screen.dart';

void main() {
  final networkClient = AppWebSocketClient(url: 'wss://ws.postman-echo.com/raw');
  networkClient.init();
  final dataProvider = ChatDataProvider(networkClient: networkClient);
  final chatRepository = ChatRepository(dataProvider: dataProvider);

  runApp(
    BlocProvider(
      create: (BuildContext context) =>
          ConnectionBloc(client: networkClient)..add(MonitorConnection()),
      child: RepositoryProvider.value(value: chatRepository, child: const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) =>
            ChatBloc(repository: context.read<ChatRepository>())..add(ConnectToChat()),
        child: const ChatScreen(),
      ),
    );
  }
}
