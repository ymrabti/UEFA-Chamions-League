import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;
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
    this.boxFit = BoxFit.fill,
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
    var lurl = url;
    if (lurl == null) return Image.asset('assets/logo-light.png');
    var img = context.watch<AppState>() /*  */ .exchangeCrest(lurl);
    if (img.endsWith('.svg')) {
      return SvgPicture.file(
        File(img),
        width: width,
        height: height,
        fit: boxFit,
        // ignore: deprecated_member_use
        color: color,
        // colorFilter: ColorFilter.mode(color ?? Colors.transparent, BlendMode.overlay),
        // theme: SvgTheme(currentColor: color ?? Colors.white),
      );
    } else {
      return _image(img);
    }
  }

  Image _image(String url) {
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
        return FittedBox(
          child: Image.asset('assets/logo-light.png'),
        );
      },
    );
  }

  ImageProvider<Object> _imageSource(String? e) {
    var img = e;
    if (img == null) return AssetImage('assets/logo-light.png');
    return FileImage(File(img));
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

class ScaffoldWidget extends StatelessWidget {
  const ScaffoldWidget({
    super.key,
    required this.body,
    this.backgroundColor,
    this.appBar,
  });
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return WidgetWithWaiter(
      child: Scaffold /*  */ (
        appBar: appBar,
        body: body,
      ),
    );
  }
}
