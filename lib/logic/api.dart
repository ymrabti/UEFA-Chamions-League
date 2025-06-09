import 'dart:async';

import 'package:botola_max/lib.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

enum AppSaveNames {
  all_competitions,
  settings,
  available_competitions_data,
  today_matches,
}

abstract class AppLogic {
  static const String _CL_API = 'https://api.football-data.org/v4';
  static final Map<String, String> _headers = <String, String>{'X-Auth-Token': token};

  static Future<DataCompetition?> _getCompetition(String competionID) async {
    BotolaCompetition? competition = await _getCompetitionId(competionID);
    BotolaStandings? standings = await _getStandings(competionID);
    BotolaMatches? matches = await _getMatches(competionID);
    BotolaScorers? scorers = await _getScorers(competionID);
    BotolaTeams? teams = await _getTeams(competionID);
    if (standings /* *******/ == null || //
            matches /* *****/ == null ||
            scorers /* *****/ == null ||
            teams /* *******/ == null ||
            competition /* */ == null //
        ) {
      return null;
    }
    return DataCompetition(
      id: competionID,
      matcheModel: matches,
      standingModel: standings,
      scorers: scorers,
      teams: teams,
      theCompetition: competition,
    );
  }

  static Future<DataCompetition?> getCompetitionByID(
    String competionID, [
    bool getLocal = true,
  ]) async {
    IGenericAppMap<DataCompetition>? localAppCompetitions = await IGenericAppModel.load<DataCompetition>(competionID);
    DateTime? dateTime = localAppCompetitions?.dateTime;
    IGenericAppModel? value = localAppCompetitions?.value;
    if (dateTime == null || value == null || DateTime.now().isAfter(dateTime.add(getLocal ? Duration(days: 1) : Duration(minutes: 10)))) {
      IGenericAppModel? fromJson = await _getCompetition(competionID);
      await fromJson?.save(competionID);
      return fromJson as DataCompetition?;
    } else {
      return value as DataCompetition?;
    }
  }

  static Future<T?> _iGetIt<T extends IGenericAppModel>(
    String path,
    String name, [
    Duration duration = const Duration(days: 1),
  ]) async {
    IGenericAppMap<T>? localAppCompetitions = await IGenericAppModel.load<T>(name);
    DateTime? dateTime = localAppCompetitions?.dateTime;
    IGenericAppModel? value = localAppCompetitions?.value;
    if (dateTime == null || value == null || dateTime.isBefore(DateTime.now().subtract(duration))) {
      Response<Map<String, Object?>> getGet = await Dio().getUri(Uri.parse('$_CL_API/$path'), options: Options(headers: _headers));
      if (getGet.statusCode == 200) {
        Map<String, Object?>? data = getGet.data;
        if (data == null) return null;
        IGenericAppModel? fromJson = IGenericAppModel.fromJson<T>(data);
        await fromJson?.save(name);
        return fromJson as T;
      }
    } else {
      return value as T;
    }
    return null;
  }

  static Future<MatchDetailsModel?> getMatchDetails(int matchId) async {
    MatchDetailsModel? dataGeneric = await _iGetIt<MatchDetailsModel>(
      'matches/$matchId',
      'match_details_of_$matchId',
      Duration(minutes: 5),
    );
    if (dataGeneric != null) return dataGeneric;
    return null;
  }

  static Future<Teams?> getTeam(int teamId) async {
    Teams? dataGeneric = await _iGetIt<Teams>(
      'teams/$teamId',
      'team_of_$teamId',
      Duration(days: 30),
    );
    return dataGeneric;
  }

  static Future<BotolaXPerson?> person(int personId) async {
    BotolaXPerson? dataGeneric = await _iGetIt<BotolaXPerson>(
      'persons/$personId',
      'match_head2head_of_$personId',
      Duration(hours: 12),
    );
    if (dataGeneric != null) return dataGeneric;
    return null;
  }

  static Future<MatchHead2HeadModel?> head2head(int matchId) async {
    MatchHead2HeadModel? dataGeneric = await _iGetIt<MatchHead2HeadModel>(
      'matches/$matchId/head2head?limit=6',
      'match_head2head_of_$matchId',
      Duration(hours: 12),
    );
    if (dataGeneric != null) return dataGeneric;
    return null;
  }

