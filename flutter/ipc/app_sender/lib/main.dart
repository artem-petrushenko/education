import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const SenderApp());

class SenderApp extends StatelessWidget {
  const SenderApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(home: HomeScreen());
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  static const _channel = MethodChannel('com.example.ipc/sender');

  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });

    try {
      await _channel.invokeMethod('sendCount', {'value': _counter});
    } on PlatformException catch (e) {
      print("Ошибка отправки в нативную часть: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IPC Sender')),
      body: Center(
        child: Text('Счетчик: $_counter', style: const TextStyle(fontSize: 28)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}