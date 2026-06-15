part of 'connection_bloc.dart';

abstract class ConnectionEvent {}

class MonitorConnection extends ConnectionEvent {}

class _StatusChanged extends ConnectionEvent {
  final WebSocketStatus status;

  _StatusChanged(this.status);
}
