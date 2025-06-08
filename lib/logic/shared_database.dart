import 'dart:async';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'package:botola_max/lib.dart';
import 'package:path/path.dart' show basename, extension;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_svg/flutter_svg.dart' hide SvgPicture;
import 'dart:ui' show Image, ImageByteFormat;
import 'dart:io';

class SvgTextToPngConverter {
  final String url;

  SvgTextToPngConverter(this.url);

  Future<void> convertSvgToPng(String outputPath) async {
    try {
      PictureInfo pictureInfo = await vg.loadPicture(
        SvgNetworkLoader(url),
        Get.context,
        clipViewbox: false,
      );

      Image? image = pictureInfo.picture.toImageSync(
        pictureInfo.size.width.floor(),
        pictureInfo.size.height.floor(),
      );
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes == null) return;
      File file = File(outputPath);
      file.writeAsBytesSync(pngBytes);
      pictureInfo.picture.dispose();
      return;
    } catch (e) {
      //   return null;
    }
  }
}

abstract class SharedPrefsDatabase {
  static Future<Map<String, DataCompetition>> getAvailableCompetitions(Map<String, bool> availableIDs) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Iterable<Future<IGenericAppMap<DataCompetition>?>?> mapp = availableIDs.keys.map(
      (String e) {
        String? data = prefs.getString(e);
        if (data == null) return null;
        return IGenericAppModel.load<DataCompetition>(e);
      },
    );
    List<IGenericAppMap<DataCompetition>?> map = await Future.wait(mapp.whereNotNull());
    Iterable<DataCompetition> where = map
        .whereNotNull() //
        .where((IGenericAppMap<DataCompetition> d) => d.dateTime.isAfter(competitionExpire))
        .map((IGenericAppMap<DataCompetition> e) => e.value)
        .whereNotNull();
    return Map<String, DataCompetition>.fromEntries(where.map((DataCompetition e) => MapEntry<String, DataCompetition>(e.id, e)));
  }

  static Future<String> saveAssetImage(Directory appDirectory) async {
    // Load the image from assets as bytes
    ByteData byteData = await rootBundle.load('assets/max-botola-logo.png');
    Uint8List imageBytes = byteData.buffer.asUint8List();

    String fileName = 'max-botola-logo.png';
    String filePath = '${appDirectory.path}/Botola-Max/$fileName';

    File file = File(filePath);
    await file.writeAsBytes(imageBytes);

    return filePath;
  }

  static Future<FallBackMap> updateLocalCrests(List<String> imageUrls) async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    IGenericAppMap<MapCompetitions>? mapData = await IGenericAppModel.load<MapCompetitions>(
      AppSaveNames.available_competitions_data.name,
    );
    Map<String, bool> availableCompetitionsIDs = mapData?.value?.data ?? <String, bool>{};
    Map<String, String> localCrests = mapData?.value?.crests ?? <String, String>{};
    Dio dio = Dio();
    List<MapEntry<String, String>?> urls = await Future.wait(
      imageUrls
          .where(
            (String e) => !localCrests.keys.contains(e),
          )
          .toList()
          .map(
        (String imageUrl) async {
          try {
            String bn = basename(imageUrl);
            late String fileName;
            String exte /******/ = extension(imageUrl);
            if (exte == '.svg') {
              fileName = bn.replaceAll('.svg', '.png');
              String outputPath = '${appDirectory.path}/Botola-Max/$fileName';
              await SvgTextToPngConverter(imageUrl).convertSvgToPng(
                outputPath,
              );
            } else {
              fileName = bn;
              await dio.download(
                imageUrl,
                '${appDirectory.path}/Botola-Max/$fileName',
                onReceiveProgress: (int count, int total) {
                  if (total < 0) return;
                  if (!imageUrl.endsWith('svg')) return;
                },
              );
            }

            return MapEntry<String, String>(imageUrl, '${appDirectory.path}/Botola-Max/$fileName');
          } catch (e) {
            logg('Failed to download $imageUrl: $e');
          }
          return null;
        },
      ),
    );
    Map<String, String> mapNew = Map<String, String>.fromEntries(urls.whereNotNull());
    Map<String, String> mapAll = mapNew..addAll(localCrests);
    if (mapNew.isNotEmpty) {
      await MapCompetitions(availableCompetitionsIDs, mapAll).save(
        AppSaveNames.available_competitions_data.name,
      );
    }
    return FallBackMap(map: mapAll, availableIds: availableCompetitionsIDs);
  }

  static Future<RefreshCompetiton?> refreshCompetition({
    required BuildContext context,
    required String code,
    required String type,
    bool getLocal = true,
  }) async {
    context.read<AppState>().setLoading(true);
    late DataCompetition dataMatches;
    bool exist = context.read<AppState>().isCompExist(code);
    if (exist && getLocal) {
      dataMatches = context.read<AppState>().getCompetition(code);
    } else {
      DataCompetition? dataCompetition = await AppLogic.getCompetitionByID(code, false);
      if (dataCompetition == null) return null;
      dataMatches = dataCompetition;
      if (!context.mounted) return null;
      await context.read<AppState>().addCompetition(code, dataMatches);
    }
    if (!context.mounted) return null;
    context.read<AppState>().cleanExpansion();
    List<Matche> list = dataMatches.matcheModel.matches..sort((Matche a, Matche b) => a.utcDate.compareTo(b.utcDate));
    List<Standing> standings = dataMatches.standingModel.standings;
    List<StagePhaseMatches> stagePhaseData = list.stagePhaseData(code: code, standings: standings, type: type);
    List<StagePhase> expd = stagePhaseData.extractStagePhasesWithFold();
    Iterable<MapEntry<String, bool>> stagedData = expd.map((StagePhase e) => MapEntry<String, bool>(e.uuid, e.initiallyExpanded));
    StagePhase? first1 = expd.firstWhereOrNull((StagePhase e) => e.initiallyExpanded && e.isSubPhase);
    StagePhase? first2 = expd.firstWhereOrNull((StagePhase e) => e.initiallyExpanded);
    StagePhase? expanded = first1 ?? first2;
    context.read<AppState>().setLoading(false);
    return RefreshCompetiton(
      expanded: expanded,
      stagePhaseData: stagePhaseData,
      stagedData: stagedData,
      dataCompetition: dataMatches,
    );
  }
}

