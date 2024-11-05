import 'dart:async';
import 'dart:io';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:botola_max/lib.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:wakelock_plus/wakelock_plus.dart';

final DateTime competitionExpire = DateTime.now().subtract(Duration(hours: kDebugMode ? 0 : 24));

final GlobalKey keyTextSlogan = GlobalKey();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS) && kDebugMode) {
    await WakelockPlus.enable();
  }
  tz.initializeTimeZones();
  final SettingsController settingsController = SettingsController();
  await settingsController.loadSettings();
  ElBotolaChampionsList competitions = await AppLogic.getCompetitions();
  BotolaHappening today = await AppLogic.getTodayMatches(competitions.competitions.map((e) => e.id));
  List<String> mapEmblems = competitions.competitions.map((e) => e.emblem).toList();
  Iterable<String> todayCrests = today.matches.map((e) => [e.homeTeam.crest, e.awayTeam.crest]).expand((_) => _);
  FallBackAndMap fallBackAndMap = await SharedPrefsDatabase.downloadCrests([...mapEmblems, ...todayCrests]);
  Map<String, String> allFileCrests = fallBackAndMap.map;
  Map<String, DataCompetition> availableCompetitionsData = await SharedPrefsDatabase.getAvailableCompetitions(fallBackAndMap.availableIds);

  runApp(
    ChangeNotifierProvider(
      create: (context) {
        return AppState(fallBackAndMap.fallback, availableCompetitionsData, allFileCrests);
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
                return HomeScreen(competitions, today);
              },
            ),
            /* home: SplashPage(
              seek: true,
              matchesAndStandings: matchesAndStands,
            ), */
          );
        },
      ),
    ),
  );
}
