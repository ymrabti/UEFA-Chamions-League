import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:uefa_champions_league/lib.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uefa_champions_league/models/state.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if ((Platform.isAndroid || Platform.isIOS) && kDebugMode) {
    await WakelockPlus.enable();
    // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }
//   MatchesAndStandings matchesAndStands = await AppLogic.getStandingsAndMatches('CL');
//   ElBotolaChampionsList competitions = await AppLogic.getCompetitions();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: GetMaterialApp(
        title: 'El Botola Max',
        locale: const Locale('en'),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Qatar2022',
          primarySwatch: primaryColor,
        ),
        home: HomeScreen(),
        /* home: SplashPage(
          seek: true,
          matchesAndStandings: matchesAndStands,
        ), */
      ),
    ),
  );
}

final Key keyTextSlogan = Key('SPLASH');

String stageName(title) {
  switch (title) {
    case AppConstants.LEAGUESTAGE:
      return "League stage";

    case AppConstants.GROUPSTAGE:
      return "Group stage";

    case AppConstants.PLAYOFFS:
      return "Playoffs";

    case AppConstants.LAST16:
      return "Last 16";

    case AppConstants.QUARTERFINALS:
      return "Quarter finals";

    case AppConstants.SEMIFINALS:
      return "Semi finals";

    case AppConstants.THIRDPLACE:
      return "Third place";

    case AppConstants.BRONZE:
      return "Bronze";

    case AppConstants.FINAL:
      return "Final";

    default:
      return title;
  }
}