abstract class BotolaServices {
  static String stageName(String title) {
    switch (title) {
      case AppConstants.LEAGUESTAGE:
        return "League stage";

      case AppConstants.GROUPSTAGE:
        return "Group stage";

      case AppConstants.PLAYOFFS:
        return "Playoffs";

      case AppConstants.LAST16:
        return "Last 16";

      case AppConstants.QUARTERFINALS:
        return "Quarter finals";

      case AppConstants.SEMIFINALS:
        return "Semi finals";

      case AppConstants.THIRDPLACE:
        return "Third place";

      case AppConstants.BRONZE:
        return "Bronze";

      case AppConstants.FINAL:
        return "Final";

      case AppConstants.REGULAR_SEASON:
        return "Regular season";

      default:
        return title;
    }
  }

  static String convertNumbers(String str) {
    return str
        .replaceAll(
          '٠',
          '0',
        )
        .replaceAll(
          '١',
          '1',
        )
        .replaceAll(
          '٢',
          '2',
        )
        .replaceAll(
          '٣',
          '3',
        )
        .replaceAll(
          '٤',
          '4',
        )
        .replaceAll(
          '٥',
          '5',
        )
        .replaceAll(
          '٦',
          '6',
        )
        .replaceAll(
          '٧',
          '7',
        )
        .replaceAll(
          '٨',
          '8',
        )
        .replaceAll(
          '٩',
          '9',
        );
  }

  static String statusMatch(String status) {
    switch (status) {
      case AppConstants.FINISHED:
        return "Finished";

      case AppConstants.TIMED:
        return "Next match";

      case AppConstants.IN_PLAY:
        return "Playing";

      case AppConstants.PAUSED:
        return "Half time";

      default:
        return status;
    }
  }

  static String durationMatch(String status, {String? matchStat}) {
    if (<String>['TIMED', 'SCHEDULED'].contains(matchStat)) return '';
    switch (status) {
      case 'PENALTY_SHOOTOUT':
        return " : Penalty shootout";

      case 'REGULAR':
        return " : Regular time";

      case 'EXTRA_TIME':
        return " : Extra time";

      default:
        return ' : ' + status;
    }
  }

  static Future<void> deleteFolderRecursively(String folderPath) async {
    final Directory directory = Directory(folderPath);

    if (await directory.exists()) {
      try {
        // List all files and subdirectories inside the folder
        final List<FileSystemEntity> contents = directory.listSync();
        logg(contents.length, name: 'FOLDER LENGTH');
        for (FileSystemEntity fileOrDir in contents) {
          // Delete each file and directory inside the folder
          await fileOrDir.delete(recursive: true);
        }
      } catch (e) {
        // print("Error deleting folder contents: $e");
      }
    } else {
      //   print("Folder does not exist.");
    }
  }
}

class RefreshCompetiton {
  DataCompetition dataCompetition;
  StagePhase? expanded;
  List<StagePhaseMatches> stagePhaseData;
  Iterable<MapEntry<String, bool>> stagedData;
  RefreshCompetiton({
    required this.dataCompetition,
    this.expanded,
    required this.stagePhaseData,
    required this.stagedData,
  });
}
