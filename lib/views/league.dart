import 'dart:async';
import 'package:botola_max/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

final List<String> elbrem = <String>['PL', 'CL', 'FL1', 'DED', 'CLI', 'PD', 'WC'];

class AppLeague extends StatefulWidget {
  const AppLeague({
    super.key,
    required this.competition,
  });
  final RefreshCompetiton competition;
  @override
  State<AppLeague> createState() => _AppLeagueState();
}

class _AppLeagueState extends State<AppLeague> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final AudioPlayer player = AudioPlayer();
  bool _splashing = false;

  Future<void> startAudio(String anthem) async {
    // await player.setAudioSource(AudioSource.asset(anthem));
    await player.setVolume(0.15);
    // await player.setLoopMode(LoopMode.all);
    await player.play(AssetSource(anthem));
    player.onPlayerStateChanged.listen((PlayerState event) {
      if (event == PlayerState.completed) {
        player.seek(Duration.zero);
        player.resume();
        // player.play(AssetSource(anthem));
      }
    });
    // await player.pause();
    // await player.seek(const Duration(seconds: 10));
    // await player.setSpeed(2.0);
    // await player.stop();
  }

  @override
  void initState() {
    String competitionCode = widget.competition.dataCompetition.theCompetition.code;
    String anthem = widget.competition.dataCompetition.theCompetition.anthem;
    if (competitionCode.isNotEmpty && anthem.isNotEmpty) {
      unawaited(startAudio(anthem));
    }
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500), // Animation duration
      vsync: this,
    );
    unawaited(SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]));
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToTile());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    DataCompetition snapData = widget.competition.dataCompetition;
    String anthem = widget.competition.dataCompetition.theCompetition.anthem;
    String competitionCode = widget.competition.dataCompetition.theCompetition.code;
    return ScaffoldBuilder(
      appBar: AppBar(
        bottom: BotolaPlatform.isDesktop || BotolaPlatform.isWeb ? AppBar() : null,
        leading: _animated(
          AppFileImageViewer(
            url: widget.competition.dataCompetition.theCompetition.emblem,
            width: 40,
            color: elbrem.contains(competitionCode)
                ? Theme.of(context).colorScheme.surface.invers(
                      true,
                    )
                : null,
          ),
        ),
        title: _animated(
          Text(
            widget.competition.dataCompetition.theCompetition.name,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        actions: <Widget>[
          if (anthem.isNotEmpty)
            InkWell(
              onTap: () async {
                if (_controller.isCompleted) {
                  _controller.reverse();
                } else {
                  _controller.forward();
                }
                if (player.state == PlayerState.playing) {
                  await player.pause();
                } else {
                  await player.resume();
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
                  () => LeagueStandings(
                    model: widget.competition.dataCompetition.theCompetition,
                    standings: widget.competition.dataCompetition,
                  ),
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
                    scorers: widget.competition.dataCompetition.scorers,
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
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          RefreshCompetiton? refreshCompetition = await SharedPrefsDatabase.refreshCompetition(
            context: context,
            code: widget.competition.dataCompetition.theCompetition.code,
            type: widget.competition.dataCompetition.theCompetition.type,
            getLocal: false,
          );
          if (!mounted) return;
          if (refreshCompetition == null) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (BuildContext context) => AppLeague(
                competition: refreshCompetition,
              ),
            ),
          );
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _brand(),
              for (StagePhaseMatches match in widget.competition.stagePhaseData)
                match.view(
                  context,
                  //   splashedSize:getRenderBox(),
                  splashedId: widget.competition.expanded?.uuid,
                  splashing: _splashing,
                ),
              _rank(snapData),
            ],
          ),
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

  Builder _brand() {
    return Builder(builder: (BuildContext context) {
      return ClipPath(
        clipper: Customshape(),
        child: Stack(
          children: <Widget>[
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).colorScheme.primary,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                lovoVD(),
                Expanded(
                  //   width: Get.width * .75,
                  child: Text(
                    widget.competition.dataCompetition.theCompetition.name,
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
    });
  }

  Widget lovoVD() {
    return Builder(builder: (BuildContext context) {
      return VisibilityDetector(
        key: keyTextSlogan,
        onVisibilityChanged: (VisibilityInfo visibilityInfo) {
          double p = visibilityInfo.visibleFraction * 100;
          if (p % 5 != 0) return;
          context.read<AppState>().visiblePercent = p;
        },
        child: _logoCompetition(),
      );
    });
  }

  Widget _logoCompetition() {
    return Builder(builder: (BuildContext context) {
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
                url: widget.competition.dataCompetition.theCompetition.emblem,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _animated(Widget child) {
    return Builder(builder: (BuildContext context) {
      return AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: context.watch<AppState>().visiblePercentage > 30 ? null : child,
      );
    });
  }

  Size? getRenderBox() {
    GlobalKey<State<StatefulWidget>>? globalKey = widget.competition.expanded?.globalKey;
    if (globalKey == null) return null;
    BuildContext? currentContext = _getContext(globalKey);
    if (currentContext == null) return null;
    final RenderBox renderBox = currentContext.findRenderObject() as RenderBox;
    return renderBox.size;
  }

  void scrollToTile() {
    GlobalKey<State<StatefulWidget>>? globalKey = widget.competition.expanded?.globalKey;
    if (globalKey == null) return;
    BuildContext? currentContext = _getContext(globalKey);
    if (currentContext == null) return;
    _splashing = true;
    setState(() {});
    Scrollable.ensureVisible(
      currentContext,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    ).then((void value) {
      Future<void>.delayed(
        Duration(milliseconds: 400),
        () {
          _splashing = false;
          setState(() {});
        },
      );
    });
  }

  BuildContext? _getContext(GlobalKey<State<StatefulWidget>> targetKey) {
    BuildContext? currentContext = targetKey.currentContext;
    return currentContext;
  }

  Future<void> pauseAudio() async {
    await player.stop();
    await player.dispose();
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

  final BotolaCompetition model;
  final DataCompetition standings;

  @override
  Widget build(BuildContext context) {
    return ScaffoldBuilder(
      appBar: AppBar(
        bottom: BotolaPlatform.isDesktop || BotolaPlatform.isWeb ? AppBar() : null,
        leading: Padding(
          padding: EdgeInsets.all(8.0.r),
          child: AppFileImageViewer(
            url: (model.emblem),
            width: 40,
            color: elbrem.contains(model.code) ? Theme.of(context).colorScheme.surface.invers(true) : null,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.name + ' standings'),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            for (Standing tableStanding in standings.standingModel.standings) //
              tableStanding.view(),
          ],
        ),
      ),
    );
  }
}
