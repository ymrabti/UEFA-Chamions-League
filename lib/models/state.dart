import 'package:flutter/material.dart';
import 'package:uefa_champions_league/lib.dart';

class AppState extends ChangeNotifier {
  Map<String, DataCompetition> data = {};
  Map<String, bool> expansion = {};

  bool loading = false;

  void setLoading(l) {
    loading = l;
    notifyListeners();
  }

  void setExpansion(String compID, bool datum) {
    expansion.addAll({compID: datum});
    notifyListeners();
  }

  void setExpansionAll(Iterable<MapEntry<String, bool>> newEntries) {
    expansion.addEntries(newEntries);
    notifyListeners();
  }

  bool getEntryExpansion(String uuid) {
    return expansion[uuid] ?? false;
  }

  void addCompetition(String compID, DataCompetition datum) {
    data.addAll({compID: datum});
    notifyListeners();
  }

  bool isCompExist(String cID) => data.containsKey(cID);

  DataCompetition getCompetition(String cID) {
    DataCompetition? dataAt = data[cID];
    return dataAt as DataCompetition;
  }

  AppState();
}
