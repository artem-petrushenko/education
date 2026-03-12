import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const NativeChannelsApp());
}

class NativeChannelsApp extends StatelessWidget {
  const NativeChannelsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Native Channels Demo',
      home: NativeChannelsHomePage(),
    );
  }
}

class NativeChannelsHomePage extends StatefulWidget {
  const NativeChannelsHomePage({super.key});

  @override
  State<NativeChannelsHomePage> createState() => _NativeChannelsHomePageState();
}

class _NativeChannelsHomePageState extends State<NativeChannelsHomePage> {
  static const methodChannel = MethodChannel('com.example.methodChannel');
  static const eventChannel = EventChannel('com.example.eventChannel');
  static const basicMessageChannel =
      BasicMessageChannel<String>('com.example.basicMessageChannel', StringCodec());

  StreamSubscription? _counterSubscription;
  int _counter = 0;
  String _basicMessageReply = '';

  Future<void> _openSettings() async {
    try {
      await methodChannel.invokeMethod('openGeneralSettings');
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void _startCounterStream() {
    _counterSubscription = eventChannel.receiveBroadcastStream().listen((event) {
      setState(() {
        _counter = event as int;
      });
    });
  }

  Future<void> _sendMessage() async {
    final reply = await basicMessageChannel.send('Hello from Flutter!');
    setState(() {
      _basicMessageReply = reply ?? 'No reply';
    });
  }

  @override
  void dispose() {
    _counterSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter <-> Native Channels')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _openSettings,
              child: const Text('MethodChannel'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startCounterStream,
              child: const Text('EventChannel'),
            ),
            Text('Counter: $_counter', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendMessage,
              child: const Text('BasicMessageChannel'),
            ),
            Text('Reply: $_basicMessageReply', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
