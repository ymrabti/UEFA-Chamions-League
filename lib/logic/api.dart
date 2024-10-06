import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:botola_max/lib.dart';
import 'package:http/http.dart' show Response, get;
import 'package:intl/intl.dart';

enum AppSaveNames {
  all_competitions,
  settings,
  available_competitions_data,
  today_matches,
}

abstract class AppLogic {
  static const String _CL_API = 'https://api.football-data.org/v4';
  static final Map<String, String> _headers = {'X-Auth-Token': token};

  static Future<DataCompetition> _getCompetition(String competionID) async {
    BotolaStandings standings = await _getStandings(competionID);
    BotolaMatches matches = await _getMatches(competionID);
    BotolaScorers scorers = await _getScorers(competionID);
    BotolaTeams teams = await _getTeams(competionID);
    return DataCompetition(
      id: competionID,
      matcheModel: matches,
      standingModel: standings,
      scorers: scorers,
      teams: teams,
    );
  }

  static Future<DataCompetition> getCompetitionByID(String competionID) async {
    IGenericAppMap? localAppCompetitions = await IGenericAppModel.load<DataCompetition>(competionID);
    DateTime? dateTime = localAppCompetitions?.dateTime;
    IGenericAppModel? value = localAppCompetitions?.value;
    if (dateTime == null || value == null || dateTime.isBefore(competitionExpire)) {
      IGenericAppModel? fromJson = await _getCompetition(competionID);
      await fromJson.save(competionID);
      return fromJson as DataCompetition;
    } else {
      return value as DataCompetition;
    }
  }

  static Future<T?> _iGetIt<T extends IGenericAppModel>(
    String path,
    String name, [
    Duration duration = const Duration(days: 1),
  ]) async {
    IGenericAppMap? localAppCompetitions = await IGenericAppModel.load<T>(name);
    DateTime? dateTime = localAppCompetitions?.dateTime;
    IGenericAppModel? value = localAppCompetitions?.value;
    if (dateTime == null || value == null || dateTime.isBefore(DateTime.now().subtract(duration))) {
      Response getGet = await get(Uri.parse('$_CL_API/$path'), headers: _headers);
      if (getGet.statusCode == 200) {
        IGenericAppModel? fromJson = IGenericAppModel.fromJson<T>(jsonDecode(getGet.body));
        await fromJson?.save(name);
        return fromJson as T;
      }
    } else {
      return value as T;
    }
    return null;
  }

  static Future<BotolaHappening> getTodayMatches(Iterable<int> ids) async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String tomorrow = DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1)));
    BotolaHappening? dataGeneric = await _iGetIt<BotolaHappening>(
      'matches?dateFrom=$today&dateTo=$tomorrow&competitions=${ids.join(',')}',
      AppSaveNames.today_matches.name,
      Duration(hours: 1),
    );
    if (dataGeneric != null) return dataGeneric;
    return BotolaHappening.fromJson(testAllCompetitions);
  }

  static Future<ElBotolaChampionsList> getCompetitions() async {
    ElBotolaChampionsList? dataGeneric = await _iGetIt<ElBotolaChampionsList>(
      'competitions',
      AppSaveNames.all_competitions.name,
      Duration(days: 31),
    );
    if (dataGeneric != null) return dataGeneric;
    return ElBotolaChampionsList.fromJson(testAllCompetitions);
  }

  static Future<BotolaStandings> _getStandings(String competionID) async {
    var getGet = await get(Uri.parse('$_CL_API/competitions/$competionID/standings'), headers: _headers);

    if (getGet.statusCode == 200) {
      var fromJson = BotolaStandings.fromJson(jsonDecode(getGet.body));
      return fromJson;
    }
    return BotolaStandings.fromJson(testStandings);
  }

  static Future<BotolaMatches> _getMatches(String competionID) async {
    var getGet = await get(Uri.parse('$_CL_API/competitions/$competionID/matches'), headers: _headers);
    if (getGet.statusCode == 200) {
      var fromJson = BotolaMatches.fromJson(jsonDecode(getGet.body));
      return fromJson;
    }
    return BotolaMatches.fromJson(testChampionsLeagueMatches);
  }

  static Future<BotolaScorers> _getScorers(String competionID) async {
    var getGet = await get(Uri.parse('$_CL_API/competitions/$competionID/scorers'), headers: _headers);
    if (getGet.statusCode == 200) {
      var fromJson = BotolaScorers.fromJson(jsonDecode(getGet.body));
      return fromJson;
    }
    return BotolaScorers.fromJson(testChampionsLeagueMatches);
  }

  static Future<BotolaTeams> _getTeams(String competionID) async {
    var getGet = await get(Uri.parse('$_CL_API/competitions/$competionID/teams'), headers: _headers);
    if (getGet.statusCode == 200) {
      var fromJson = BotolaTeams.fromJson(jsonDecode(getGet.body));
      return fromJson;
    }
    return BotolaTeams.fromJson(testTeams);
  }
}

enum DataCompetitionEnum {
  matches,
  standings,
  scorers,
  teams,
  id,
}

class DataCompetition extends IGenericAppModel {
  String id;
  BotolaMatches matcheModel;
  BotolaStandings standingModel;
  BotolaScorers scorers;
  BotolaTeams teams;
  DataCompetition({
    required this.matcheModel,
    required this.standingModel,
    required this.scorers,
    required this.teams,
    required this.id,
  });

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  Map<String, Object?> toJson() {
    return {
      DataCompetitionEnum.id.name: id,
      DataCompetitionEnum.matches.name: matcheModel.toJson(),
      DataCompetitionEnum.standings.name: standingModel.toJson(),
      DataCompetitionEnum.scorers.name: scorers.toJson(),
      DataCompetitionEnum.teams.name: teams.toJson(),
    };
  }

  static DataCompetition fromJson(Map<String, Object?> data) {
    return DataCompetition(
      id: data[DataCompetitionEnum.id.name] as String,
      matcheModel: BotolaMatches.fromJson(data[DataCompetitionEnum.matches.name] as Map<String, Object?>),
      standingModel: BotolaStandings.fromJson(data[DataCompetitionEnum.standings.name] as Map<String, Object?>),
      scorers: BotolaScorers.fromJson(data[DataCompetitionEnum.scorers.name] as Map<String, Object?>),
      teams: BotolaTeams.fromJson(data[DataCompetitionEnum.teams.name] as Map<String, Object?>),
    );
  }
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
  static const String FINISHED = 'FINISHED';
  static const String TIMED = 'TIMED';
  static const String IN_PLAY = 'IN_PLAY';
  static const String PAUSED = 'PAUSED';
}
