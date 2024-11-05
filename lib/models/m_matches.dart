import 'package:flutter/material.dart';
import 'package:botola_max/lib.dart';

class BotolaMatches {
  final Filters filters;
  final ResultSet resultSet;
  final Competition competition;
  final List<Matche> matches;
  const BotolaMatches({
    required this.filters,
    required this.resultSet,
    required this.competition,
    required this.matches,
  });
  BotolaMatches copyWith({Filters? filters, ResultSet? resultSet, Competition? competition, List<Matche>? matches}) {
    return BotolaMatches(
      filters: filters ?? this.filters,
      resultSet: resultSet ?? this.resultSet,
      competition: competition ?? this.competition,
      matches: matches ?? this.matches,
    );
  }

  Map<String, Object?> toJson() {
    return {'filters': filters.toJson(), 'resultSet': resultSet.toJson(), 'competition': competition.toJson(), 'matches': matches.map<Map<String, dynamic>>((data) => data.toJson()).toList()};
  }

  static BotolaMatches fromJson(Map<String, Object?> json) {
    return BotolaMatches(filters: json['filters'] == null ? Filters.fromJson({}) : Filters.fromJson(json['filters'] as Map<String, Object?>), resultSet: json['resultSet'] == null ? ResultSet.fromJson({}) : ResultSet.fromJson(json['resultSet'] as Map<String, Object?>), competition: json['competition'] == null ? Competition.fromJson({}) : Competition.fromJson(json['competition'] as Map<String, Object?>), matches: json['matches'] == null ? [] : (json['matches'] as List).map<Matche>((data) => Matche.fromJson(data as Map<String, Object?>)).toList());
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is BotolaMatches && other.runtimeType == runtimeType && other.filters == filters && other.resultSet == resultSet && other.competition == competition && other.matches == matches;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, filters, resultSet, competition, matches);
  }
}

class Matche {
  final Area area;
  final Competition competition;
  final Season season;
  final Team homeTeam;
  final Team awayTeam;
  final Score score;
  final List<Referees> referees;
//
  final int id;
  final DateTime utcDate;
  final String status;
  final int matchday;
  final String stage;
  final String? group;
  final DateTime lastUpdated;
  const Matche({
    required this.area,
    required this.competition,
    required this.season,
    required this.id,
    required this.utcDate,
    required this.status,
    required this.matchday,
    required this.stage,
    required this.group,
    required this.lastUpdated,
    required this.homeTeam,
    required this.awayTeam,
    required this.score,
    required this.referees,
  });
  Matche copyWith({
    Area? area,
    Competition? competition,
    Season? season,
    int? id,
    DateTime? utcDate,
    String? status,
    int? matchday,
    String? stage,
    String? group,
    DateTime? lastUpdated,
    Team? homeTeam,
    Team? awayTeam,
    Score? score,
    List<Referees>? referees,
  }) {
    return Matche(
      area: area ?? this.area,
      competition: competition ?? this.competition,
      season: season ?? this.season,
      id: id ?? this.id,
      utcDate: utcDate ?? this.utcDate,
      status: status ?? this.status,
      matchday: matchday ?? this.matchday,
      stage: stage ?? this.stage,
      group: group ?? this.group,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      score: score ?? this.score,
      referees: referees ?? this.referees,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'area': area.toJson(),
      'competition': competition.toJson(),
      'season': season.toJson(),
      'id': id,
      'utcDate': utcDate,
      'status': status,
      'matchday': matchday,
      'stage': stage,
      'group': group,
      'lastUpdated': lastUpdated,
      'homeTeam': homeTeam.toJson(),
      'awayTeam': awayTeam.toJson(),
      'score': score.toJson(),
      'referees': referees.map<Map<String, dynamic>>((data) => data.toJson()).toList(),
    };
  }

