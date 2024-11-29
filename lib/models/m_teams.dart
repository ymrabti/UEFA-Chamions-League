import 'package:botola_max/lib.dart';
import 'package:intl/intl.dart';

class BotolaTeams {
  final int? count;

  final Filters? filters;

  final Competition competition;

  final Season season;

  final List<Teams> teams;
  BotolaTeams({
    required this.count,
    required this.filters,
    required this.competition,
    required this.season,
    required this.teams,
  });

  BotolaTeams copyWith({
    int? count,
    Filters? filters,
    Competition? competition,
    Season? season,
    List<Teams>? teams,
  }) {
    return BotolaTeams(
      count: count ?? this.count,
      filters: filters ?? this.filters,
      competition: competition ?? this.competition,
      season: season ?? this.season,
      teams: teams ?? this.teams,
    );
  }

  Map<String, Object?> toJson() {
    return {
      BotolaMaxTeamsEnum.count.name: count,
      BotolaMaxTeamsEnum.filters.name: filters?.toJson(),
      BotolaMaxTeamsEnum.competition.name: competition.toJson(),
      BotolaMaxTeamsEnum.season.name: season.toJson(),
      BotolaMaxTeamsEnum.teams.name: teams.map<Map<String, dynamic>>((data) => data.toJson()).toList(),
    };
  }

  factory BotolaTeams.fromJson(Map<String, Object?> json) {
    Map<String, Object?>? filtersJson = json[BotolaMaxTeamsEnum.filters.name] as Map<String, Object?>?;
    return BotolaTeams(
      count: int.tryParse('${json[BotolaMaxTeamsEnum.count.name]}'),
      filters: filtersJson == null ? null : Filters.fromJson(filtersJson),
      competition: Competition.fromJson(json[BotolaMaxTeamsEnum.competition.name] as Map<String, Object?>),
      season: Season.fromJson(json[BotolaMaxTeamsEnum.season.name] as Map<String, Object?>),
      teams: (json[BotolaMaxTeamsEnum.teams.name] as List).map<Teams>((data) => Teams.fromJson(data as Map<String, Object?>)).toList(),
    );
  }

  factory BotolaTeams.fromMap(Map<String, Object?> json) {
    return BotolaTeams(
      count: json[BotolaMaxTeamsEnum.count.name] as int,
      filters: json[BotolaMaxTeamsEnum.filters.name] as Filters,
      competition: json[BotolaMaxTeamsEnum.competition.name] as Competition,
      season: json[BotolaMaxTeamsEnum.season.name] as Season,
      teams: json[BotolaMaxTeamsEnum.teams.name] as List<Teams>,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is BotolaTeams &&
        other.runtimeType == runtimeType &&
        other.count == count && //
        other.filters == filters && //
        other.competition == competition && //
        other.season == season && //
        other.teams == teams;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      count,
      filters,
      competition,
      season,
      teams,
    );
  }
}

enum BotolaMaxTeamsEnum {
  count,
  filters,
  competition,
  season,
  teams,
  none,
}

class Teams extends IGenericAppModel {
  final Area area;

  final int id;

  final String name;

  final String shortName;

  final String tla;

  final String crest;

  final String address;

  final String? website;

  final int? founded;

  final String? clubColors;

  final String? venue;

  final List<RunningCompetitions> runningCompetitions;

  final Coach coach;

  final List<Squad> squad;

  final List<dynamic> staff;

  final DateTime lastUpdated;
  Teams({
    required this.area,
    required this.id,
    required this.name,
    required this.shortName,
    required this.tla,
    required this.crest,
    required this.address,
    required this.website,
    required this.founded,
    required this.clubColors,
    required this.venue,
    required this.runningCompetitions,
    required this.coach,
    required this.squad,
    required this.staff,
    required this.lastUpdated,
  });

