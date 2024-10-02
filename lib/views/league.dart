import 'dart:async';
import 'package:uefa_champions_league/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AppLeague extends StatefulWidget {
  const AppLeague({super.key, required this.model});
  final ChampionshipModel model;
  @override
  State<AppLeague> createState() => _ChampionsLeagueAppState();
}

class _ChampionsLeagueAppState extends State<AppLeague> with SingleTickerProviderStateMixin {
  double _visiblePercentage = 100.0;
  late AnimationController _controller;
  final AudioPlayer player = AudioPlayer();

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
    MatchesAndStandings snapData = widget.model.matchesStandings;
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
            if (widget.model.competion.code == 'CL') ...snapData.matches.modelDataCL,
            if (widget.model.competion.type == 'CUP') ...snapData.matches.modelDataCup(snapData.standings),
            if (widget.model.competion.type == 'LEAGUE') ...snapData.matches.modelDataLeague,
            GoalRankk(
              goals: snapData.matches.toList().teamGoalRanking,
              goalRanking: snapData.matches.goalsStatistics,
            ),
          ],
        ),
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