  static Matche fromJson(Map<String, Object?> json) {
    var id2 = json['id'] == null ? 0 : json['id'] as int;
    return Matche(
      area: json['area'] == null ? Area.fromJson({}) : Area.fromJson(json['area'] as Map<String, Object?>),
      competition: json['competition'] == null ? Competition.fromJson({}) : Competition.fromJson(json['competition'] as Map<String, Object?>),
      season: json['season'] == null ? Season.fromJson({}) : Season.fromJson(json['season'] as Map<String, Object?>),
      id: id2,
      utcDate: DateTime.parse(json['utcDate'] as String),
      status: json['status'] == null ? '' : json['status'] as String,
      matchday: json['matchday'] == null ? 0 : json['matchday'] as int,
      stage: json['stage'] == null ? '' : json['stage'] as String,
      group: json['group'] as String?,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      homeTeam: json['homeTeam'] == null ? Team.fromJson({}) : Team.fromJson(json['homeTeam'] as Map<String, Object?>),
      awayTeam: json['awayTeam'] == null ? Team.fromJson({}) : Team.fromJson(json['awayTeam'] as Map<String, Object?>),
      score: json['score'] == null ? Score.fromJson({}) : Score.fromJson(json['score'] as Map<String, Object?>),
      referees: json['referees'] == null ? [] : (json['referees'] as List).map<Referees>((data) => Referees.fromJson(data as Map<String, Object?>)).toList(),
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  Widget view() => MatchView(match: this);

  @override
  bool operator ==(Object other) {
    return other is Matche && //
        other.runtimeType == runtimeType &&
        other.area == area &&
        other.competition == competition &&
        other.season == season &&
        other.id == id &&
        other.utcDate == utcDate &&
        other.status == status &&
        other.matchday == matchday &&
        other.stage == stage &&
        other.group == group &&
        other.lastUpdated == lastUpdated &&
        other.homeTeam == homeTeam &&
        other.awayTeam == awayTeam &&
        other.score == score &&
        other.referees == referees;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      area,
      competition,
      season,
      id,
      utcDate,
      status,
      matchday,
      stage,
      group,
      lastUpdated,
      homeTeam,
      awayTeam,
      score,
      referees,
    );
  }
}

class Referees {
  final int id;
  final String name;
  final String type;
  final String nationality;
  const Referees({
    required this.id,
    required this.name,
    required this.type,
    required this.nationality,
  });
  Referees copyWith({int? id, String? name, String? type, String? nationality}) {
    return Referees(id: id ?? this.id, name: name ?? this.name, type: type ?? this.type, nationality: nationality ?? this.nationality);
  }

  Map<String, Object?> toJson() {
    return {'id': id, 'name': name, 'type': type, 'nationality': nationality};
  }

  static Referees fromJson(Map<String, Object?> json) {
    return Referees(
      id: json['id'] == null ? 0 : json['id'] as int,
      name: json['name'] == null ? '' : json['name'] as String,
      type: json['type'] == null ? '' : json['type'] as String,
      nationality: json['nationality'] == null ? '' : json['nationality'] as String,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is Referees && other.runtimeType == runtimeType && other.id == id && other.name == name && other.type == type && other.nationality == nationality;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, name, type, nationality);
  }
}

class Score {
  final String? winner;
  final String duration;
  final MatchScoreResult fullTime;
  final MatchScoreResult halfTime;
  final MatchScoreResult regularTime;
  final MatchScoreResult extraTime;
  final MatchScoreResult penalties;

  const Score({
    required this.winner,
    required this.duration,
    required this.fullTime,
    required this.halfTime,
    required this.regularTime,
    required this.extraTime,
    required this.penalties,
  });

  Score copyWith({
    String? winner,
    String? duration,
    MatchScoreResult? fullTime,
    MatchScoreResult? halfTime,
    MatchScoreResult? regularTime,
    MatchScoreResult? extraTime,
    MatchScoreResult? penalties,
  }) {
    return Score(
      winner: winner ?? this.winner,
      duration: duration ?? this.duration,
      fullTime: fullTime ?? this.fullTime,
      halfTime: halfTime ?? this.halfTime,
      regularTime: regularTime ?? this.regularTime,
      extraTime: extraTime ?? this.extraTime,
      penalties: penalties ?? this.penalties,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'winner': winner,
      'duration': duration,
      'fullTime': fullTime.toJson(),
      'halfTime': halfTime.toJson(),
      'regularTime': regularTime.toJson(),
      'extraTime': extraTime.toJson(),
      'penalties': penalties.toJson(),
    };
  }

