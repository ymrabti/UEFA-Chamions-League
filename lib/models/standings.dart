import 'package:uefa_champions_league/lib.dart';
import 'package:flutter/material.dart';

class BotolaStandings {
  final Filters filters;
  final Area area;
  final Competition competition;
  final Season season;
  final List<Standing> standings;
  const BotolaStandings({
    required this.filters,
    required this.area,
    required this.competition,
    required this.season,
    required this.standings,
  });
  BotolaStandings copyWith({
    Filters? filters,
    Area? area,
    Competition? competition,
    Season? season,
    List<Standing>? standings,
  }) {
    return BotolaStandings(
      filters: filters ?? this.filters,
      area: area ?? this.area,
      competition: competition ?? this.competition,
      season: season ?? this.season,
      standings: standings ?? this.standings,
    );
  }

  Map<String, Object?> toJson() {
    return {'filters': filters.toJson(), 'area': area.toJson(), 'competition': competition.toJson(), 'season': season.toJson(), 'standings': standings.map<Map<String, dynamic>>((data) => data.toJson()).toList()};
  }

  static BotolaStandings fromJson(Map<String, Object?> json) {
    return BotolaStandings(
      filters: json['filters'] == null ? Filters.fromJson({}) : Filters.fromJson(json['filters'] as Map<String, Object?>),
      area: json['area'] == null ? Area.fromJson({}) : Area.fromJson(json['area'] as Map<String, Object?>),
      competition: json['competition'] == null ? Competition.fromJson({}) : Competition.fromJson(json['competition'] as Map<String, Object?>),
      season: json['season'] == null ? Season.fromJson({}) : Season.fromJson(json['season'] as Map<String, Object?>),
      standings: json['standings'] == null ? [] : (json['standings'] as List).map<Standing>((data) => Standing.fromJson(data as Map<String, Object?>)).toList(),
    );
  }

  @override
  String toString() {
    return 'FifaWorldCupApi(filters:${filters.toString()},area:${area.toString()},competition:${competition.toString()},season:${season.toString()},standings:${standings.toString()})';
  }

  @override
  bool operator ==(Object other) {
    return other is BotolaStandings && other.runtimeType == runtimeType && other.filters == filters && other.area == area && other.competition == competition && other.season == season && other.standings == standings;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, filters, area, competition, season, standings);
  }
}

class Standing {
  final String stage;
  final String type;
  final String group;
  final List<Tabla> table;
  const Standing({required this.stage, required this.type, required this.group, required this.table});
  Standing copyWith({String? stage, String? type, String? group, List<Tabla>? table}) {
    return Standing(stage: stage ?? this.stage, type: type ?? this.type, group: group ?? this.group, table: table ?? this.table);
  }

  Map<String, Object?> toJson() {
    return {'stage': stage, 'type': type, 'group': group, 'table': table.map<Map<String, dynamic>>((data) => data.toJson()).toList()};
  }

  Widget toView() => TableStanding(standing: this);

  static Standing fromJson(Map<String, Object?> json) {
    return Standing(
      stage: json['stage'] == null ? '' : json['stage'] as String,
      type: json['type'] == null ? '' : json['type'] as String,
      group: json['group'] == null ? '' : json['group'] as String,
      table: json['table'] == null ? [] : (json['table'] as List).map<Tabla>((data) => Tabla.fromJson(data as Map<String, Object?>)).toList(),
    );
  }

  @override
  String toString() {
    return 'Standings(stage:$stage,type:$type,group:$group,table:${table.toString()})';
  }

  @override
  bool operator ==(Object other) {
    return other is Standing && other.runtimeType == runtimeType && other.stage == stage && other.type == type && other.group == group && other.table == table;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, stage, type, group, table);
  }
}

