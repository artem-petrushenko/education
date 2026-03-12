import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<Dependencies> initDependencies() async {
    const storage = FlutterSecureStorage();
    final sharedPreferences = await SharedPreferences.getInstance();
    final sharedPreferencesAsync = SharedPreferencesAsync();
    final sharedPreferencesWithCache = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    final ramStorage = RAMStorage();

    return Dependencies(
      secureStorage: const SecureStorageService(storage: storage),
      sharedPreferences: SharedPreferencesStorage(
        sharedPreferences: sharedPreferences,
        sharedPreferencesAsync: sharedPreferencesAsync,
        sharedPreferencesWithCache: sharedPreferencesWithCache,
      ),
      ramStorage: ramStorage,
      keychain: const KeychainService(),
    );
  }

  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded(
    () async {
      final dependencies = await initDependencies();
      runApp(MyApp(dependencies: dependencies));
    },
    (error, stack) {
      print('Error: $error');
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.dependencies,
  });

  final Dependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
        dependencies: dependencies,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.dependencies,
  });

  final Dependencies dependencies;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final sharedPreferences = ValueNotifier(false);
  final asyncSharedPreferences = ValueNotifier(false);
  final cacheSharedPreferences = ValueNotifier(false);
  final secureStorage = ValueNotifier(false);
  final ramStorage = ValueNotifier(false);
  final keychain = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Content(
              title: 'SharedPreferences',
              notifier: sharedPreferences,
              onPressed: () async {
                final result = await widget.dependencies.sharedPreferences.asyncSharedPreferences(
                  !sharedPreferences.value,
                );
                return result;
              },
            ),
            Content(
              title: 'AsyncSharedPreferences',
              notifier: asyncSharedPreferences,
              onPressed: () async {
                final result = await widget.dependencies.sharedPreferences.sharedPreferences(
                  !asyncSharedPreferences.value,
                );
                return result;
              },
            ),
            Content(
              title: 'CacheSharedPreferences',
              notifier: cacheSharedPreferences,
              onPressed: () async {
                final result = await widget.dependencies.sharedPreferences.cacheSharedPreferences(
                  !cacheSharedPreferences.value,
                );
                return result;
              },
            ),
            Content(
              title: 'SecureStorage',
              notifier: secureStorage,
              onPressed: () async {
                final result = await widget.dependencies.secureStorage.secureStorage(
                  !secureStorage.value,
                );
                return result;
              },
            ),
            Content(
              title: 'RAMStorage',
              notifier: ramStorage,
              onPressed: () async {
                final result = widget.dependencies.ramStorage.ramStorage(
                  !ramStorage.value,
                );
                return result;
              },
            ),
            Content(
              title: 'Keychain',
              notifier: keychain,
              onPressed: () async {
                final result = await widget.dependencies.keychain.keychain(!keychain.value);
                return result;
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await widget.dependencies.sharedPreferences.cleanAll();
          await widget.dependencies.secureStorage.clear();
          widget.dependencies.ramStorage.clear();
          sharedPreferences.value = false;
          asyncSharedPreferences.value = false;
          cacheSharedPreferences.value = false;
          secureStorage.value = false;
          ramStorage.value = false;
        },
        child: const Icon(Icons.delete),
      ),
    );
  }
}

class Content extends StatelessWidget {
  const Content({
    super.key,
    required this.title,
    required this.notifier,
    required this.onPressed,
  });

  final String title;
  final ValueNotifier<bool> notifier;
  final Future<bool> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            final result = await onPressed();
            notifier.value = result;
          },
          child: Text('Use $title'),
        ),
        ValueListenableBuilder(
          valueListenable: notifier,
          builder: (context, value, child) {
            return Text('$title: $value');
          },
        ),
      ],
    );
  }
}

class Dependencies {
  const Dependencies({
    required this.sharedPreferences,
    required this.secureStorage,
    required this.ramStorage,
    required this.keychain,
  });

  final SharedPreferencesStorage sharedPreferences;
  final SecureStorageService secureStorage;
  final RAMStorage ramStorage;
  final KeychainService keychain;
}

