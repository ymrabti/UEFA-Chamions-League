import 'package:uefa_champions_league/lib.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

abstract class AppLogic {
  static const String _CL_API = 'https://api.football-data.org/v4/competitions/CL';
  static final Map<String, String> _headers = {'X-Auth-Token': token};

  static Future<MatchesAndStandings> uefaCLStandingsAndMatches() async {
    ChampionsStandings standings = await _uefaCLStandings();
    ChampionsLeagueMatches matches = await _uefaCLMatches();
    return MatchesAndStandings(matches: matches.matches, standings: standings.standings);
  }

  static Future<ChampionsStandings> _uefaCLStandings() async {
    if (!kDebugMode) {
      var connect = GetConnect();
      var getGet = await connect.get('$_CL_API/standings', headers: _headers);

      if (getGet.isOk) {
        var fromJson = ChampionsStandings.fromJson(getGet.body);
        return fromJson;
      }
    }
    return ChampionsStandings.fromJson(testStandings);
  }

  static Future<ChampionsLeagueMatches> _uefaCLMatches() async {
    if (!kDebugMode) {
      var connect = GetConnect();
      var getGet = await connect.get('$_CL_API/matches', headers: _headers);

      if (getGet.isOk) {
        var fromJson = ChampionsLeagueMatches.fromJson(getGet.body);
        return fromJson;
      }
    }
    return ChampionsLeagueMatches.fromJson(testMatches);
  }
}

class MatchesAndStandings {
  List<Matche> matches = [];
  List<Standings> standings = [];
  MatchesAndStandings({required this.matches, required this.standings});
}
