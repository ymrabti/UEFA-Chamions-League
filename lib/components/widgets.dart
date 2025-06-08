import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture, SvgTheme;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:botola_max/lib.dart';
import 'package:url_launcher/url_launcher.dart';

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
    String? lurl = url;
    if (lurl == null) return Image.asset('assets/logo-dark.png', width: width, height: height);
    String img = context.watch<AppState>().exchangeCrest(lurl);
    if (img.endsWith('.svg')) {
      return SvgPicture.file(
        File(img),
        width: width,
        height: height,
        fit: boxFit,
        /* ignore: deprecated_member_use
        color: color, */
        colorFilter: ColorFilter.mode(color ?? Colors.transparent, BlendMode.overlay),
        theme: SvgTheme(currentColor: color ?? Colors.white),
      );
    } else {
      return _image(img);
    }
  }

  Image _image(String url) {
    return Image(
      image: _imageSource(url),
      width: width,
      height: height,
      color: color,
      fit: boxFit,
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
          child: Image.asset(
            'assets/logo-dark.png',
            color: Colors.red,
            width: width,
            height: height,
          ),
        );
      },
    );
  }

  ImageProvider<Object> _imageSource(String? e) {
    var img = e;
    if (img == null) {
      return AssetImage(
        'assets/logo-dark.png',
      );
    }
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
      child: InkWell(
        onLongPress: () {
          context.read<AppState>().setLoading(false);
        },
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
      ),
    );
  }
}

class ScaffoldBuilder extends StatefulWidget {
  const ScaffoldBuilder({
    super.key,
    required this.body,
    this.backgroundColor,
    this.appBar,
  });
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;

  @override
  State<ScaffoldBuilder> createState() => _ScaffoldBuilderState();
}

final Connectivity connectivity = Connectivity();

Stream<ConnectivityResult> subscription = connectivity.onConnectivityChanged;

class _ScaffoldBuilderState extends State<ScaffoldBuilder> {
  ConnectivityResult _connectivityResult = ConnectivityResult.wifi;
  @override
  void initState() {
    subscription.listen((ConnectivityResult result) {
      if (!mounted) return;
      setState(() {
        _connectivityResult = result;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isConnected = [
      ConnectivityResult.mobile,
      ConnectivityResult.wifi,
      ConnectivityResult.bluetooth,
      ConnectivityResult.vpn,
    ].contains(_connectivityResult);
    return isConnected
        ? WidgetWithWaiter(
            child: Scaffold(
              backgroundColor: widget.backgroundColor,
              appBar: widget.appBar,
              body: widget.body,
            ),
          )
        : BotolaOffline();
  }
}

class BotolaWebsite extends StatelessWidget {
  const BotolaWebsite({super.key, required this.website});

  final String website;

  @override
  Widget build(BuildContext context) {
    return BootolaLinq(
      onTap: () async {
        !await launchUrl(Uri.parse(website), mode: LaunchMode.inAppBrowserView);
      },
      text: website,
    );
  }
}

class CompetitionEntry extends StatelessWidget {
  const CompetitionEntry({
    super.key,
    this.code,
    required this.type,
    required this.child,
  });

  final String? code;
  final String type;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        String? codeCompitition = code;
        if (codeCompitition == null) return;
        RefreshCompetiton? competition = await SharedPrefsDatabase.refreshCompetition(
          context: context,
          code: codeCompitition,
          type: type,
          getLocal: true,
        );
        if (competition == null) return;
        if (!context.mounted) return;
        // await Get.to(() => AppLeague(competition: competition));
        await competition.dataCompetition.theCompetition.toTheCompetition().gotoParticularCompetition(context);
      },
      child: child,
    );
  }
}

class InteractiveCrest extends StatelessWidget {
  const InteractiveCrest({
    super.key,
    required this.crest,
    required this.tag,
  });

  final String crest;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: InteractiveViewer(
        maxScale: crest.endsWith('.svg') ? 2000 : 16,
        child: Center(
          child: Hero(
            tag: tag,
            child: AppFileImageViewer(
              url: crest,
              width: Get.width,
            ),
          ),
        ),
      ),
    );
  }
}

class PlayerPosition extends StatelessWidget {
  const PlayerPosition({
    super.key,
    required this.position,
  });

  final String? position;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.personChalkboard)),
        Expanded(child: Text.rich(TextSpan(text: position))),
      ],
    );
  }
}

class BotolaContract extends StatelessWidget {
  const BotolaContract({
    super.key,
    required this.contractStart,
    required this.contractEnd,
  });

  final DateTime contractStart;
  final DateTime? contractEnd;

  @override
  Widget build(BuildContext context) {
    var ce = contractEnd;
    return Row(
      children: [
        SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.fileContract)),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: DateFormat.yMMMM().format(contractStart),
              children: [
                TextSpan(text: ' - '),
                if (ce != null) TextSpan(text: DateFormat.yMMMM().format(ce)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BotolaPersonAge extends StatelessWidget {
  const BotolaPersonAge({
    super.key,
    required this.birth,
  });

  final DateTime birth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.lifeRing)),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: (DateTime.now().difference(birth).inDays / 365).round().toString() + ' Y.O',
            ),
          ),
        ),
      ],
    );
  }
}

class BotolaNationality extends StatelessWidget {
  const BotolaNationality({
    super.key,
    required this.nationality,
  });

  final String? nationality;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.house)),
        Expanded(child: Text.rich(TextSpan(text: nationality))),
      ],
    );
  }
}
