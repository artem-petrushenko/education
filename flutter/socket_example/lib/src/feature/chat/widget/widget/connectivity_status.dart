import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_example/src/feature/chat/bloc/connection/connection_bloc.dart';

import '../../data/client/app_web_socket_client.dart';

class ConnectivityStatus extends StatelessWidget {
  const ConnectivityStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectionBloc, ConnectionState>(
      builder: (context, state) {
        IconData icon;
        Color color;
        String tooltip;

        switch (state.status) {
          case WebSocketStatus.connected:
            icon = Icons.cloud_done;
            color = Colors.greenAccent;
            tooltip = 'Подключено';
            break;
          case WebSocketStatus.connecting:
            icon = Icons.cloud_queue;
            color = Colors.orangeAccent;
            tooltip = 'Подключение...';
            break;
          case WebSocketStatus.disconnected:
            icon = Icons.cloud_off;
            color = Colors.redAccent;
            tooltip = 'Соединение разорвано';
            break;
        }

        return Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Tooltip(
            message: tooltip,
            child: Icon(icon, color: color, size: 28),
          ),
        );
      },
    );
  }
}
