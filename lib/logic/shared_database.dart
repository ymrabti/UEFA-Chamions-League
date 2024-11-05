import 'dart:async';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:botola_max/lib.dart';
// import 'package:flutter/services.dart';
import 'package:path/path.dart' show basename;
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPrefsDatabase {
  static Future<Map<String, DataCompetition>> getAvailableCompetitions(Map<String, bool> availableIDs) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Iterable<Future<IGenericAppMap<DataCompetition>?>?> map2 = availableIDs.keys.map<Future<IGenericAppMap<DataCompetition>?>?>((e) {
      String? data = prefs.getString(e);
      if (data == null) return null;
      return IGenericAppModel.load<DataCompetition>(e);
    });
    List<IGenericAppMap<DataCompetition>?> map = await Future.wait(map2.whereNotNull());
    Iterable<DataCompetition> where = map
        .whereNotNull() //
        .where((d) => d.dateTime.isAfter(competitionExpire))
        .map((e) => e.value)
        .whereNotNull();
    return Map.fromEntries(where.map((e) => MapEntry<String, DataCompetition>(e.id, e)));
  }

  static Future<String> saveAssetImage(Directory appDirectory) async {
    // Load the image from assets as bytes
    ByteData byteData = await rootBundle.load('assets/max-botola-logo.png');
    Uint8List imageBytes = byteData.buffer.asUint8List();

    String fileName = 'max-botola-logo.png';
    String filePath = '${appDirectory.path}/$fileName';

    File file = File(filePath);
    await file.writeAsBytes(imageBytes);

    return filePath;
  }

  static Future<FallBackAndMap> downloadCrests(List<String> imageUrls) async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String fallback = await saveAssetImage(appDirectory);

    FallBackMap mapAll = await updateLocalCrests(
      imageUrls,
      appDirectory,
    );
    return FallBackAndMap(
      mapAll.map,
      fallback,
      mapAll.availableIds,
    );
  }

  static Future<FallBackMap> updateLocalCrests(List<String> imageUrls, Directory appDirectory) async {
    IGenericAppMap<MapCompetitions>? mapData = await IGenericAppModel.load<MapCompetitions>(AppSaveNames.available_competitions_data.name);
    Map<String, bool> availableCompetitionsIDs = mapData?.value?.data ?? {};
    Map<String, String> localCrests = mapData?.value?.crests ?? <String, String>{};
    Dio dio = Dio();
    List<MapEntry<String, String>?> urls = await Future.wait(
      imageUrls
          .where(
            (e) => !localCrests.keys.contains(e),
          )
          .toList()
          .map(
        (e) {
          return downloadImages(dio, appDirectory, e);
        },
      ),
    );
    Map<String, String> mapNew = Map<String, String>.fromEntries(urls.whereNotNull());
    Map<String, String> mapAll = mapNew..addAll(localCrests);
    if (mapNew.isNotEmpty) {
      await MapCompetitions(availableCompetitionsIDs, mapAll).save(AppSaveNames.available_competitions_data.name);
    }
    return FallBackMap(mapAll, availableCompetitionsIDs);
  }

  static Future<MapEntry<String, String>?> downloadImages(Dio dio, Directory appDirectory, String imageUrl) async {
    try {
      // Get the file name from the URL
      String fileName = basename(imageUrl);

      // Create a file path in the app's private directory
      String savePath = '${appDirectory.path}/$fileName';

      await dio.download(imageUrl, savePath);

      return MapEntry<String, String>(imageUrl, savePath);
    } catch (e) {
      logg('Failed to download $imageUrl: $e');
    }
    return null;
  }
}

abstract class BotolaServices {
  static String stageName(title) {
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

      default:
        return title;
    }
  }
}
