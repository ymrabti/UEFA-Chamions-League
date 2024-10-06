import 'dart:async';
import 'package:collection/collection.dart';
import 'package:botola_max/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

final List<String> elbrem = ['PL', 'CL', 'FL1', 'DED', 'CLI', 'PD', 'WC'];

class AppLeague extends StatefulWidget {
  const AppLeague({
    super.key,
    required this.model,
    required this.stagesData,
    this.firstExpand,
  });
  final ChampionshipModel model;
  final List<StagePhaseMatches> stagesData;
  final StagePhase? firstExpand;
  @override
  State<AppLeague> createState() => _ChampionsLeagueAppState();
}

class _ChampionsLeagueAppState extends State<AppLeague> with SingleTickerProviderStateMixin {
  double _visiblePercentage = .0;
  late AnimationController _controller;
  final AudioPlayer player = AudioPlayer();

  bool zoomed = false;
  bool _splashing = false;

  Size? getRenderBox() {
    GlobalKey<State<StatefulWidget>>? globalKey = widget.firstExpand?.globalKey;
    if (globalKey == null) return null;
    BuildContext? currentContext = _getContext(globalKey);
    if (currentContext == null) return null;
    final RenderBox renderBox = currentContext.findRenderObject() as RenderBox;
    return renderBox.size;
  }

  void scrollToTile() {
    GlobalKey<State<StatefulWidget>>? globalKey = widget.firstExpand?.globalKey;
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

  @override
  void initState() {
    String competitionCode = widget.model.competion.code;
    String anthem = widget.model.assetAnthem;
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

  @override
  Widget build(BuildContext context) {
    DataCompetition snapData = widget.model.matchesStandings;
    String anthem = widget.model.competion.anthem;
    return Scaffold(
      appBar: AppBar(
        title: _animated(Text(widget.model.competion.name)),
        leading: _animated(
          AppFileImageViewer(
            url: context.watch<AppState>().exchangeCrest(widget.model.competion.emblem),
            width: 40,
            color: elbrem.contains(anthem)
                ? Theme.of(context).colorScheme.background.transform(
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
                  () => Scaffold(
                    appBar: AppBar(
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppFileImageViewer(
                          url: context.watch<AppState>().exchangeCrest(widget.model.competion.emblem),
                          width: 40,
                          color: elbrem.contains(widget.model.competion.code) ? Theme.of(context).colorScheme.background.transform(true) : null,
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.model.competion.name + ' standings'),
                      ),
                    ),
                    body: ListView(
                      children: widget.model.matchesStandings.standingModel.standings
                          .map(
                            (e) => e.view(),
                          )
                          .toList(),
                    ),
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
                    scorers: widget.model.matchesStandings.scorers,
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
      body: ListView(
        children: <Widget>[
          _brand(context),
          ...widget.stagesData.map(
            (e) => e.view(
              context,
              //   splashedSize:getRenderBox(),
              splashedId: widget.firstExpand?.uuid,
              splashing: _splashing,
            ),
          ),
          _rank(snapData),
        ],
      ),
    );
  }

  GoalRankk _rank(DataCompetition snapData) {
    return GoalRankk(
      goals: snapData.matcheModel.matches.teamGoalRanking,
      goalRanking: snapData.matcheModel.matches.goalsStatistics,
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
                child: Padding(
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
                                widget.model.competion.emblem,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                //   width: Get.width * .75,
                child: Text(
                  widget.model.competion.name,
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
}

class CompetitionScorersPage extends StatelessWidget {
  const CompetitionScorersPage({super.key, required this.scorers});
  final BotolaScorers scorers;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppFileImageViewer(
            url: context.watch<AppState>().exchangeCrest(scorers.competition.emblem),
            width: 40,
            color: elbrem.contains(scorers.competition.code) ? Theme.of(context).colorScheme.background.transform(true) : null,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(scorers.competition.name + ' scorers'),
        ),
      ),
      body: ListView(
        children: scorers.scorers.mapIndexed(
          (i, e) {
            int? penalties = e.penalties;
            int? assists = e.assists;
            int? shirtNumber = e.player.shirtNumber;
            DateTime? dateOfBirth2 = e.player.dateOfBirth;
            return Card(
              margin: EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Text(
                    '${e.player.name}${shirtNumber != null ? ' (N° $shirtNumber)' : ''}',
                  ),
                  subtitle: Text(
                    'Goals: ${e.goals}',
                    style: TextStyle(fontSize: 10),
                  ),
                  leading: Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('#${i + 1}'),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          AppFileImageViewer(
                            url: context.watch<AppState>().exchangeCrest(e.team.crest),
                            width: 36,
                            height: 36,
                          ),
                          Gap(8),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                                  child: Text.rich(
                                    TextSpan(
                                      text: 'Position',
                                      children: [
                                        TextSpan(text: ': '),
                                        TextSpan(
                                          text: e.player.section,
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColor.transform(
                                                  Theme.of(context).brightness == Brightness.dark,
                                                ),
                                          ),
                                        ),
                                        TextSpan(text: ' for '),
                                        TextSpan(
                                          text: e.team.name,
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColor.transform(
                                                  Theme.of(context).brightness == Brightness.dark,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                                  child: Text.rich(
                                    TextSpan(
                                      text: 'Home',
                                      children: [
                                        TextSpan(text: ': '),
                                        TextSpan(
                                          text: e.player.nationality,
                                          style: TextStyle(
                                              color: Theme.of(context).primaryColor.transform(
                                                    Theme.of(context).brightness == Brightness.dark,
                                                  )),
                                        ),
                                        TextSpan(text: ' '),
                                        if (dateOfBirth2 != null) TextSpan(text: '(${DateTime.now().difference(dateOfBirth2).inDays ~/ 365} yo)'),
                                      ],
                                    ),
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Gap(8),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Played matches ${e.playedMatches}',
                                style: TextStyle(fontSize: 10),
                              ),
                              if (penalties != null)
                                Text(
                                  'Penalties $penalties',
                                  style: TextStyle(fontSize: 10),
                                ),
                              if (assists != null)
                                Text(
                                  'Assists $assists',
                                  style: TextStyle(fontSize: 10),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
