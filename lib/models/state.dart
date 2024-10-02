import 'package:flutter/material.dart';
import 'package:uefa_champions_league/lib.dart';

class AppState extends ChangeNotifier {
  Map<String, MatchesAndStandings> data = {};

  bool loading = false;

  void setLoading(l) {
    loading = l;
    notifyListeners();
  }

  void addCompetition(String compID, MatchesAndStandings datum) {
    data.addAll({compID: datum});
    notifyListeners();
  }

  bool isCompExist(String cID) => data.containsKey(cID);

  MatchesAndStandings getCompetition(String cID) {
    MatchesAndStandings? dataAt = data[cID];
    return dataAt as MatchesAndStandings;
  }

  AppState();
}
