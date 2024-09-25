import 'package:flutter/material.dart';

class Customshape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;

    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, height - 50);
    path.cubicTo(width * 0.4, height - 80, width * 0.68, height, width, height - 5);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

/* body: VimeoVideoPlayer(
vimeoPlayerModel: VimeoPlayerModel(
url: 'https://vimeo.com/70591644',

),
), */
/* body: ClipRect(
child: AspectRatio(
aspectRatio: videoPlayerController.value.aspectRatio,
child: VideoPlayer(videoPlayerController),
),
), */
/* FittedBox(
fit: BoxFit.fitWidth,
child: SizedBox(
width: Get.width,
height: Get.height,
child: AnimatedOpacity(
opacity: _visible ? 1.0 : 0.0,
duration: const Duration(milliseconds: 1000),
child: VideoPlayer(_controller),
),
),
), */