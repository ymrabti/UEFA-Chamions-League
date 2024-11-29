import 'dart:async';
import 'package:botola_max/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

final List<String> elbrem = ['PL', 'CL', 'FL1', 'DED', 'CLI', 'PD', 'WC'];

class AppLeague extends StatefulWidget {
  const AppLeague({
    super.key,
    required this.competition,
    required this.refreshCompetition,
  });
  final RefreshCompetiton refreshCompetition;
  final TheCompetition competition;
  @override
  State<AppLeague> createState() => _AppLeagueState();
}

class _AppLeagueState extends State<AppLeague> with SingleTickerProviderStateMixin {
  double _visiblePercentage = 100.0;
  late AnimationController _controller;
  final AudioPlayer player = AudioPlayer();
  bool zoomed = false;
  bool _splashing = false;

  @override
  void initState() {
    String competitionCode = widget.competition.code;
    String anthem = widget.competition.anthem;
    if (competitionCode.isNotEmpty && anthem.isNotEmpty) {
      unawaited(startAudio(anthem));
    }
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500), // Animation duration
      vsync: this,
    );
    unawaited(SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]));
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToTile());
    super.initState();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    DataCompetition snapData = widget.refreshCompetition.dataMatches;
    String anthem = widget.competition.anthem;
    return Scaffold(
      appBar: AppBar(
        title: _animated(Text(widget.competition.name)),
        leading: _animated(
          AppFileImageViewer(
            url: context.watch<AppState>().exchangeCrest(widget.competition.emblem),
            width: 40,
            color: elbrem.contains(anthem)
                ? Theme.of(context).colorScheme.background.invers(
                      true,
                    )
                : null,
          ),
        ),
        actions: [
          if (anthem.isNotEmpty)
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
                color: Theme.of(context).primaryColor,
                child: AnimatedIcon(
                  icon: AnimatedIcons.pause_play,
                  size: 30,
                  color: Colors.white,
                  progress: _controller,
                ),
              ),
            ),
          Tooltip(
            message: 'Standing',
            child: InkWell(
              onTap: () async {
                await Get.to<void>(
                  () => LeagueStandings(model: widget.competition, standings: widget.refreshCompetition.dataMatches),
                );
              },
              child: Card(
                margin: EdgeInsets.all(12),
                color: Theme.of(context).primaryColor,
                child: Image.asset(
                  'assets/standing.png',
                  width: 40,
                  //   color: Colors.white,
                ),
              ),
            ),
          ),
          Tooltip(
            message: 'Scorers',
            child: InkWell(
              onTap: () async {
                await Get.to<void>(
                  () => CompetitionScorersPage(
                    scorers: widget.refreshCompetition.dataMatches.scorers,
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.all(12),
                color: Theme.of(context).primaryColor,
                child: Image.asset(
                  'assets/scorer.png',
                  width: 40,
                  //   color: Colors.white,
                ),
              ),
            ),
          ),
        ],
        flexibleSpace: Container(decoration: const BoxDecoration()),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          /* RefreshCompetiton? refreshCompetition =  */ await SharedPrefsDatabase.refreshCompetition(
            context: context,
            theCompetition: widget.competition,
          );
        },
        child: ListView(
          children: <Widget>[
            _brand(context),
            ...widget.refreshCompetition.stagePhaseData.map(
              (e) => e.view(
                context,
                //   splashedSize:getRenderBox(),
                splashedId: widget.refreshCompetition.expanded?.uuid,
                splashing: _splashing,
              ),
            ),
            _rank(snapData),
          ],
        ),
      ),
    );
  }

  GoalRankk _rank(DataCompetition snapData) {
    return GoalRankk(
      goals: snapData.matcheModel.matches.goalStatsTeam,
      goalRanking: snapData.matcheModel.matches.goalStatsCompetition,
    );
  }

  ClipPath _brand(BuildContext context) {
    return ClipPath(
      clipper: Customshape(),
      child: Stack(
        children: [
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).colorScheme.primary,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              VisibilityDetector(
                key: keyTextSlogan,
                onVisibilityChanged: (visibilityInfo) {
                  double visiblePercentage = visibilityInfo.visibleFraction * 100;
                  _visiblePercentage = visiblePercentage;
                  if (mounted) {
                    setState(() {});
                  }
                },
                child: _logoCompetition(),
              ),
              Expanded(
                //   width: Get.width * .75,
                child: Text(
                  widget.competition.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _logoCompetition() {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SizedBox(
          width: Get.width * .35,
          child: CustomPaint(
            painter: BorderedRadiusBoxPainter(
              backgroundColor: Colors.white,
              borderColor: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderWidth: 0,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: AppFileImageViewer(
                url: context.watch<AppState>().exchangeCrest(
                      widget.competition.emblem,
                    ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _animated(Widget child) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: _visiblePercentage > 10 ? null : child,
    );
  }

  Size? getRenderBox() {
    GlobalKey<State<StatefulWidget>>? globalKey = widget.refreshCompetition.expanded?.globalKey;
    if (globalKey == null) return null;
    BuildContext? currentContext = _getContext(globalKey);
    if (currentContext == null) return null;
    final RenderBox renderBox = currentContext.findRenderObject() as RenderBox;
    return renderBox.size;
  }

  void scrollToTile() {
    GlobalKey<State<StatefulWidget>>? globalKey = widget.refreshCompetition.expanded?.globalKey;
    if (globalKey == null) return;
    BuildContext? currentContext = _getContext(globalKey);
    if (currentContext == null) return;
    setState(() {
      _splashing = true;
    });
    if (zoomed) return;
    Scrollable.ensureVisible(
      currentContext,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    ).then((value) {
      setState(() {
        zoomed = true;
      });
      Future.delayed(
        Duration(milliseconds: 400),
        () {
          setState(() {
            _splashing = false;
          });
        },
      );
    });
  }

  BuildContext? _getContext(GlobalKey<State<StatefulWidget>> targetKey) {
    BuildContext? currentContext = targetKey.currentContext;
    return currentContext;
  }

  Future<void> startAudio(String anthem) async {
    await player.setAudioSource(AudioSource.asset(anthem));
    await player.setVolume(0.5);
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
}

class LeagueStandings extends StatelessWidget {
  const LeagueStandings({super.key, required this.model, required this.standings});

  final TheCompetition model;
  final DataCompetition standings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppFileImageViewer(
            url: context.watch<AppState>().exchangeCrest(model.emblem),
            width: 40,
            color: elbrem.contains(model.code) ? Theme.of(context).colorScheme.background.invers(true) : null,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.name + ' standings'),
        ),
      ),
      body: ListView(
        children: standings.standingModel.standings
            .map(
              (e) => e.view(),
            )
            .toList(),
      ),
    );
  }
}
