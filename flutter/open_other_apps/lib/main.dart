import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum ExternalApp {
  pumb(
    title: 'PUMB Business',
    iosScheme: 'fb511344104302991://',
    android: 'https://www.digital.pumb.ua/',
    fallbackUrl: 'https://business.pumb.ua',
  ),
  googleMaps(
    title: 'Google Maps',
    iosScheme: 'comgooglemaps://?q=50.4501,30.5234(Київ)',
    android: "intent:geo:50.4501,30.5234?q=50.4501,30.5234(Київ)#Intent;package=com.google.android.apps.maps;end",
    fallbackUrl: 'https://www.google.com/maps/search/?api=1&query=50.4501,30.5234',
  ),
  youtube(
    title: 'YouTube',
    iosScheme: 'youtube://',
    android: 'com.google.android.youtube',
    fallbackUrl: 'https://youtube.com',
  );

  final String title;
  final String iosScheme;
  final String android;
  final String fallbackUrl;

  const ExternalApp({
    required this.title,
    required this.iosScheme,
    required this.android,
    required this.fallbackUrl,
  });

  Uri get platformUri {
    if (Platform.isIOS) {
      return Uri.parse(iosScheme);
    } else if (Platform.isAndroid) {
      return Uri.parse(android);
    }
    return Uri.parse(fallbackUrl);
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const AppLauncherScreen(),
    );
  }
}

class AppLauncherScreen extends StatelessWidget {
  const AppLauncherScreen({super.key});

  Future<void> _launchApp(BuildContext context, ExternalApp app) async {
    final Uri targetUri = app.platformUri;

    try {
      if (await canLaunchUrl(targetUri)) {
        await launchUrl(targetUri, mode: LaunchMode.externalApplication);
      } else {
        final Uri fallbackUri = Uri.parse(app.fallbackUrl);
        await launchUrl(fallbackUri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Помилка при відкритті ${app.title}: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('External App Launcher'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: ExternalApp.values.map((app) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                  onPressed: () => _launchApp(context, app),
                  icon: const Icon(Icons.open_in_new),
                  label: Text('Відкрити ${app.title}', style: const TextStyle(fontSize: 16)),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
