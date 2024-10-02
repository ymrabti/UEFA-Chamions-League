import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uefa_champions_league/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key, required this.seek, required this.model}) : super(key: key);
  final ChampionshipModel model;
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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _controller = VideoPlayerController.asset('assets/uefa-cl-intro.mp4') //
      ..initialize().then((_) {
        if (kDebugMode) {
          _controller.seekTo(const Duration(seconds: 30));
          _controller.setVolume(0);
          _controller.setPlaybackSpeed(3);
        }
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
          await Get.offUntil(MaterialPageRoute(builder: (_) => AppLeague(model: widget.model)), (e) => false);
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),
      child: SizedBox(
        width: Get.width,
        height: Get.height,
        child: _controller.value.isInitialized
            ? AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 1000),
                child: AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller)),
              ) //
            : Container(color: primaryColor, width: Get.width, height: Get.height),
      ),
    );
  }
}
