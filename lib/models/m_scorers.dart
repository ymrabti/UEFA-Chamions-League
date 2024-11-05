import 'package:botola_max/lib.dart';

class BotolaScorers {
  final int count;

  final Filters filters;

  final Competition competition;

  final Season season;

  final List<Scorers> scorers;
  BotolaScorers({
    required this.count,
    required this.filters,
    required this.competition,
    required this.season,
    required this.scorers,
  });

  BotolaScorers copyWith({
    int? count,
    Filters? filters,
    Competition? competition,
    Season? season,
    List<Scorers>? scorers,
  }) {
    return BotolaScorers(
      count: count ?? this.count,
      filters: filters ?? this.filters,
      competition: competition ?? this.competition,
      season: season ?? this.season,
      scorers: scorers ?? this.scorers,
    );
  }

  Map<String, Object?> toJson() {
    return {
      BotolaScorersEnum.count.name: count,
      BotolaScorersEnum.filters.name: filters.toJson(),
      BotolaScorersEnum.competition.name: competition.toJson(),
      BotolaScorersEnum.season.name: season.toJson(),
      BotolaScorersEnum.scorers.name: scorers.map<Map<String, Object?>>((data) => data.toJson()).toList(),
    };
  }

  Map<String, Object?> toMap() {
    return {
      BotolaScorersEnum.count.name: count.toString(),
      BotolaScorersEnum.filters.name: filters,
      BotolaScorersEnum.competition.name: competition,
      BotolaScorersEnum.season.name: season,
      BotolaScorersEnum.scorers.name: scorers,
    };
  }

  factory BotolaScorers.fromJson(Map<String, Object?> json) {
    return BotolaScorers(
      count: int.parse('${json[BotolaScorersEnum.count.name]}'),
      filters: Filters.fromJson(json[BotolaScorersEnum.filters.name] as Map<String, Object?>),
      competition: Competition.fromJson(json[BotolaScorersEnum.competition.name] as Map<String, Object?>),
      season: Season.fromJson(json[BotolaScorersEnum.season.name] as Map<String, Object?>),
      scorers: (json[BotolaScorersEnum.scorers.name] as List).map<Scorers>((data) => Scorers.fromJson(data as Map<String, Object?>)).toList(),
    );
  }

  factory BotolaScorers.fromMap(Map<String, Object?> json) {
    return BotolaScorers(
      count: json[BotolaScorersEnum.count.name] as int,
      filters: json[BotolaScorersEnum.filters.name] as Filters,
      competition: json[BotolaScorersEnum.competition.name] as Competition,
      season: json[BotolaScorersEnum.season.name] as Season,
      scorers: json[BotolaScorersEnum.scorers.name] as List<Scorers>,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is BotolaScorers &&
        other.runtimeType == runtimeType &&
        other.count == count && //
        other.filters == filters && //
        other.competition == competition && //
        other.season == season && //
        other.scorers == scorers;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      count,
      filters,
      competition,
      season,
      scorers,
    );
  }
}

enum BotolaScorersEnum {
  count,
  filters,
  competition,
  season,
  scorers,
  none,
}

class BotolaScorers_Views {
  final BotolaScorers model;

  BotolaScorers_Views({required this.model});
}

extension BotolaScorersSort on List<BotolaScorers> {
  List<BotolaScorers> sorty(String caseField, {bool desc = false}) {
    return this
      ..sort((a, b) {
        int fact = (desc ? -1 : 1);

        if (caseField == BotolaScorersEnum.count.name) {
          // unsortable

          int akey = a.count;
          int bkey = b.count;

          return fact * (bkey - akey);
        }

        return 0;
      });
  }
}

class Scorers {
  final Player player;

  final Team team;

  final int playedMatches;

  final int goals;

  final int? assists;

  final int? penalties;
  Scorers({
    required this.player,
    required this.team,
    required this.playedMatches,
    required this.goals,
    required this.assists,
    required this.penalties,
  });

