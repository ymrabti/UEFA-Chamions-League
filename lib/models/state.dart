import 'package:flutter/material.dart';
import 'package:botola_max/lib.dart';

class AppState extends ChangeNotifier {
  Map<String, DataCompetition> data = <String, DataCompetition>{};
  Map<String, String> _mapCrests = <String, String>{};

  set setData(Map<String, DataCompetition> datum) => data = datum;

  Map<String, String> get getMapCrests => _mapCrests;

  set setMapCrests(Map<String, String> newCrests) {
    _mapCrests = newCrests;
    notifyListeners();
  }

  double _visiblePercentage = 100;
  double get visiblePercentage => _visiblePercentage;
  set visiblePercent(double p) {
    _visiblePercentage = p;
    notifyListeners();
  }

  final String fallback;
  bool loading = false;
  void setLoading(bool l) {
    loading = l;
    notifyListeners();
  }

  Map<String, bool> expansion = <String, bool>{};
  void setExpansion(String compID, bool datum) {
    expansion.addAll(<String, bool>{compID: datum});
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
    data.addAll(<String, DataCompetition>{compID: datum});
    List<String> lcrests = datum.teams.teams.map((Teams e) => e.crest).toList();
    FallBackMap locateds = await SharedPrefsDatabase.updateLocalCrests(lcrests);

    MapCompetitions dataClass = MapCompetitions(
      data.map((String key, DataCompetition value) => MapEntry<String, bool>(key, true)),
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
    return <String, Object?>{
      'data': data.map((String key, bool value) {
        return MapEntry<String, bool>(key, value);
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
