import 'dart:async';
import 'dart:io';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:botola_max/views/loading_splash.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:botola_max/lib.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

final DateTime competitionExpire = DateTime.now().subtract(Duration(hours: 24));
final GlobalKey keyTextSlogan = GlobalKey();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS) && kDebugMode) {
    await WakelockPlus.enable();
  }
  final SettingsController settingsController = SettingsController();
  await settingsController.loadSettings();

  runApp(
    ChangeNotifierProvider(
      create: (context) {
        return AppState.empty(settingsController.fallback);
      },
      child: ThemeProvider(
        initTheme: mainTheme(dark: settingsController.isDark),
        duration: Duration(seconds: 1),
        builder: (context, theme) {
          return GetMaterialApp(
            title: 'Botola Max',
            locale: const Locale('en'),
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: Builder(
              builder: (context) {
                Get.put<SettingsController>(settingsController, tag: SharedPreferencesKeys.settingController.name);
                return SplashScreen();
              },
            ),
          );
        },
      ),
    ),
  );
}
