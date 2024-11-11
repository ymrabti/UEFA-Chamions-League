import 'dart:io';

import 'package:flutter/material.dart';
import 'package:botola_max/lib.dart';
import 'package:path_provider/path_provider.dart';

class AppState extends ChangeNotifier {
  Map<String, DataCompetition> data = {};
  Map<String, String> mapCrests = {};

  set setData(Map<String, DataCompetition> datum) => data = datum;

  get getMapCrests => mapCrests;

  set setMapCrests(Map<String, String> mapCrests) => this.mapCrests = mapCrests;

  final String fallback;
  bool loading = false;
  void setLoading(l) {
    loading = l;
    notifyListeners();
  }

  Map<String, bool> expansion = {};
  void setExpansion(String compID, bool datum) {
    expansion.addAll({compID: datum});
    notifyListeners();
  }

  void cleanExpansion() {
    expansion.clear();
    notifyListeners();
  }

  void setExpansionAll(Iterable<MapEntry<String, bool>> newEntries) {
    expansion.addEntries(newEntries);
    notifyListeners();
  }

  String exchangeCrest(String url) {
    return mapCrests[url] ?? fallback;
  }

  bool getEntryExpansion(String uuid) {
    return expansion[uuid] ?? false;
  }

  Future<void> addCompetition(String compID, DataCompetition datum) async {
    data.addAll({compID: datum});
    Directory appDirectory = await getApplicationDocumentsDirectory();
    FallBackMap locateds = await SharedPrefsDatabase.updateLocalCrests(datum.teams.teams.map((e) => e.crest).toList(), appDirectory);
    MapCompetitions dataClass = MapCompetitions(
      data.map((key, value) => MapEntry(key, true)),
      mapCrests..addAll(locateds.map),
    );
    await dataClass.save(AppSaveNames.available_competitions_data.name);
    notifyListeners();
  }

  bool isCompExist(String cID) => data.containsKey(cID);

  DataCompetition getCompetition(String cID) {
    DataCompetition? dataAt = data[cID];
    return dataAt as DataCompetition;
  }

  AppState(
    this.fallback,
    Map<String, DataCompetition> dataMap,
    Map<String, String> crests,
  ) {
    data = Map.from(dataMap);
    mapCrests = Map.from(crests);
  }

  AppState.empty(
    this.fallback, [
    Map<String, DataCompetition> dataMap = const {},
    Map<String, String> crests = const {},
  ]) {
    data = Map.from(dataMap);
    mapCrests = Map.from(crests);
  }
}

class MapCompetitions extends IGenericAppModel {
  final Map<String, bool> data;
  final Map<String, String> crests;

  MapCompetitions(this.data, this.crests);
  @override
  Map<String, Object?> toJson() {
    return {
      'data': data.map((key, value) {
        return MapEntry(key, value);
      }),
      'crests': crests,
    };
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  static MapCompetitions? fromJson(Map<String, Object?> json) {
    return MapCompetitions(
      Map<String, bool>.from(json['data'] as Map<String, dynamic>),
      Map<String, String>.from(json['crests'] as Map<String, dynamic>),
    );
  }
}
