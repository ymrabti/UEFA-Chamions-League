import 'dart:convert';
import 'dart:developer';

import 'package:uefa_champions_league/lib.dart';
import 'package:http/http.dart' show get;

abstract class AppLogic {
  static const String _CL_API = 'https://api.football-data.org/v4/competitions';
  static final Map<String, String> _headers = {'X-Auth-Token': token};

  static Future<MatchesAndStandings> getStandingsAndMatches(String competionID) async {
    BotolaStandings standings = await _getStandings(competionID);
    BotolaLeagueMatches matches = await _getMatches(competionID);
    return MatchesAndStandings(
      matches: matches.matches,
      standings: standings.standings,
    );
  }

  static Future<ElBotolaChampionsList> getCompetitions() async {
    var getGet = await get(Uri.parse('$_CL_API/competitions'), headers: _headers);

    if (getGet.statusCode == 200) {
      var fromJson = ElBotolaChampionsList.fromJson(jsonDecode(getGet.body));
      return fromJson;
    }
    return ElBotolaChampionsList.fromJson(testStandings);
  }

  static Future<BotolaStandings> _getStandings(String competionID) async {
    var getGet = await get(Uri.parse('$_CL_API/$competionID/standings'), headers: _headers);

    if (getGet.statusCode == 200) {
      var fromJson = BotolaStandings.fromJson(jsonDecode(getGet.body));
      return fromJson;
    }
    return BotolaStandings.fromJson(testStandings);
  }

  static Future<BotolaLeagueMatches> _getMatches(String competionID) async {
    var getGet = await get(Uri.parse('$_CL_API/$competionID/matches'), headers: _headers);

    if (getGet.statusCode == 200) {
      var fromJson = BotolaLeagueMatches.fromJson(jsonDecode(getGet.body));
      return fromJson;
    }
    return BotolaLeagueMatches.fromJson(testChampionsLeagueMatches);
  }
}

class MatchesAndStandings {
  List<Matche> matches = [];
  List<Standing> standings = [];
  MatchesAndStandings({required this.matches, required this.standings});
}

void logg(dynamic message, {String name = 'BOTOLA'}) {
  log('$message', name: name);
}

abstract class AppConstants {
  static const String GROUPSTAGE = 'GROUP_STAGE';
  static const String LEAGUESTAGE = 'LEAGUE_STAGE';
  static const String LAST16 = 'LAST_16';
  static const String PLAYOFFS = 'PLAYOFFS';
  static const String QUARTERFINALS = 'QUARTER_FINALS';
  static const String SEMIFINALS = 'SEMI_FINALS';
  static const String THIRDPLACE = 'THIRD_PLACE';
  static const String FINAL = 'FINAL';
  static const String BRONZE = 'BRONZE';
}
