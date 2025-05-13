import 'package:flutter/material.dart';

void main() async {
  await const AppRunner().initializeAndRun();
}

class AppRunner {
  const AppRunner();

  Future<void> initializeAndRun() async {
    final binding = WidgetsFlutterBinding.ensureInitialized();
    binding.deferFirstFrame();
    runApp(const SplashScreenApp());
    binding.allowFirstFrame();

    await initDependencies();
    runApp(const MyApp());
  }

  Future<void> initDependencies() async {
    // Simulate some initialization work
    await Future.delayed(const Duration(seconds: 2));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Flutter Splash Screen'),
        ),
      ),
    );
  }
}

class SplashScreenApp extends StatelessWidget {
  const SplashScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Image.asset('assets/png/logo.png')),
      ),
    );
  }
}
