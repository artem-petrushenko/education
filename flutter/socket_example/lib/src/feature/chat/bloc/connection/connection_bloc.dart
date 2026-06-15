import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_example/src/feature/chat/data/client/app_web_socket_client.dart';

part 'connection_event.dart';

part 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  final AppWebSocketClient _client;
  StreamSubscription? _statusSubscription;

  ConnectionBloc({required AppWebSocketClient client})
    : _client = client,
      // Изначально берем тот статус, который у клиента прямо сейчас
      super(ConnectionState(client.currentStatus)) {
    on<MonitorConnection>(_onMonitorConnection);
    on<_StatusChanged>(_onStatusChanged);
  }

  void _onMonitorConnection(MonitorConnection event, Emitter<ConnectionState> emit) {
    // 1. Принудительно отдаем текущий статус в UI
    emit(ConnectionState(_client.currentStatus));

    _statusSubscription?.cancel();

    // 2. Слушаем стрим клиента ЖЕЛЕЗОБЕТОННЫМ способом:
    // Когда клиент делает _statusController.add(), мы ловим это
    // и кидаем внутренний эвент _StatusChanged в наш БЛок.
    _statusSubscription = _client.statusStream.listen(
      (status) {
        print('🧠 [BLOC] Получен новый статус из клиента: $status');
        add(_StatusChanged(status)); // 🔴 Важно: кидаем эвент!
      },
      onError: (err) {
        add(_StatusChanged(WebSocketStatus.disconnected));
      },
    );
  }

  void _onStatusChanged(_StatusChanged event, Emitter<ConnectionState> emit) {
    print('🎨 [BLOC] Эмитим новый стейт в UI: ${event.status}');
    emit(ConnectionState(event.status)); // 🔴 Перерисовываем UI
  }

  @override
  Future<void> close() {
    _statusSubscription?.cancel();
    return super.close();
  }
}
