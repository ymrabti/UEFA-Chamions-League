import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:uefa_champions_league/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

final Key keyTextSlogan = Key('SPLASH');

String stageName(title) {
  switch (title) {
    case 'LEAGUE_STAGE':
      return "دور المجموعات";

    case 'PLAYOFFS':
      return "الأدوار التمهيدية";

    case 'LAST_16':
      return "دور الـ16";

    case 'QUARTER_FINALS':
      return "ربع النهائي";

    case 'SEMI_FINALS':
      return "نصف النهائي";

    case 'THIRD_PLACE':
      return "المركز الثالث";

    case 'BRONZE':
      return "البرونزية";

    case 'FINAL':
      return "النهائي";

    default:
      return title;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if ((Platform.isAndroid || Platform.isIOS) && kDebugMode) {
    await WakelockPlus.enable();
  }
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  MatchesAndStandings matchesAndStands = await AppLogic.uefaCLStandingsAndMatches();
  runApp(
    GetMaterialApp(
      title: 'UEFA Champions League',
      locale: const Locale('en'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Qatar2022',
        primarySwatch: primaryColor,
      ),
      home: SplashPage(
        seek: true,
        matchesAndStandings: matchesAndStands,
      ),
    ),
  );
}

class QatarWorldCup extends StatefulWidget {
  const QatarWorldCup({super.key, required this.matchesAndStandings});
  final MatchesAndStandings matchesAndStandings;
  @override
  State<QatarWorldCup> createState() => _ChampionsLeagueAppState();
}

class _ChampionsLeagueAppState extends State<QatarWorldCup> with SingleTickerProviderStateMixin {
  double _visiblePercentage = 100.0;
  late AnimationController _controller;
  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    unawaited(startAudio());
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500), // Animation duration
      vsync: this, // Required for animation in StatefulWidget
    );
    unawaited(SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]));

    super.initState();
  }

  Future<void> startAudio() async {
    await player.setAsset('assets/bg_audio.mp3');
    await player.setVolume(0.25);
    await player.setLoopMode(LoopMode.all);
    await player.play();
    // await player.pause();
    // await player.seek(const Duration(seconds: 10));
    // await player.setSpeed(2.0);
    // await player.stop();
  }

  Future<void> pauseAudio() async {
    await player.pause();
  }

  @override
  void dispose() {
    _controller.dispose();
    unawaited(pauseAudio());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MatchesAndStandings snapData = widget.matchesAndStandings;
    return Scaffold(
      appBar: AppBar(
        title: _animated(Text('Champions League')),
        leading: _animated(Image.asset('assets/logo-in.png')),
        actions: [
          InkWell(
            onTap: () async {
              if (_controller.isCompleted) {
                _controller.reverse();
              } else {
                _controller.forward();
              }
              if (player.playing) {
                await player.pause();
              } else {
                await player.play();
              }
            },
            child: Card(
              margin: EdgeInsets.all(12),
              color: primaryColor,
              child: AnimatedIcon(
                icon: AnimatedIcons.pause_play,
                size: 30,
                color: Colors.white,
                progress: _controller,
              ),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipPath(
              clipper: Customshape(),
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                color: const Color(primarycolorPrimaryValue),
                child: VisibilityDetector(
                  key: keyTextSlogan,
                  onVisibilityChanged: (visibilityInfo) {
                    double visiblePercentage = visibilityInfo.visibleFraction * 100;
                    _visiblePercentage = visiblePercentage;
                    setState(() {});
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: Get.width * .3,
                        child: Image.asset('assets/logo-in.png'),
                      ),
                      Expanded(
                        //   width: Get.width * .75,
                        child: const Text(
                          'Champions League',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ...ChampionsLeagueMatches.fromJson(testMatches).matches.modelData.map(
              // ...snapData.matches.modelData.map(
              (e) {
                return ExpansionTile(
                  title: Text(
                    stageName(e.stage),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  children: [
                    if (e.stage == 'LEAGUE_STAGE')
                      ...e.matches.fold(
                        [MonthMatches(month: DateTime.now(), matches: [])],
                        (value, element) {
                          var sameMonth = value.last.month.sameMonth(element.utcDate);
                          if (sameMonth) {
                            value.last.matches.add(element);
                          } else {
                            value.add(MonthMatches(month: element.utcDate, matches: [element]));
                          }
                          return value;
                        },
                      ).map(
                        (f) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 18.0, right: 10),
                            child: ExpansionTile(
                              title: Text(DateFormat.yMMMM().format(f.month)),
                              children: f.matches.map((e) => e.toView()).toList(),
                            ),
                          );
                        },
                      ),
                    if (e.stage != 'LEAGUE_STAGE') ...e.matches.map((e) => e.toView()).toList()
                  ],
                );
              },
            ),
            GoalRankk(
              goals: snapData.matches
                  /* .where(
                    (element) {
                      var matchTime = element.utcDate;
                      var isStarted = matchTime.isBefore(dateTime);
                      return isStarted;
                    },
                  ) */
                  .toList()
                  .goalsRanking(),
              goalRanking: snapData.matches.goalsRanking2(),
            ),

            // ...widget.standings.standings.map((e) => TableStanding(standing: e)),
          ],
        ),
      ),
    );
  }

  AnimatedSwitcher _animated(Widget child) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: _visiblePercentage > 10 ? null : child,
    );
  }
}