class Tabla {
  final int position;
  final Team team;
  final int playedGames;
  final dynamic form;
  final int won;
  final int draw;
  final int lost;
  final int points;
  final int goalsFor;
  final int goalsAgainst;
  final int goalDifference;
  const Tabla({
    required this.position,
    required this.team,
    required this.playedGames,
    required this.form,
    required this.won,
    required this.draw,
    required this.lost,
    required this.points,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.goalDifference,
  });
  Tabla copyWith({int? position, Team? team, int? playedGames, dynamic form, int? won, int? draw, int? lost, int? points, int? goalsFor, int? goalsAgainst, int? goalDifference}) {
    return Tabla(
      position: position ?? this.position,
      team: team ?? this.team,
      playedGames: playedGames ?? this.playedGames,
      form: form ?? this.form,
      won: won ?? this.won,
      draw: draw ?? this.draw,
      lost: lost ?? this.lost,
      points: points ?? this.points,
      goalsFor: goalsFor ?? this.goalsFor,
      goalsAgainst: goalsAgainst ?? this.goalsAgainst,
      goalDifference: goalDifference ?? this.goalDifference,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'position': position,
      'team': team.toJson(),
      'playedGames': playedGames,
      'form': form,
      'won': won,
      'draw': draw,
      'lost': lost,
      'points': points,
      'goalsFor': goalsFor,
      'goalsAgainst': goalsAgainst,
      'goalDifference': goalDifference,
    };
  }

  static Tabla fromJson(Map<String, Object?> json) {
    return Tabla(
      position: json['position'] == null ? 0 : json['position'] as int,
      team: json['team'] == null ? Team.fromJson({}) : Team.fromJson(json['team'] as Map<String, Object?>),
      playedGames: json['playedGames'] == null ? 0 : json['playedGames'] as int,
      form: json['form'] as dynamic,
      won: json['won'] == null ? 0 : json['won'] as int,
      draw: json['draw'] == null ? 0 : json['draw'] as int,
      lost: json['lost'] == null ? 0 : json['lost'] as int,
      points: json['points'] == null ? 0 : json['points'] as int,
      goalsFor: json['goalsFor'] == null ? 0 : json['goalsFor'] as int,
      goalsAgainst: json['goalsAgainst'] == null ? 0 : json['goalsAgainst'] as int,
      goalDifference: json['goalDifference'] == null ? 0 : json['goalDifference'] as int,
    );
  }

  @override
  String toString() {
    return 'Table(position:$position,team:${team.toString()},playedGames:$playedGames,form:$form,won:$won,draw:$draw,lost:$lost,points:$points,goalsFor:$goalsFor,goalsAgainst:$goalsAgainst,goalDifference:$goalDifference)';
  }

  @override
  bool operator ==(Object other) {
    return other is Tabla && other.runtimeType == runtimeType && other.position == position && other.team == team && other.playedGames == playedGames && other.form == form && other.won == won && other.draw == draw && other.lost == lost && other.points == points && other.goalsFor == goalsFor && other.goalsAgainst == goalsAgainst && other.goalDifference == goalDifference;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, position, team, playedGames, form, won, draw, lost, points, goalsFor, goalsAgainst, goalDifference);
  }
}

class Team {
  final int id;
  final String name;
  final String shortName;
  final String tla;
  final String crest;
  const Team({
    required this.id,
    required this.name,
    required this.shortName,
    required this.tla,
    required this.crest,
  });
  Team copyWith({int? id, String? name, String? shortName, String? tla, String? crest}) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      tla: tla ?? this.tla,
      crest: crest ?? this.crest,
    );
  }

  Map<String, Object?> toJson() {
    return {'id': id, 'name': name, 'shortName': shortName, 'tla': tla, 'crest': crest};
  }

  static Team fromJson(Map<String, Object?> json) {
    return Team(
      id: json['id'] == null ? 0 : json['id'] as int,
      name: json['name'] == null ? '' : json['name'] as String,
      shortName: json['shortName'] == null ? '' : json['shortName'] as String,
      tla: json['tla'] == null ? '' : json['tla'] as String,
      crest: json['crest'] == null ? '' : json['crest'] as String,
    );
  }

  @override
  String toString() {
    return 'Team(id:$id,name:$name,shortName:$shortName,tla:$tla,crest:$crest)';
  }

  @override
  bool operator ==(Object other) {
    return other is Team && other.runtimeType == runtimeType && other.id == id && other.name == name && other.shortName == shortName && other.tla == tla && other.crest == crest;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, name, shortName, tla, crest);
  }
}