class SharedPreferencesStorage {
  const SharedPreferencesStorage({
    required SharedPreferences sharedPreferences,
    required SharedPreferencesAsync sharedPreferencesAsync,
    required SharedPreferencesWithCache sharedPreferencesWithCache,
  })  : _sharedPreferences = sharedPreferences,
        _sharedPreferencesAsync = sharedPreferencesAsync,
        _sharedPreferencesWithCache = sharedPreferencesWithCache;

  final key = 'key';
  final SharedPreferences _sharedPreferences;
  final SharedPreferencesAsync _sharedPreferencesAsync;
  final SharedPreferencesWithCache _sharedPreferencesWithCache;

  Future<void> sharedPreferencesSetBool(bool value) async {
    await _sharedPreferences.setBool(key, value);
  }

  Future<void> asyncSharedPreferencesSetBool(bool value) async {
    await _sharedPreferencesAsync.setBool(key, value);
  }

  Future<void> cacheSharedPreferencesSetBool(bool value) async {
    await _sharedPreferencesWithCache.setBool(key, value);
  }

  bool sharedPreferencesGetBool() {
    return _sharedPreferences.getBool(key) ?? false;
  }

  Future<bool> asyncSharedPreferencesGetBool() async {
    return await _sharedPreferencesAsync.getBool(key) ?? false;
  }

  bool cacheSharedPreferencesGetBool() {
    return _sharedPreferencesWithCache.getBool(key) ?? false;
  }

  Future<bool> sharedPreferences(bool value) async {
    await sharedPreferencesSetBool(value);
    final result = sharedPreferencesGetBool();
    return result;
  }

  Future<bool> asyncSharedPreferences(bool value) async {
    await asyncSharedPreferencesSetBool(value);
    final result = await asyncSharedPreferencesGetBool();
    return result;
  }

  Future<bool> cacheSharedPreferences(bool value) async {
    await cacheSharedPreferencesSetBool(value);
    final result = cacheSharedPreferencesGetBool();
    return result;
  }

  Future<void> cleanAll() async {
    await _sharedPreferences.clear();
    await _sharedPreferencesAsync.clear();
    await _sharedPreferencesWithCache.clear();
  }
}

class SecureStorageService {
  const SecureStorageService({
    required FlutterSecureStorage storage,
  }) : _storage = storage;

  final FlutterSecureStorage _storage;
  final key = 'key';

  Future<bool> secureStorage(bool value) async {
    await _storage.write(key: key, value: value.toString());
    final result = await _storage.read(key: key);
    return result == 'true';
  }

  Future<void> clear() async {
    await _storage.delete(key: key);
  }
}

class RAMStorage {
  RAMStorage();

  final Map<String, RAMStorageEntity> storage = {};

  final key = 'key';

  T? _read<T>(String key) {
    if (storage[key] == null) return null;
    if (storage[key]!.expiringAt != null && storage[key]!.expiringAt!.isBefore(DateTime.now())) {
      storage.remove(key);
      return null;
    }
    return storage[key]?.data as T?;
  }

  void _write<T>({
    required String key,
    required T data,
    Duration? lifeTime,
    DateTime? expiringAt,
  }) {
    storage[key] = RAMStorageEntity(
      data: data,
      lifeTime: lifeTime,
      expiringAt: expiringAt,
    );
  }

  void clear() {
    storage.clear();
  }

  void _cleanByKey(String key) {
    storage.remove(key);
  }

  bool ramStorage(bool value) {
    _write<bool>(
      key: key,
      data: value,
    );
    final data = _read(key)?.data;
    return data ?? false;
  }
}

class RAMStorageEntity {
  const RAMStorageEntity({
    required this.data,
    this.lifeTime,
    this.expiringAt,
  });

  final dynamic data;
  final Duration? lifeTime;
  final DateTime? expiringAt;
}

class KeychainService {
  const KeychainService();

  final key = 'key';

  Future<bool> keychain(bool value) async {
    await write(value.toString(), key);
    final result = await read(key);
    return result == 'true';
  }

  Future<void> write<T>(T value, String key) async {
    await FlutterKeychain.put(value: value.toString(), key: key);
  }

  Future<String?> read(String key) async {
    return await FlutterKeychain.get(key: key);
  }
}
