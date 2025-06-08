import 'package:flutter/material.dart';
import 'package:botola_max/lib.dart';

class AppState extends ChangeNotifier {
  Map<String, DataCompetition> data = {};
  Map<String, String> _mapCrests = {};

  set setData(Map<String, DataCompetition> datum) => data = datum;

  get getMapCrests => _mapCrests;

  set setMapCrests(Map<String, String> newCrests) {
    _mapCrests = newCrests;
    notifyListeners();
  }

  final String fallback;
  bool loading = false;
  void setLoading(bool l) {
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
    return _mapCrests[url] ?? fallback;
  }

  bool getEntryExpansion(String uuid) {
    return expansion[uuid] ?? false;
  }

  Future<void> addCompetition(String compID, DataCompetition datum) async {
    data.addAll({compID: datum});
    var lcrests = datum.teams.teams.map((e) => e.crest).toList();
    FallBackMap locateds = await SharedPrefsDatabase.updateLocalCrests(lcrests);

    MapCompetitions dataClass = MapCompetitions(
      data.map((key, value) => MapEntry(key, true)),
      _mapCrests..addAll(locateds.map),
    );

    await dataClass.save(AppSaveNames.available_competitions_data.name);
    notifyListeners();
  }

  bool isCompExist(String cID) => data.containsKey(cID);

  DataCompetition getCompetition(String cID) {
    DataCompetition? dataAt = data[cID];
    return dataAt as DataCompetition;
  }

  AppState(this.fallback);
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