  Scorers copyWith({
    Player? player,
    Team? team,
    int? playedMatches,
    int? goals,
    int? assists,
    int? penalties,
  }) {
    return Scorers(
      player: player ?? this.player,
      team: team ?? this.team,
      playedMatches: playedMatches ?? this.playedMatches,
      goals: goals ?? this.goals,
      assists: assists ?? this.assists,
      penalties: penalties ?? this.penalties,
    );
  }

  Map<String, Object?> toJson() {
    return {
      ScorersEnum.player.name: player.toJson(),
      ScorersEnum.team.name: team.toJson(),
      ScorersEnum.playedMatches.name: playedMatches,
      ScorersEnum.goals.name: goals,
      ScorersEnum.assists.name: assists,
      ScorersEnum.penalties.name: penalties,
    };
  }

  Map<String, Object?> toMap() {
    return {
      ScorersEnum.player.name: player,
      ScorersEnum.team.name: team,
      ScorersEnum.playedMatches.name: playedMatches.toString(),
      ScorersEnum.goals.name: goals.toString(),
      ScorersEnum.assists.name: assists,
      ScorersEnum.penalties.name: penalties.toString(),
    };
  }

  factory Scorers.fromJson(Map<String, Object?> json) {
    return Scorers(
      player: Player.fromJson(json[ScorersEnum.player.name] as Map<String, Object?>),
      team: Team.fromJson(json[ScorersEnum.team.name] as Map<String, Object?>),
      playedMatches: int.parse('${json[ScorersEnum.playedMatches.name]}'),
      goals: int.parse('${json[ScorersEnum.goals.name]}'),
      assists: json[ScorersEnum.assists.name] as int?,
      penalties: int.tryParse('${json[ScorersEnum.penalties.name]}'),
    );
  }

  factory Scorers.fromMap(Map<String, Object?> json) {
    return Scorers(
      player: json[ScorersEnum.player.name] as Player,
      team: json[ScorersEnum.team.name] as Team,
      playedMatches: json[ScorersEnum.playedMatches.name] as int,
      goals: json[ScorersEnum.goals.name] as int,
      assists: json[ScorersEnum.assists.name] as int?,
      penalties: json[ScorersEnum.penalties.name] as int,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is Scorers &&
        other.runtimeType == runtimeType &&
        other.player == player && //
        other.team == team && //
        other.playedMatches == playedMatches && //
        other.goals == goals && //
        other.assists == assists && //
        other.penalties == penalties;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      player,
      team,
      playedMatches,
      goals,
      assists,
      penalties,
    );
  }
}

enum ScorersEnum {
  player,
  team,
  playedMatches,
  goals,
  assists,
  penalties,
  none,
}

extension ScorersSort on List<Scorers> {
  List<Scorers> sorty(String caseField, {bool desc = false}) {
    return this
      ..sort((a, b) {
        int fact = (desc ? -1 : 1);

        if (caseField == ScorersEnum.playedMatches.name) {
          // unsortable

          int akey = a.playedMatches;
          int bkey = b.playedMatches;

          return fact * (bkey - akey);
        }

        if (caseField == ScorersEnum.goals.name) {
          // unsortable

          int akey = a.goals;
          int bkey = b.goals;

          return fact * (bkey - akey);
        }

        if (caseField == ScorersEnum.assists.name) {}
        // unsortable

        if (caseField == ScorersEnum.penalties.name) {
          // unsortable

          int? akey = a.penalties;
          int? bkey = b.penalties;

          return fact * ((bkey ?? 0) - (akey ?? 0));
        }

        return 0;
      });
  }
}

class Player {
  final int id;

  final String name;

  final String firstName;

  final String lastName;

  final DateTime? dateOfBirth;

  final String nationality;

  final String section;

  final dynamic position;

  final int? shirtNumber;

