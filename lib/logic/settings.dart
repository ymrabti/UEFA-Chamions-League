import "package:botola_max/lib.dart";
import "package:flutter/foundation.dart";
import 'dart:io';
import "package:wakelock_plus/wakelock_plus.dart" show WakelockPlus;
import "package:get/get.dart";

import "package:intl/date_symbol_data_local.dart" show initializeDateFormatting;

class SettingsController with ChangeNotifier {
  SettingsController();

  final _SettingsService _settingsService = _SettingsService();

  late Brightness _themeMode;

  bool get isDark => _themeMode == Brightness.dark;

  late Settings _settings;

  Settings get settings => _settings;

  Future<void> loadSettings() async {
    if ((Platform.isAndroid || Platform.isIOS) && kDebugMode) {
      await WakelockPlus.enable();
    }
    _settings = await _settingsService._getSettings();
    _themeMode = _settings.brightness;
    await initializeDateFormatting();
    notifyListeners();
  }

  Future<void> saveSettings() async {
    await _settings.save(AppSaveNames.settings.name);
    notifyListeners();
  }

  Future<void> updateLocale() async {
    await _settings.save(AppSaveNames.settings.name);
    notifyListeners();
  }

  Future<void> updateThemeMode(Brightness? newThemeMode) async {
    if (newThemeMode == null) return;

    if (newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;

    await _settings.save(AppSaveNames.settings.name);
    Get.changeTheme(mainTheme(dark: newThemeMode == Brightness.dark));
    notifyListeners();
  }
}

class _SettingsService {
  Future<Settings> _getSettings() async {
    var __settings = await IGenericAppModel.load<Settings>(AppSaveNames.settings.name);
    return __settings?.value ?? Settings._defaultSettings();
  }
}

class Settings extends IGenericAppModel {
  final Brightness brightness;

  Settings({
    required this.brightness,
  });

  static Settings _defaultSettings() => Settings(
        brightness: Brightness.dark,
      );

  Settings copyWith({
    Brightness? brightness,
  }) {
    return Settings(brightness: brightness ?? this.brightness);
  }

  @override
  Map<String, String?> toJson() {
    return {
      SharedPreferencesKeys.brightness.name: brightness.name,
    };
  }

  factory Settings.fromJson(Map<String, Object?> json) {
    var bright = json[SharedPreferencesKeys.brightness.name] as String?;
    return Settings(
      brightness: bright == Brightness.light.name ? Brightness.light : Brightness.dark,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }
}

enum SharedPreferencesKeys {
  deviceId,
  inUpdate,
  brightness,
  authenticationTokens,
  authenticationUser,
  language,
  settingController,
  settings,
}
