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
        primarySwatch: primarycolor,
      ),
      home: SplashPage(
        seek: true,
        matchesAndStandings: matchesAndStands,
      ),
    ),
  );
}

class MonthMatches {
  DateTime month;
  List<Matche> matches;
  MonthMatches({required this.month, required this.matches});
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

    var dateTime = DateTime.now().toUtc();

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
              color: primarycolor,
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
            ...modelData(snapData.matches).map(
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
              gls: goalsRanking(snapData.matches.where(
                (element) {
                  var matchTime = element.utcDate;
                  var isStarted = matchTime.isBefore(dateTime);
                  return isStarted;
                },
              ).toList()),
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

// SizedBox(width: Get.width * .75, child: Image.asset('assets/qatar_word.png')),
// ...widgets(widget.matches.matches).map((e) => e.view()),
/* ListView.builder(
    itemCount: widgets2.length,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) => _buildList(widgets2[index]),
), */
// leading: list.icon != null ? Icon(list.icon) : null,
bool ine(Matche e) => e.homeTeam.crest.isNotEmpty;

class GroupMatches {
  String group;
  List<Matche> matches;
  GroupMatches({required this.group, required this.matches});
}

class StageWithMatches {
  String stage;
  List<Matche> matches;
  List<GroupMatches> groupMatches = [];
  StageWithMatches({required this.stage, required this.matches, this.groupMatches = const []});
  Widget view() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            stage,
            style: const TextStyle(
              fontSize: 36,
              color: Color(0xFFA9A9A9),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...matches.where(ine).map((e) => e.toView())
      ],
    );
  }
}

List<GoalRanking> goalsRanking(List<Matche> matches) {
  var gls = matches.fold<List<GoalRanking>>(
    matches.fold(
      [],
      (previousRankings, currentMatche) {
        if (previousRankings.where((e) => e.team == currentMatche.homeTeam).isEmpty) {
          previousRankings.add(GoalRanking(team: currentMatche.homeTeam));
        }
        return previousRankings;
      },
    ),
    (previousMatches2, currentMatche2) {
      var homeTeam = previousMatches2.firstWhereOrNull((e) => e.team == currentMatche2.homeTeam);
      var awayTeam = previousMatches2.firstWhereOrNull((e) => e.team == currentMatche2.awayTeam);
      if (awayTeam != null) {
        awayTeam.increaseReceiveFullTime = currentMatche2.score.fullTime.home;
        awayTeam.increaseScoredFullTime = currentMatche2.score.fullTime.away;
        //
        awayTeam.increaseReceiveExtraTime = currentMatche2.score.extraTime.home;
        awayTeam.increaseScoredExtraTime = currentMatche2.score.extraTime.away;
        //
        awayTeam.increaseReceiveRegularTime = currentMatche2.score.regularTime.home;
        awayTeam.increaseScoredRegularTime = currentMatche2.score.regularTime.away;
        //
        awayTeam.increaseReceivePenalties = currentMatche2.score.penalties.home;
        awayTeam.increaseScoredPenalties = currentMatche2.score.penalties.away;
      }
      if (homeTeam != null) {
        homeTeam.increaseReceiveFullTime = currentMatche2.score.fullTime.away;
        homeTeam.increaseScoredFullTime = currentMatche2.score.fullTime.home;
        //
        homeTeam.increaseReceiveExtraTime = currentMatche2.score.extraTime.away;
        homeTeam.increaseScoredExtraTime = currentMatche2.score.extraTime.home;
        //
        homeTeam.increaseReceiveRegularTime = currentMatche2.score.regularTime.away;
        homeTeam.increaseScoredRegularTime = currentMatche2.score.regularTime.home;
        //
        homeTeam.increaseReceivePenalties = currentMatche2.score.penalties.away;
        homeTeam.increaseScoredPenalties = currentMatche2.score.penalties.home;
      }
      return previousMatches2;
    },
  );

  return gls;
}

List<StageWithMatches> modelData(List<Matche> matches) {
  var vari = matches.fold<List<StageWithMatches>>(
    [],
    (previousValue, element) {
      var wheras = previousValue.where((e) => e.stage == element.stage);
      if (wheras.isEmpty) {
        previousValue.add(StageWithMatches(stage: element.stage, matches: [element]));
      } else {
        wheras.first.matches.add(element);
      }
      return previousValue;
    },
  );
  List<StageWithMatches> groupStage = vari.where((e) => e.stage == 'LEAGUE_STAGE').toList();
  bool groupStageNotEmpty = groupStage.isNotEmpty;
  if (groupStageNotEmpty) {
    var expansionGroups = groupStage.first.matches.fold<List<GroupMatches>>([], (previousValue, element) {
      var wheras = previousValue.where((e) => e.group == element.group);
      if (wheras.isEmpty) {
        previousValue.add(GroupMatches(group: element.group, matches: [element]));
      } else {
        wheras.first.matches.add(element);
      }
      return previousValue;
    });
    expansionGroups.sort((a, b) => Comparable.compare(a.group, b.group));
    groupStage.first.groupMatches = expansionGroups;
  }
  return vari;
}

class GoalRanking {
  Team team;
  int scoredFT;
  int receivedFT;
  int scoredRT;
  int receivedRT;
  int scoredET;
  int receivedET;
  int scoredPT;
  int receivedPT;
  GoalRanking({
    required this.team,
    this.receivedFT = 0,
    this.scoredFT = 0,
    this.scoredRT = 0,
    this.receivedRT = 0,
    this.scoredET = 0,
    this.receivedET = 0,
    this.scoredPT = 0,
    this.receivedPT = 0,
  });

  set increaseReceivePenalties(int score) {
    receivedPT += score;
  }

  set increaseScoredPenalties(int score) {
    scoredPT += score;
  }

  set increaseReceiveExtraTime(int score) {
    receivedET += score;
  }

  set increaseScoredExtraTime(int score) {
    scoredET += score;
  }

  set increaseReceiveRegularTime(int score) {
    receivedRT += score;
  }

  set increaseScoredRegularTime(int score) {
    scoredRT += score;
  }

  set increaseReceiveFullTime(int score) {
    receivedFT += score;
  }

  set increaseScoredFullTime(int score) {
    scoredFT += score;
  }

  @override
  String toString() {
    return '${team.name} received: $receivedFT and scored $scoredFT';
  }
}
