import 'dart:async';
import 'package:uefa_champions_league/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key, required this.seek, required this.matchesAndStandings}) : super(key: key);
  final MatchesAndStandings matchesAndStandings;
  final bool seek;
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late VideoPlayerController _controller;
  bool _visible = false;

  bool _ended = false;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _controller = VideoPlayerController.networkUrl(
      Uri(
        scheme: 'https',
        host: 'node-auth-master.youmrabti.com',
        path: 'uefa-cl-intro.mp4',
      ),
    ) //
      ..initialize().then((_) {
        _controller.seekTo(const Duration(seconds: 20));
        // _controller.setVolume(0);
        // _controller.setPlaybackSpeed(3);
        _controller.play().then((value) => setState(() {}));
      });

    _controller.addListener(() async {
      bool ended = _controller.value.position == _controller.value.duration;
      if (ended) {
        if (!_ended) {
          setState(() {
            _ended = ended;
          });
        } else {
          await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

          await Get.offUntil(
            MaterialPageRoute(
              builder: (context) => QatarWorldCup(
                matchesAndStandings: widget.matchesAndStandings,
              ),
            ),
            (e) => false,
          );
        }
      }
    });
    Timer(const Duration(milliseconds: 100), () async {
      setState(() {
        _visible = true;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),
      //   child: VideoPlayer(_controller),
      // scaleY: Get.height / (videoH),
      // scaleX: Get.width / (videoW),
      child: Container(
        color: Colors.green,
        width: Get.width,
        height: Get.height,
        child: _controller.value.isInitialized
            ? AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 1000),
                child: AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller)),
              ) //
            : Container(color: primarycolor, width: Get.width, height: Get.height),
      ),
    );
  }
}