  static Future<BotolaHappening?> getTodayMatches(Iterable<int> ids) async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String tomorrow = DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1)));
    BotolaHappening? dataGeneric = await _iGetIt<BotolaHappening>(
      'matches?dateFrom=$today&dateTo=$tomorrow&competitions=${ids.join(',')}',
      AppSaveNames.today_matches.name,
      Duration(hours: 1),
    );
    return dataGeneric;
  }

  static Future<ElBotolaChampionsList?> getCompetitions() async {
    ElBotolaChampionsList? dataGeneric = await _iGetIt<ElBotolaChampionsList>(
      'competitions',
      AppSaveNames.all_competitions.name,
      Duration(days: 31),
    );
    if (dataGeneric != null) return dataGeneric;
    return null;
  }

  static Future<BotolaCompetition?> _getCompetitionId(String competionID) async {
    Response<Map<String, Object?>> getGet = await Dio().getUri(
      Uri.parse('$_CL_API/competitions/$competionID'),
      options: Options(headers: _headers),
    );

    if (getGet.statusCode == 200) {
      Map<String, Object?>? data = getGet.data;
      if (data == null) return null;
      BotolaCompetition fromJson = BotolaCompetition.fromJson(data);
      return fromJson;
    }
    return null;
  }

  static Future<BotolaStandings?> _getStandings(String competionID) async {
    Response<Map<String, Object?>> getGet = await Dio().getUri(
      Uri.parse('$_CL_API/competitions/$competionID/standings'),
      options: Options(headers: _headers),
    );

    if (getGet.statusCode == 200) {
      Map<String, Object?>? data = getGet.data;
      if (data == null) return null;
      BotolaStandings fromJson = BotolaStandings.fromJson(data);
      return fromJson;
    }
    return null;
  }

  static Future<BotolaMatches?> _getMatches(String competionID) async {
    Response<Map<String, Object?>> getGet = await Dio().getUri(
      Uri.parse('$_CL_API/competitions/$competionID/matches'),
      options: Options(headers: _headers),
    );
    if (getGet.statusCode == 200) {
      Map<String, Object?>? data = getGet.data;
      if (data == null) return null;
      BotolaMatches fromJson = BotolaMatches.fromJson(data);
      return fromJson;
    }
    return null;
  }

  static Future<BotolaScorers?> _getScorers(String competionID) async {
    Response<Map<String, Object?>> getGet = await Dio().getUri(
      Uri.parse('$_CL_API/competitions/$competionID/scorers'),
      options: Options(headers: _headers),
    );
    if (getGet.statusCode == 200) {
      Map<String, Object?>? data = getGet.data;
      if (data == null) return null;
      BotolaScorers fromJson = BotolaScorers.fromJson(data);
      return fromJson;
    }
    return null;
  }

  static Future<BotolaTeams?> _getTeams(String competionID) async {
    Response<Map<String, Object?>> getGet = await Dio().getUri(
      Uri.parse('$_CL_API/competitions/$competionID/teams'),
      options: Options(headers: _headers),
    );
    if (getGet.statusCode == 200) {
      Map<String, Object?>? data = getGet.data;
      if (data == null) return null;
      BotolaTeams fromJson = BotolaTeams.fromJson(data);
      return fromJson;
    }
    return null;
  }
}

enum DataCompetitionEnum {
  matches,
  standings,
  scorers,
  teams,
  id,
  theCompetition,
}

class DataCompetition extends IGenericAppModel {
  String id;
  BotolaCompetition theCompetition;
  BotolaMatches matcheModel;
  BotolaStandings standingModel;
  BotolaScorers scorers;
  BotolaTeams teams;

  DataCompetition({
    required this.theCompetition,
    required this.standingModel,
    required this.matcheModel,
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
    return <String, Object?>{
      DataCompetitionEnum.id.name: id,
      DataCompetitionEnum.matches.name: matcheModel.toJson(),
      DataCompetitionEnum.standings.name: standingModel.toJson(),
      DataCompetitionEnum.scorers.name: scorers.toJson(),
      DataCompetitionEnum.teams.name: teams.toJson(),
      DataCompetitionEnum.theCompetition.name: theCompetition.toJson(),
    };
  }

  static DataCompetition fromJson(Map<String, Object?> data) {
    return DataCompetition(
      id: data[DataCompetitionEnum.id.name] as String,
      matcheModel: BotolaMatches.fromJson(data[DataCompetitionEnum.matches.name] as Map<String, Object?>),
      standingModel: BotolaStandings.fromJson(data[DataCompetitionEnum.standings.name] as Map<String, Object?>),
      scorers: BotolaScorers.fromJson(data[DataCompetitionEnum.scorers.name] as Map<String, Object?>),
      teams: BotolaTeams.fromJson(data[DataCompetitionEnum.teams.name] as Map<String, Object?>),
      theCompetition: BotolaCompetition.fromJson(data[DataCompetitionEnum.theCompetition.name] as Map<String, Object?>),
    );
  }
}

void logg(Object? message, {String name = 'BOTOLA_MAX'}) {
  log('$message', name: name);
}

abstract class AppConstants {
  static const String REGULAR_SEASON = 'REGULAR_SEASON';
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
