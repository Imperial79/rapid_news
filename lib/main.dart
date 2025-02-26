import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rapid_news/Helper/hive_init.dart';
import 'Helper/router_config.dart';
import 'Resources/colors.dart';
import 'Resources/commons.dart';
import 'Resources/theme.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final hasConnection = ValueNotifier(true);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveHelper.init();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final StreamSubscription<InternetStatus> _subscription;
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _subscription = InternetConnection().onStatusChange.listen((status) {
      switch (status) {
        case InternetStatus.connected:
          hasConnection.value = true;
          break;
        case InternetStatus.disconnected:
          hasConnection.value = false;
          break;
      }
    });
    _listener = AppLifecycleListener(
      onResume: _subscription.resume,
      onHide: _subscription.pause,
      onPause: _subscription.pause,
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    systemColors();

    final routerConfig = ref.watch(goRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'NGF Organic - Sustainable Shop',
      color: Kolor.scaffold,
      theme: kTheme(context),
      themeMode: ThemeMode.light,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
      routerConfig: routerConfig,
    );
  }
}
