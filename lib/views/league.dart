import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:uefa_champions_league/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:visibility_detector/visibility_detector.dart';

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

  final Map<String, GlobalKey> _expansionTileKeys = {};
  String _index = '';
  bool zoomed = false;
  String? _subIndex;

  void scrollToTile(String index, String? subIndex) {
    String key = subIndex ?? index;
    if (key == '') return;
    final GlobalKey<State<StatefulWidget>>? targetKey = _expansionTileKeys[key];
    if (targetKey == null) return;
    BuildContext? currentContext = _getContext(targetKey);
    if (currentContext == null) return;
    _test();
    /* if (zoomed) return;
    Scrollable.ensureVisible(
      currentContext,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    ).then((value) {
      setState(() {
        zoomed = true;
      });
    }); */
  }

  void _test() {
    GlobalKey<State<StatefulWidget>>? globalKey = widget.firstExpand?.globalKey;
    if (globalKey == null) return;
    BuildContext? currentContext = _getContext(globalKey);
    if (currentContext == null) return;
    if (zoomed) return;
    Scrollable.ensureVisible(
      currentContext,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    ).then((value) {
      setState(() {
        zoomed = true;
      });
    });
  }

  BuildContext? _getContext(GlobalKey<State<StatefulWidget>> targetKey) {
    BuildContext? currentContext = targetKey.currentContext;
    return currentContext;
  }

  @override
  void initState() {
    if (widget.model.competion.code == 'CL') {
      unawaited(startAudio());
    }
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500), // Animation duration
      vsync: this,
    );
    unawaited(SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]));

    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToTile(_index, _subIndex));
    super.initState();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
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
    DataCompetition snapData = widget.model.matchesStandings;
    return Scaffold(
      appBar: AppBar(
        title: _animated(Text(widget.model.competion.name)),
        leading: _animated(AppImageViewer(url: widget.model.competion.emblem, width: 40)),
        actions: [
          if (widget.model.competion.code == 'CL')
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
          Tooltip(
            message: 'Standing',
            child: InkWell(
              onTap: () async {
                await Get.to<void>(
                  () => Scaffold(
                    appBar: AppBar(
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppImageViewer(url: widget.model.competion.emblem, width: 40),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.model.competion.name + ' standings'),
                      ),
                    ),
                    body: ListView(
                      children: widget.model.matchesStandings.standings
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
                color: primaryColor,
                child: Icon(
                  Icons.table_rows_sharp,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Tooltip(
            message: 'Scorers',
            child: InkWell(
              onTap: () async {
                await Get.to<void>(
                  () => CompetitionScorers(
                    scorers: widget.model.matchesStandings.scorers,
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.all(12),
                color: primaryColor,
                child: Icon(
                  CupertinoIcons.person_2_alt,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(),
        ),
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[
          ClipPath(
            clipper: Customshape(),
            child: Stack(
              children: [
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(primarycolorPrimaryValue),
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
                              child: AppImageViewer(url: widget.model.competion.emblem),
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
          ),
          ...widget.stagesData.mapIndexed(
            (index, StagePhaseMatches e) {
              String eUuid = e.uuid;
              if (e.initiallyExpanded) {
                setState(() {
                  _index = eUuid;
                });
              }
              GlobalKey<State<StatefulWidget>> globalKey = e.globalKey;
              _expansionTileKeys[eUuid] = globalKey;
              return ExpansionTile(
                key: globalKey,
                onExpansionChanged: (value) {
                  context.read<AppState>().setExpansion(eUuid, value);
                },
                initiallyExpanded: context.watch<AppState>().getEntryExpansion(eUuid),
                title: Text(e.title),
                children: [
                  if (e.subPhase.isNotEmpty)
                    ...() {
                      return e.subPhase.mapIndexed(
                        (i, f) {
                          String fUuid = f.uuid;
                          if (f.initiallyExpanded) {
                            setState(() {
                              _subIndex = fUuid;
                            });
                          }
                          GlobalKey<State<StatefulWidget>> subGlobalKey = f.globalKey;
                          _expansionTileKeys[fUuid] = subGlobalKey;
                          Standing? groupStanding = f.groupStanding;
                          return ExpansionTile(
                            key: subGlobalKey,
                            initiallyExpanded: context.watch<AppState>().getEntryExpansion(fUuid),
                            onExpansionChanged: (value) {
                              context.read<AppState>().setExpansion(fUuid, value);
                            },
                            title: Text(f.title),
                            children: [
                              ...f.matches.map((e) => e.view()),
                              if (groupStanding != null) groupStanding.view(),
                            ],
                          );
                        },
                      );
                    }(),
                  if (e.matches.isNotEmpty) ...e.matches.map((e) => e.view()).toList()
                ],
              );
            },
          ).toList(),
          GoalRankk(
            goals: snapData.matches.toList().teamGoalRanking,
            goalRanking: snapData.matches.goalsStatistics,
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

class CompetitionScorers extends StatelessWidget {
  const CompetitionScorers({super.key, required this.scorers});
  final BotolaScorers scorers;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppImageViewer(url: scorers.competition.emblem, width: 40),
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(scorers.competition.name + ' scorers'),
        ),
      ),
      body: ListView(
        children: scorers.scorers.map(
          (e) {
            var penalties = e.penalties;
            var shirtNumber = e.player.shirtNumber;
            return Card(
              margin: EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${e.player.name}${shirtNumber != null ? ' (N° $shirtNumber)' : ''}'),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            child: Text(
                              e.player.nationality,
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(e.goals.toString()),
                        if (penalties != null) Text('(Penalties ' + e.penalties.toString() + ')'),
                      ],
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
