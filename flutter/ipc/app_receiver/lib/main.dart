import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const ReceiverApp());

class ReceiverApp extends StatelessWidget {
  const ReceiverApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(home: ReceiverScreen());
}

class ReceiverScreen extends StatefulWidget {
  const ReceiverScreen({super.key});

  @override
  State<ReceiverScreen> createState() => _ReceiverScreenState();
}

class _ReceiverScreenState extends State<ReceiverScreen> {
  int _receivedCounter = 0;

  static const _streamChannel = EventChannel('com.example.ipc/receiver_stream');

  @override
  void initState() {
    super.initState();
    _streamChannel.receiveBroadcastStream().listen(
      (dynamic event) {
        setState(() {
          _receivedCounter = event as int;
        });
      },
      onError: (error) {
        print("Ошибка приема стрима: $error");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IPC Receiver')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Получено из Приложения 1 через IPC:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Text(
              '$_receivedCounter',
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
