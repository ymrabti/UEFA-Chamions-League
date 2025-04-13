import "dart:io";

import "package:botola_max/lib.dart";
import "package:flutter/foundation.dart";
import "package:get/get.dart";

import "package:intl/date_symbol_data_local.dart" show initializeDateFormatting;
import "package:path_provider/path_provider.dart";

class SettingsController with ChangeNotifier {
  SettingsController();

  final _SettingsService _settingsService = _SettingsService();

  late Brightness _themeMode;
  late final String fallback;

  bool get isDark => _themeMode == Brightness.dark;

  late Settings _settings;

  Settings get settings => _settings;

  Future<void> loadSettings() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    Directory('${appDirectory.path}/Botola-Max').createSync();
    String fallbackUrl = await SharedPrefsDatabase.saveAssetImage(appDirectory);
    _settings = await _settingsService._getSettings();
    _themeMode = _settings.brightness;
    fallback = fallbackUrl;
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
