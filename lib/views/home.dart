import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:botola_max/lib.dart';

class ChampionshipModel extends ChampionshipModelParent {
  DataCompetition matchesStandings;
  ChampionshipModel({
    required super.assetAnthem,
    required super.color,
    required super.colorText,
    required super.competion,
    required this.matchesStandings,
  });
}

class ChampionshipModelParent {
  String assetAnthem;
  Color color;
  Color colorText;
  Competitions competion;
  ChampionshipModelParent({
    required this.assetAnthem,
    required this.color,
    required this.colorText,
    required this.competion,
  });
}

class HomeScreen extends StatelessWidget {
  const HomeScreen(
    this.competitions, {
    super.key,
  });
  final ElBotolaChampionsList competitions;
  @override
  Widget build(BuildContext context) {
    return WidgetWithWaiter(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Botola Max'),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/max-botola-logo.png',
            ),
          ),
          actions: [
            ThemeModeToggler(),
            if (kDebugMode)
              InkWell(
                onTap: () {},
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.textsms,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                ),
              )
          ],
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: competitions.competitions.map(
            (e) {
              String startYear = DateFormat.y().format(e.currentSeason.startDate);
              String endYear = DateFormat.y().format(e.currentSeason.endDate);
              return Card(
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: InkWell(
                  onTap: () => gotoParticularCompetition(context, e),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                    child: Row(
                      children: [
                        AppFileImageViewer(
                          width: 40,
                          url: context.watch<AppState>().exchangeCrest(e.emblem),
                          color: elbrem.contains(e.code) ? Theme.of(context).colorScheme.background.transform(true) : null,
                        ),
                        Gap(12),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: e.name,
                              children: [
                                TextSpan(
                                  text: ' (${e.code})',
                                  style: TextStyle(fontSize: 10),
                                ),
                                if (e.type == 'LEAGUE') ...[
                                  TextSpan(
                                    text: '\nMatchday: ',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  TextSpan(
                                    text: '${e.currentSeason.currentMatchday}',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor.transform(
                                              Theme.of(context).brightness == Brightness.dark,
                                            ),
                                        fontSize: 10),
                                  ),
                                ],
                                TextSpan(
                                  text: '\nSeason: $startYear/$endYear',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                            softWrap: true,
                            maxLines: 4,
                            // style: TextStyle(color: e.colorText),
                          ),
                        ),
                        Text(e.area.name)
                      ],
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  Future<void> gotoParticularCompetition(BuildContext context, Competitions e) async {
    context.read<AppState>().setLoading(true);
    late DataCompetition dataMatches;
    var exist = context.read<AppState>().isCompExist(e.code);
    if (exist) {
      dataMatches = context.read<AppState>().getCompetition(e.code);
    } else {
      dataMatches = await AppLogic.getCompetitionByID(e.code);
      if (!context.mounted) return;
      await context.read<AppState>().addCompetition(e.code, dataMatches);
    }
    if (!context.mounted) return;
    context.read<AppState>().cleanExpansion();

    List<Matche> list = dataMatches.matcheModel.matches..sort((a, b) => a.utcDate.compareTo(b.utcDate));
    List<StagePhaseMatches> stagePhaseData = list.stagePhaseData(
      code: e.code,
      standings: dataMatches.standingModel.standings,
      type: e.type,
    );
    List<StagePhase> expd = extractStagePhasesWithFold(stagePhaseData);
    Iterable<MapEntry<String, bool>> stagedData = expd.map(
      (e) => MapEntry(e.uuid, e.initiallyExpanded),
    );
    StagePhase? expanded = expd.firstWhereOrNull(
          (e) => e.initiallyExpanded && e.isSubPhase,
        ) ??
        expd.firstWhereOrNull(
          (e) => e.initiallyExpanded,
        );
    context.read<AppState>().setExpansionAll(stagedData);
    context.read<AppState>().setLoading(false);
    await Get.to<void>(
      () {
        return AppLeague(
          stagesData: stagePhaseData,
          firstExpand: expanded,
          model: ChampionshipModel(
            assetAnthem: e.anthem,
            competion: e,
            color: Colors.pink,
            colorText: Colors.black45,
            matchesStandings: dataMatches,
          ),
        );
      },
      arguments: {'competition-id': e.code},
    );
  }
}

class AppImageViewer extends StatelessWidget {
  const AppImageViewer({
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
        return FittedBox(
          child: Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
            size: 30,
          ),
        );
      },
    );
  }

  ImageProvider<Object> _imageSource(String? e) {
    var img = e;
    if (img == null) return AssetImage('assets/logo-light.png');
    if (img.endsWith('.svg')) {
      return Svg(img, source: SvgSource.network);
    } else {
      return NetworkImage(img);
    }
  }
}

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