  Teams copyWith({
    Area? area,
    int? id,
    String? name,
    String? shortName,
    String? tla,
    String? crest,
    String? address,
    String? website,
    int? founded,
    String? clubColors,
    String? venue,
    List<RunningCompetitions>? runningCompetitions,
    Coach? coach,
    List<Squad>? squad,
    List<dynamic>? staff,
    DateTime? lastUpdated,
  }) {
    return Teams(
      area: area ?? this.area,
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      tla: tla ?? this.tla,
      crest: crest ?? this.crest,
      address: address ?? this.address,
      website: website ?? this.website,
      founded: founded ?? this.founded,
      clubColors: clubColors ?? this.clubColors,
      venue: venue ?? this.venue,
      runningCompetitions: runningCompetitions ?? this.runningCompetitions,
      coach: coach ?? this.coach,
      squad: squad ?? this.squad,
      staff: staff ?? this.staff,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Object?> toJson() {
    return {
      TeamsEnum.area.name: area.toJson(),
      TeamsEnum.id.name: id,
      TeamsEnum.name.name: name,
      TeamsEnum.shortName.name: shortName,
      TeamsEnum.tla.name: tla,
      TeamsEnum.crest.name: crest,
      TeamsEnum.address.name: address,
      TeamsEnum.website.name: website,
      TeamsEnum.founded.name: founded,
      TeamsEnum.clubColors.name: clubColors,
      TeamsEnum.venue.name: venue,
      TeamsEnum.runningCompetitions.name: runningCompetitions.map<Map<String, dynamic>>((data) => data.toJson()).toList(),
      TeamsEnum.coach.name: coach.toJson(),
      TeamsEnum.squad.name: squad.map<Map<String, dynamic>>((data) => data.toJson()).toList(),
      TeamsEnum.staff.name: staff,
      TeamsEnum.lastUpdated.name: lastUpdated,
    };
  }

  Map<String, Object?> toMap() {
    return {
      TeamsEnum.area.name: area,
      TeamsEnum.id.name: id.toString(),
      TeamsEnum.name.name: name,
      TeamsEnum.shortName.name: shortName,
      TeamsEnum.tla.name: tla,
      TeamsEnum.crest.name: crest,
      TeamsEnum.address.name: address,
      TeamsEnum.website.name: website,
      TeamsEnum.founded.name: founded.toString(),
      TeamsEnum.clubColors.name: clubColors,
      TeamsEnum.venue.name: venue,
      TeamsEnum.runningCompetitions.name: runningCompetitions,
      TeamsEnum.coach.name: coach,
      TeamsEnum.squad.name: squad,
      TeamsEnum.staff.name: staff,
      TeamsEnum.lastUpdated.name: lastUpdated,
    };
  }

  factory Teams.fromJson(Map<String, Object?> json) {
    return Teams(
      area: Area.fromJson(json[TeamsEnum.area.name] as Map<String, Object?>),
      id: int.parse('${json[TeamsEnum.id.name]}'),
      name: json[TeamsEnum.name.name] as String,
      shortName: json[TeamsEnum.shortName.name] as String,
      tla: json[TeamsEnum.tla.name] as String,
      crest: json[TeamsEnum.crest.name] as String,
      address: json[TeamsEnum.address.name] as String,
      website: json[TeamsEnum.website.name] as String?,
      founded: int.tryParse('${json[TeamsEnum.founded.name]}'),
      clubColors: json[TeamsEnum.clubColors.name] as String?,
      venue: json[TeamsEnum.venue.name] as String?,
      runningCompetitions: (json[TeamsEnum.runningCompetitions.name] as List).map<RunningCompetitions>((data) => RunningCompetitions.fromJson(data as Map<String, Object?>)).toList(),
      coach: Coach.fromJson(json[TeamsEnum.coach.name] as Map<String, Object?>),
      squad: (json[TeamsEnum.squad.name] as List).map<Squad>((data) => Squad.fromJson(data as Map<String, Object?>)).toList(),
      staff: (json[TeamsEnum.staff.name] as List<Object?>).map((el) => el).toList(),
      lastUpdated: DateTime.parse('${json[TeamsEnum.lastUpdated.name]}').add(DateTime.now().timeZoneOffset),
    );
  }

  factory Teams.fromMap(Map<String, Object?> json) {
    return Teams(
      area: json[TeamsEnum.area.name] as Area,
      id: json[TeamsEnum.id.name] as int,
      name: json[TeamsEnum.name.name] as String,
      shortName: json[TeamsEnum.shortName.name] as String,
      tla: json[TeamsEnum.tla.name] as String,
      crest: json[TeamsEnum.crest.name] as String,
      address: json[TeamsEnum.address.name] as String,
      website: json[TeamsEnum.website.name] as String,
      founded: json[TeamsEnum.founded.name] as int,
      clubColors: json[TeamsEnum.clubColors.name] as String,
      venue: json[TeamsEnum.venue.name] as String,
      runningCompetitions: json[TeamsEnum.runningCompetitions.name] as List<RunningCompetitions>,
      coach: json[TeamsEnum.coach.name] as Coach,
      squad: json[TeamsEnum.squad.name] as List<Squad>,
      staff: json[TeamsEnum.staff.name] as List<dynamic>,
      lastUpdated: json[TeamsEnum.lastUpdated.name] as DateTime,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  String stringify() {
    return 'Teams(area:${area.toString()}, id:$id, name:$name, shortName:$shortName, tla:$tla, crest:$crest, address:$address, website:$website, founded:$founded, clubColors:$clubColors, venue:$venue, runningCompetitions:${runningCompetitions.toString()}, coach:${coach.toString()}, squad:${squad.toString()}, staff:$staff, lastUpdated:$lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return other is Teams &&
        other.runtimeType == runtimeType &&
        other.area == area && //
        other.id == id && //
        other.name == name && //
        other.shortName == shortName && //
        other.tla == tla && //
        other.crest == crest && //
        other.address == address && //
        other.website == website && //
        other.founded == founded && //
        other.clubColors == clubColors && //
        other.venue == venue && //
        other.runningCompetitions == runningCompetitions && //
        other.coach == coach && //
        other.squad == squad && //
        other.staff == staff && //
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      area,
      id,
      name,
      shortName,
      tla,
      crest,
      address,
      website,
      founded,
      clubColors,
      venue,
      runningCompetitions,
      coach,
      squad,
      staff,
      lastUpdated,
    );
  }
}

enum TeamsEnum {
  area,
  id,
  name,
  shortName,
  tla,
  crest,
  address,
  website,
  founded,
  clubColors,
  venue,
  runningCompetitions,
  coach,
  squad,
  staff,
  lastUpdated,
  none,
}

class Teams_Views {
  final Teams model;

  Teams_Views({required this.model});
}

class Squad {
  final int id;

  final String name;

  final String? position;

  final DateTime? dateOfBirth;

  final String? nationality;
  Squad({
    required this.id,
    required this.name,
    required this.position,
    required this.dateOfBirth,
    required this.nationality,
  });

  Squad copyWith({
    int? id,
    String? name,
    String? position,
    DateTime? dateOfBirth,
    String? nationality,
  }) {
    return Squad(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      nationality: nationality ?? this.nationality,
    );
  }

  Map<String, Object?> toJson() {
    return {
      SquadEnum.id.name: id,
      SquadEnum.name.name: name,
      SquadEnum.position.name: position,
      SquadEnum.dateOfBirth.name: dateOfBirth,
      SquadEnum.nationality.name: nationality,
    };
  }

  Map<String, Object?> toMap() {
    return {
      SquadEnum.id.name: id.toString(),
      SquadEnum.name.name: name,
      SquadEnum.position.name: position,
      SquadEnum.dateOfBirth.name: dateOfBirth,
      SquadEnum.nationality.name: nationality,
    };
  }

  factory Squad.fromJson(Map<String, Object?> json) {
    return Squad(
      id: int.parse('${json[SquadEnum.id.name]}'),
      name: json[SquadEnum.name.name] as String,
      position: json[SquadEnum.position.name] as String?,
      dateOfBirth: DateTime.tryParse('${json[SquadEnum.dateOfBirth.name]}')?.add(DateTime.now().timeZoneOffset),
      nationality: json[SquadEnum.nationality.name] as String?,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is Squad &&
        other.runtimeType == runtimeType &&
        other.id == id && //
        other.name == name && //
        other.position == position && //
        other.dateOfBirth == dateOfBirth && //
        other.nationality == nationality;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      name,
      position,
      dateOfBirth,
      nationality,
    );
  }
}

enum SquadEnum {
  id,
  name,
  position,
  dateOfBirth,
  nationality,
  none,
}

class Squad_Views {
  final Squad model;

  Squad_Views({required this.model});
}

extension SquadSort on List<Squad> {
  List<Squad> sorty(String caseField, {bool desc = false}) {
    return this
      ..sort((a, b) {
        int fact = (desc ? -1 : 1);

        if (caseField == SquadEnum.id.name) {
          // unsortable

          int akey = a.id;
          int bkey = b.id;

          return fact * (bkey - akey);
        }

        if (caseField == SquadEnum.name.name) {
          // unsortable

          String akey = a.name;
          String bkey = b.name;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == SquadEnum.position.name) {
          // unsortable

          String? akey = a.position;
          String? bkey = b.position;

          if (akey == null) return 0;
          if (bkey == null) return 0;
          return fact * (bkey.compareTo(akey));
        }

        if (caseField == SquadEnum.dateOfBirth.name) {
          // unsortable

          DateTime? akey = a.dateOfBirth;
          DateTime? bkey = b.dateOfBirth;
          if (akey == null) return 0;
          if (bkey == null) return 0;
          return fact * bkey.compareTo(akey);
        }

        if (caseField == SquadEnum.nationality.name) {
          // unsortable

          String? akey = a.nationality;
          String? bkey = b.nationality;

          if (akey == null) return 0;
          if (bkey == null) return 0;
          return fact * (bkey.compareTo(akey));
        }

        return 0;
      });
  }
}

class Coach {
  final int? id;

  final String? firstName;

  final String? lastName;

  final String? name;

  final DateTime? dateOfBirth;

  final String? nationality;

  final Contract? contract;
  Coach({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.dateOfBirth,
    required this.nationality,
    required this.contract,
  });

  Coach copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? name,
    DateTime? dateOfBirth,
    String? nationality,
    Contract? contract,
  }) {
    return Coach(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      nationality: nationality ?? this.nationality,
      contract: contract ?? this.contract,
    );
  }

  Map<String, Object?> toJson() {
    return {
      CoachEnum.id.name: id,
      CoachEnum.firstName.name: firstName,
      CoachEnum.lastName.name: lastName,
      CoachEnum.name.name: name,
      CoachEnum.dateOfBirth.name: dateOfBirth,
      CoachEnum.nationality.name: nationality,
      CoachEnum.contract.name: contract?.toJson(),
    };
  }

  Map<String, Object?> toMap() {
    return {
      CoachEnum.id.name: id.toString(),
      CoachEnum.firstName.name: firstName,
      CoachEnum.lastName.name: lastName,
      CoachEnum.name.name: name,
      CoachEnum.dateOfBirth.name: dateOfBirth,
      CoachEnum.nationality.name: nationality,
      CoachEnum.contract.name: contract,
    };
  }

  factory Coach.fromJson(Map<String, Object?> json) {
    return Coach(
      id: int.tryParse('${json[CoachEnum.id.name]}'),
      firstName: json[CoachEnum.firstName.name] as String?,
      lastName: json[CoachEnum.lastName.name] as String?,
      name: json[CoachEnum.name.name] as String?,
      dateOfBirth: DateTime.tryParse('${json[CoachEnum.dateOfBirth.name]}')?.add(DateTime.now().timeZoneOffset),
      nationality: json[CoachEnum.nationality.name] as String?,
      contract: json[CoachEnum.contract.name] == null
          ? null
          : Contract.fromJson(
              json[CoachEnum.contract.name] as Map<String, Object?>,
            ),
    );
  }

  factory Coach.fromMap(Map<String, Object?> json) {
    return Coach(
      id: json[CoachEnum.id.name] as int,
      firstName: json[CoachEnum.firstName.name] as String,
      lastName: json[CoachEnum.lastName.name] as String,
      name: json[CoachEnum.name.name] as String,
      dateOfBirth: json[CoachEnum.dateOfBirth.name] as DateTime,
      nationality: json[CoachEnum.nationality.name] as String,
      contract: json[CoachEnum.contract.name] as Contract,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  String stringify() {
    return 'Coach(id:$id, firstName:$firstName, lastName:$lastName, name:$name, dateOfBirth:$dateOfBirth, nationality:$nationality, contract:${contract.toString()})';
  }

  @override
  bool operator ==(Object other) {
    return other is Coach &&
        other.runtimeType == runtimeType &&
        other.id == id && //
        other.firstName == firstName && //
        other.lastName == lastName && //
        other.name == name && //
        other.dateOfBirth == dateOfBirth && //
        other.nationality == nationality && //
        other.contract == contract;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      firstName,
      lastName,
      name,
      dateOfBirth,
      nationality,
      contract,
    );
  }
}

enum CoachEnum {
  id,
  firstName,
  lastName,
  name,
  dateOfBirth,
  nationality,
  contract,
  none,
}

class Coach_Views {
  final Coach model;

  Coach_Views({required this.model});
}

class Contract {
  final DateTime? start;

  final DateTime? until;
  Contract({
    required this.start,
    required this.until,
  });

  Contract copyWith({
    DateTime? start,
    DateTime? until,
  }) {
    return Contract(
      start: start ?? this.start,
      until: until ?? this.until,
    );
  }

  Map<String, Object?> toJson() {
    return {
      ContractEnum.start.name: start,
      ContractEnum.until.name: until,
    };
  }

  Map<String, Object?> toMap() {
    return {
      ContractEnum.start.name: start,
      ContractEnum.until.name: until,
    };
  }

  factory Contract.fromJson(Map<String, Object?> json) {
    return Contract(
      start: json[ContractEnum.start.name] == null ? null : DateFormat('yyyy-MM').parse('${json[ContractEnum.start.name]}'),
      until: json[ContractEnum.until.name] == null ? null : DateFormat('yyyy-MM').parse('${json[ContractEnum.until.name]}'),
    );
  }

  factory Contract.fromMap(Map<String, Object?> json) {
    return Contract(
      start: json[ContractEnum.start.name] as DateTime,
      until: json[ContractEnum.until.name] as DateTime,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  String stringify() {
    return 'Contract(start:$start, until:$until)';
  }

  @override
  bool operator ==(Object other) {
    return other is Contract &&
        other.runtimeType == runtimeType &&
        other.start == start && //
        other.until == until;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      start,
      until,
    );
  }
}

enum ContractEnum {
  start,
  until,
  none,
}

class Contract_Views {
  final Contract model;

  Contract_Views({required this.model});
}

extension ContractSort on List<Contract> {
  List<Contract> sorty(String caseField, {bool desc = false}) {
    return this
      ..sort((a, b) {
        int fact = (desc ? -1 : 1);

        if (caseField == ContractEnum.start.name) {
          // unsortable

          DateTime? akey = a.start;
          DateTime? bkey = b.start;

          if (akey == null) return 0;
          if (bkey == null) return 0;
          return fact * bkey.compareTo(akey);
        }

        if (caseField == ContractEnum.until.name) {
          // unsortable

          DateTime? akey = a.until;
          DateTime? bkey = b.until;

          if (akey == null) return 0;
          if (bkey == null) return 0;
          return fact * bkey.compareTo(akey);
        }

        return 0;
      });
  }
}

class RunningCompetitions {
  final int id;

  final String name;

  final String? code;

  final String type;

  final String? emblem;
  RunningCompetitions({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.emblem,
  });

  RunningCompetitions copyWith({
    int? id,
    String? name,
    String? code,
    String? type,
    String? emblem,
  }) {
    return RunningCompetitions(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      type: type ?? this.type,
      emblem: emblem ?? this.emblem,
    );
  }

  Map<String, Object?> toJson() {
    return {
      RunningCompetitionsEnum.id.name: id,
      RunningCompetitionsEnum.name.name: name,
      RunningCompetitionsEnum.code.name: code,
      RunningCompetitionsEnum.type.name: type,
      RunningCompetitionsEnum.emblem.name: emblem,
    };
  }

  Map<String, Object?> toMap() {
    return {
      RunningCompetitionsEnum.id.name: id.toString(),
      RunningCompetitionsEnum.name.name: name,
      RunningCompetitionsEnum.code.name: code,
      RunningCompetitionsEnum.type.name: type,
      RunningCompetitionsEnum.emblem.name: emblem,
    };
  }

  factory RunningCompetitions.fromJson(Map<String, Object?> json) {
    return RunningCompetitions(
      id: int.parse('${json[RunningCompetitionsEnum.id.name]}'),
      name: json[RunningCompetitionsEnum.name.name] as String,
      code: json[RunningCompetitionsEnum.code.name] as String?,
      type: json[RunningCompetitionsEnum.type.name] as String,
      emblem: json[RunningCompetitionsEnum.emblem.name] as String?,
    );
  }

  factory RunningCompetitions.fromMap(Map<String, Object?> json) {
    return RunningCompetitions(
      id: json[RunningCompetitionsEnum.id.name] as int,
      name: json[RunningCompetitionsEnum.name.name] as String,
      code: json[RunningCompetitionsEnum.code.name] as String,
      type: json[RunningCompetitionsEnum.type.name] as String,
      emblem: json[RunningCompetitionsEnum.emblem.name] as String,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  String stringify() {
    return 'RunningCompetitions(id:$id, name:$name, code:$code, type:$type, emblem:$emblem)';
  }

  @override
  bool operator ==(Object other) {
    return other is RunningCompetitions &&
        other.runtimeType == runtimeType &&
        other.id == id && //
        other.name == name && //
        other.code == code && //
        other.type == type && //
        other.emblem == emblem;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      name,
      code,
      type,
      emblem,
    );
  }
}

enum RunningCompetitionsEnum {
  id,
  name,
  code,
  type,
  emblem,
  none,
}