  final DateTime lastUpdated;
  Player({
    required this.id,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.nationality,
    required this.section,
    required this.position,
    required this.shirtNumber,
    required this.lastUpdated,
  });

  Player copyWith({
    int? id,
    String? name,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? nationality,
    String? section,
    dynamic position,
    int? shirtNumber,
    DateTime? lastUpdated,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      nationality: nationality ?? this.nationality,
      section: section ?? this.section,
      position: position ?? this.position,
      shirtNumber: shirtNumber ?? this.shirtNumber,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, Object?> toJson() {
    return {
      PlayerEnum.id.name: id,
      PlayerEnum.name.name: name,
      PlayerEnum.firstName.name: firstName,
      PlayerEnum.lastName.name: lastName,
      PlayerEnum.dateOfBirth.name: dateOfBirth,
      PlayerEnum.nationality.name: nationality,
      PlayerEnum.section.name: section,
      PlayerEnum.position.name: position,
      PlayerEnum.shirtNumber.name: shirtNumber,
      PlayerEnum.lastUpdated.name: lastUpdated,
    };
  }

  Map<String, Object?> toMap() {
    return {
      PlayerEnum.id.name: id.toString(),
      PlayerEnum.name.name: name,
      PlayerEnum.firstName.name: firstName,
      PlayerEnum.lastName.name: lastName,
      PlayerEnum.dateOfBirth.name: dateOfBirth,
      PlayerEnum.nationality.name: nationality,
      PlayerEnum.section.name: section,
      PlayerEnum.position.name: position,
      PlayerEnum.shirtNumber.name: shirtNumber,
      PlayerEnum.lastUpdated.name: lastUpdated,
    };
  }

  factory Player.fromJson(Map<String, Object?> json) {
    return Player(
      id: int.parse('${json[PlayerEnum.id.name]}'),
      name: json[PlayerEnum.name.name] as String,
      firstName: json[PlayerEnum.firstName.name] as String,
      lastName: json[PlayerEnum.lastName.name] as String,
      dateOfBirth: DateTime.tryParse('${json[PlayerEnum.dateOfBirth.name]}'),
      nationality: json[PlayerEnum.nationality.name] as String,
      section: json[PlayerEnum.section.name] as String,
      position: json[PlayerEnum.position.name],
      shirtNumber: json[PlayerEnum.shirtNumber.name] as int?,
      lastUpdated: DateTime.parse('${json[PlayerEnum.lastUpdated.name]}'),
    );
  }

  factory Player.fromMap(Map<String, Object?> json) {
    return Player(
      id: json[PlayerEnum.id.name] as int,
      name: json[PlayerEnum.name.name] as String,
      firstName: json[PlayerEnum.firstName.name] as String,
      lastName: json[PlayerEnum.lastName.name] as String,
      dateOfBirth: json[PlayerEnum.dateOfBirth.name] as DateTime,
      nationality: json[PlayerEnum.nationality.name] as String,
      section: json[PlayerEnum.section.name] as String,
      position: json[PlayerEnum.position.name] as dynamic,
      shirtNumber: json[PlayerEnum.shirtNumber.name] as int?,
      lastUpdated: json[PlayerEnum.lastUpdated.name] as DateTime,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is Player &&
        other.runtimeType == runtimeType &&
        other.id == id && //
        other.name == name && //
        other.firstName == firstName && //
        other.lastName == lastName && //
        other.dateOfBirth == dateOfBirth && //
        other.nationality == nationality && //
        other.section == section && //
        other.position == position && //
        other.shirtNumber == shirtNumber && //
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      name,
      firstName,
      lastName,
      dateOfBirth,
      nationality,
      section,
      position,
      shirtNumber,
      lastUpdated,
    );
  }
}

enum PlayerEnum {
  id,
  name,
  firstName,
  lastName,
  dateOfBirth,
  nationality,
  section,
  position,
  shirtNumber,
  lastUpdated,
  none,
}

class Player_Views {
  final Player model;

  Player_Views({required this.model});
}
