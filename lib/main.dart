import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:uefa_champions_league/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uefa_champions_league/models/all_competitions.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if ((Platform.isAndroid || Platform.isIOS) && kDebugMode) {
    await WakelockPlus.enable();
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

//   MatchesAndStandings matchesAndStands = await AppLogic.getStandingsAndMatches('CL');
  ElBotolaChampionsList competitions = await AppLogic.getCompetitions();
  runApp(
    GetMaterialApp(
      title: 'El Botola Max',
      locale: const Locale('en'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Qatar2022',
        primarySwatch: primaryColor,
      ),
      home: HomeScreen(competitions),
      /* home: SplashPage(
        seek: true,
        matchesAndStandings: matchesAndStands,
      ), */
    ),
  );
}

final Key keyTextSlogan = Key('SPLASH');

String stageName(title) {
  switch (title) {
    case 'LEAGUE_STAGE':
      return "League stage";

    case 'PLAYOFFS':
      return "Playoffs";

    case 'LAST_16':
      return "Last 16";

    case 'QUARTER_FINALS':
      return "Quarter finals";

    case 'SEMI_FINALS':
      return "Semi finals";

    case 'THIRD_PLACE':
      return "Third place";

    case 'BRONZE':
      return "Bronze";

    case 'FINAL':
      return "Final";

    default:
      return title;
  }
}
