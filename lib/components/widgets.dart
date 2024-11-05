import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:botola_max/lib.dart';

class AppFileImageViewer extends StatelessWidget {
  const AppFileImageViewer({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.color,
    this.boxFit = BoxFit.cover,
    this.blendMode,
  });
  final String? url;
  final BlendMode? blendMode;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit boxFit;
  @override
  Widget build(BuildContext context) {
    return Image(
      image: _imageSource(url),
      width: width, color: color,
      height: height, fit: boxFit,

      loadingBuilder: (context, child, loadingProgress) {
        var loading = loadingProgress;
        if (loading == null) return child;
        int? expectedTotalBytes = loading.expectedTotalBytes;
        if (expectedTotalBytes == null) return child;
        return CircularProgressIndicator(
          value: loading.cumulativeBytesLoaded / expectedTotalBytes,
        );
      },
      alignment: Alignment.center,

      colorBlendMode: blendMode,
      // frameBuilder: (context, child, frame, wasSynchronouslyLoaded) => wasSynchronouslyLoaded ? child : CupertinoActivityIndicator(),
      errorBuilder: (context, error, stackTrace) {
        log(error.toString());
        return Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
          size: 50,
        );
      },
    );
  }

  ImageProvider<Object> _imageSource(String? e) {
    var img = e;
    if (img == null) return AssetImage('assets/logo-light.png');
    if (img.endsWith('.svg')) {
      return Svg(img, source: SvgSource.file);
    } else {
      return FileImage(File(img));
    }
  }
}

class WidgetWithWaiter extends StatelessWidget {
  WidgetWithWaiter({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomThemeSwitchingArea(
      child: Stack(
        children: [
          child,
          if (context.watch<AppState>().loading)
            AbsorbPointer(
              child: Container(
                color: Theme.of(context).cardColor.withOpacity(0.4),
                width: Get.width,
                height: Get.height,
                child: Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: Theme.of(context).primaryColor,
                    size: 125,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