  static Score fromJson(Map<String, Object?> json) {
    MatchScoreResult halfTime = MatchScoreResult.fromJson(json['halfTime'] as Map<String, Object?>);
    MatchScoreResult fullTime = MatchScoreResult.fromJson(json['fullTime'] as Map<String, Object?>);
    Map<String, Object?>? jsonRegulTime = json['regularTime'] as Map<String, Object?>?;
    Map<String, Object?>? jsonExtraTime = json['extraTime'] as Map<String, Object?>?;
    Map<String, Object?>? jsonPenalties = json['penalties'] as Map<String, Object?>?;
    MatchScoreResult zero = MatchScoreResult(away: null, home: null);
    MatchScoreResult regularTime = jsonRegulTime == null ? fullTime : MatchScoreResult.fromJson(jsonRegulTime);
    MatchScoreResult extraTime = jsonExtraTime == null ? zero : MatchScoreResult.fromJson(jsonExtraTime);
    MatchScoreResult penalties = jsonPenalties == null ? zero : MatchScoreResult.fromJson(jsonPenalties);
    int gauche = fullTime.home ?? 0;
    int droit = (regularTime.home ?? 0) + (extraTime.home ?? 0) + (penalties.home ?? 0);
    if (gauche != droit) logg('Gauche=$gauche, Droit=$droit', name: 'GaucheDroit');
    return Score(
      winner: json['winner'] as String?,
      duration: json['duration'] == null ? '' : json['duration'] as String,
      halfTime: halfTime,
      fullTime: fullTime,
      extraTime: extraTime,
      penalties: penalties,
      regularTime: regularTime,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is Score && other.runtimeType == runtimeType && other.winner == winner && other.duration == duration && other.fullTime == fullTime && other.halfTime == halfTime && other.regularTime == regularTime && other.extraTime == extraTime && other.penalties == penalties;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, winner, duration, fullTime, halfTime, regularTime, extraTime, penalties);
  }
}

class Competition {
  final int id;
  final String name;
  final String code;
  final String type;
  final String emblem;

  final GlobalKey globalKey = GlobalKey();

  Competition({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.emblem,
  });
  Competition copyWith({int? id, String? name, String? code, String? type, String? emblem}) {
    return Competition(id: id ?? this.id, name: name ?? this.name, code: code ?? this.code, type: type ?? this.type, emblem: emblem ?? this.emblem);
  }

  Map<String, Object?> toJson() {
    return {'id': id, 'name': name, 'code': code, 'type': type, 'emblem': emblem};
  }

  static Competition fromJson(Map<String, Object?> json) {
    return Competition(
      id: json['id'] == null ? 0 : json['id'] as int,
      name: json['name'] == null ? '' : json['name'] as String,
      code: json['code'] == null ? '' : json['code'] as String,
      type: json['type'] == null ? '' : json['type'] as String,
      emblem: json['emblem'] == null ? '' : json['emblem'] as String,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is Competition && other.runtimeType == runtimeType && other.id == id && other.name == name && other.code == code && other.type == type && other.emblem == emblem;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, name, code, type, emblem);
  }
}

class ResultSet {
  final int count;
  final String first;
  final String last;
  final int played;
  const ResultSet({
    required this.count,
    required this.first,
    required this.last,
    required this.played,
  });
  ResultSet copyWith({int? count, String? first, String? last, int? played}) {
    return ResultSet(count: count ?? this.count, first: first ?? this.first, last: last ?? this.last, played: played ?? this.played);
  }

  Map<String, Object?> toJson() {
    return {'count': count, 'first': first, 'last': last, 'played': played};
  }

  static ResultSet fromJson(Map<String, Object?> json) {
    return ResultSet(count: json['count'] == null ? 0 : json['count'] as int, first: json['first'] == null ? '' : json['first'] as String, last: json['last'] == null ? '' : json['last'] as String, played: json['played'] == null ? 0 : json['played'] as int);
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is ResultSet && other.runtimeType == runtimeType && other.count == count && other.first == first && other.last == last && other.played == played;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, count, first, last, played);
  }
}

class Filters {
  final String season;
  const Filters({required this.season});
  Filters copyWith({String? season}) {
    return Filters(season: season ?? this.season);
  }

  Map<String, Object?> toJson() {
    return {'season': season};
  }

  static Filters fromJson(Map<String, Object?> json) {
    return Filters(season: json['season'] == null ? '' : json['season'] as String);
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is Filters && other.runtimeType == runtimeType && other.season == season;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, season);
  }
}
