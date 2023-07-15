import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'src/providers/scrcpy_provider.dart';
import 'src/providers/theme_provider.dart';
import 'src/providers/tray_manager_provider.dart';
import 'src/screen/home/home_screen.dart';
import 'src/utils/themes.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    maximumSize: Size(400, 510),
    minimumSize: Size(400, 510),
    backgroundColor: Colors.transparent,
    skipTaskbar: true,
    titleBarStyle: TitleBarStyle.hidden,
    alwaysOnTop: true,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    ref.read(trayManagerProvider.notifier).initialized();
    ref.read(adbDevicesProvider.notifier).initialized();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme(AppTheme.isLight),
      darkTheme: appTheme(AppTheme.isDark),
      themeMode: ref.watch(themeProvider),
      home: const HomeScreen(),
    );
  }
}
