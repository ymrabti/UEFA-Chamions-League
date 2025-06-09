import "dart:convert";

import "package:botola_max/lib.dart";

class BotolaCompetition {
  final Area area;
  final int id;
  final String name;
  final String code;
  final String type;
  final String emblem;
  final CurrentSeason currentSeason;
  final List<Seasons> seasons;
  final DateTime lastUpdated;

  BotolaCompetition({
    required this.area,
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.emblem,
    required this.currentSeason,
    required this.seasons,
    required this.lastUpdated,
  });

  BotolaCompetition copyWith({
    Area? area,
    int? id,
    String? name,
    String? code,
    String? type,
    String? emblem,
    CurrentSeason? currentSeason,
    List<Seasons>? seasons,
    DateTime? lastUpdated,
  }) {
    return BotolaCompetition(
      area: area ?? this.area,
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      type: type ?? this.type,
      emblem: emblem ?? this.emblem,
      currentSeason: currentSeason ?? this.currentSeason,
      seasons: seasons ?? this.seasons,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  TheCompetition toTheCompetition() {
    return TheCompetition(
      id: id,
      area: area,
      name: name,
      code: code,
      type: type,
      emblem: emblem,
      plan: 'free',
      currentSeason: currentSeason,
      numberOfAvailableSeasons: 0,
      lastUpdated: lastUpdated,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      BotolaCompetitionEnum.area.name: area.toJson(),
      BotolaCompetitionEnum.id.name: id,
      BotolaCompetitionEnum.name.name: name,
      BotolaCompetitionEnum.code.name: code,
      BotolaCompetitionEnum.type.name: type,
      BotolaCompetitionEnum.emblem.name: emblem,
      BotolaCompetitionEnum.currentSeason.name: currentSeason.toJson(),
      BotolaCompetitionEnum.seasons.name: seasons.map<Map<String, dynamic>>((Seasons data) => data.toJson()).toList(),
      BotolaCompetitionEnum.lastUpdated.name: lastUpdated,
    };
  }

  factory BotolaCompetition.fromJson(Map<String, Object?> json) {
    return BotolaCompetition(
      area: Area.fromJson(json[BotolaCompetitionEnum.area.name] as Map<String, Object?>),
      id: int.parse('${json[BotolaCompetitionEnum.id.name]}'),
      name: json[BotolaCompetitionEnum.name.name] as String,
      code: json[BotolaCompetitionEnum.code.name] as String,
      type: json[BotolaCompetitionEnum.type.name] as String,
      emblem: json[BotolaCompetitionEnum.emblem.name] as String,
      currentSeason: CurrentSeason.fromJson(json[BotolaCompetitionEnum.currentSeason.name] as Map<String, Object?>),
      seasons: (json[BotolaCompetitionEnum.seasons.name] as List<dynamic>).map<Seasons>((dynamic data) => Seasons.fromJson(data as Map<String, Object?>)).toList(),
      lastUpdated: DateTime.parse('${json[BotolaCompetitionEnum.lastUpdated.name]}').add(DateTime.now().timeZoneOffset),
    );
  }

  String get anthem {
    switch (code) {
      case 'CL':
        return 'bg_audio.mp3';
      case 'WC':
        return 'wc_qatar.mp3';
      default:
        return '';
    }
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is BotolaCompetition &&
        other.runtimeType == runtimeType &&
        other.area == area && //
        other.id == id && //
        other.name == name && //
        other.code == code && //
        other.type == type && //
        other.emblem == emblem && //
        other.currentSeason == currentSeason && //
        other.seasons == seasons && //
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      area,
      id,
      name,
      code,
      type,
      emblem,
      currentSeason,
      seasons,
      lastUpdated,
    );
  }
}

enum BotolaCompetitionEnum {
  area,
  id,
  name,
  code,
  type,
  emblem,
  currentSeason,
  seasons,
  lastUpdated,
  none,
}

extension BotolaCompetitionSort on List<BotolaCompetition> {
  List<BotolaCompetition> sorty(String caseField, {bool desc = false}) {
    return this
      ..sort((BotolaCompetition a, BotolaCompetition b) {
        int fact = (desc ? -1 : 1);

        if (caseField == BotolaCompetitionEnum.id.name) {
          // unsortable

          int akey = a.id;
          int bkey = b.id;

          return fact * (bkey - akey);
        }

        if (caseField == BotolaCompetitionEnum.name.name) {
          // unsortable

          String akey = a.name;
          String bkey = b.name;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == BotolaCompetitionEnum.code.name) {
          // unsortable

          String akey = a.code;
          String bkey = b.code;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == BotolaCompetitionEnum.type.name) {
          // unsortable

          String akey = a.type;
          String bkey = b.type;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == BotolaCompetitionEnum.emblem.name) {
          // unsortable

          String akey = a.emblem;
          String bkey = b.emblem;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == BotolaCompetitionEnum.lastUpdated.name) {
          // unsortable

          DateTime akey = a.lastUpdated;
          DateTime bkey = b.lastUpdated;

          return fact * bkey.compareTo(akey);
        }

        return 0;
      });
  }
}

class Seasons {
  final int id;

  final DateTime startDate;

  final DateTime endDate;

  final int? currentMatchday;

  final Winner? winner;
  Seasons({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.currentMatchday,
    required this.winner,
  });

  Seasons copyWith({
    int? id,
    DateTime? startDate,
    DateTime? endDate,
    int? currentMatchday,
    Winner? winner,
  }) {
    return Seasons(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currentMatchday: currentMatchday ?? this.currentMatchday,
      winner: winner ?? this.winner,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      SeasonsEnum.id.name: id,
      SeasonsEnum.startDate.name: startDate,
      SeasonsEnum.endDate.name: endDate,
      SeasonsEnum.currentMatchday.name: currentMatchday,
      SeasonsEnum.winner.name: winner?.toJson(),
    };
  }

  factory Seasons.fromJson(Map<String, Object?> json) {
    Map<String, Object?>? jsonWinner = json[SeasonsEnum.winner.name] as Map<String, Object?>?;
    return Seasons(
      id: int.parse('${json[SeasonsEnum.id.name]}'),
      startDate: DateTime.parse('${json[SeasonsEnum.startDate.name]}'),
      endDate: DateTime.parse('${json[SeasonsEnum.endDate.name]}'),
      currentMatchday: int.tryParse('${json[SeasonsEnum.currentMatchday.name]}'),
      winner: jsonWinner == null ? null : Winner.fromJson(jsonWinner),
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is Seasons &&
        other.runtimeType == runtimeType &&
        other.id == id && //
        other.startDate == startDate && //
        other.endDate == endDate && //
        other.currentMatchday == currentMatchday && //
        other.winner == winner;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      startDate,
      endDate,
      currentMatchday,
      winner,
    );
  }
}

enum SeasonsEnum {
  id,
  startDate,
  endDate,
  currentMatchday,
  winner,
  none,
}

extension SeasonsSort on List<Seasons> {
  List<Seasons> sorty(String caseField, {bool desc = false}) {
    return this
      ..sort((Seasons a, Seasons b) {
        int fact = (desc ? -1 : 1);

        if (caseField == SeasonsEnum.id.name) {
          // unsortable

          int akey = a.id;
          int bkey = b.id;

          return fact * (bkey - akey);
        }

        if (caseField == SeasonsEnum.startDate.name) {
          // unsortable

          DateTime akey = a.startDate;
          DateTime bkey = b.startDate;

          return fact * bkey.compareTo(akey);
        }

        if (caseField == SeasonsEnum.endDate.name) {
          // unsortable

          DateTime akey = a.endDate;
          DateTime bkey = b.endDate;

          return fact * bkey.compareTo(akey);
        }

        if (caseField == SeasonsEnum.currentMatchday.name) {
          // unsortable

          int? akey = a.currentMatchday;
          int? bkey = b.currentMatchday;
          if (akey == null || bkey == null) return 0;
          return fact * (bkey - akey);
        }

        return 0;
      });
  }
}

class CurrentSeason {
  final int id;

  final DateTime startDate;

  final DateTime endDate;

  final int currentMatchday;

  final Winner? winner;
  CurrentSeason({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.currentMatchday,
    required this.winner,
  });

  CurrentSeason copyWith({
    int? id,
    DateTime? startDate,
    DateTime? endDate,
    int? currentMatchday,
    Winner? winner,
  }) {
    return CurrentSeason(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currentMatchday: currentMatchday ?? this.currentMatchday,
      winner: winner ?? this.winner,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      CurrentSeasonEnum.id.name: id,
      CurrentSeasonEnum.startDate.name: startDate,
      CurrentSeasonEnum.endDate.name: endDate,
      CurrentSeasonEnum.currentMatchday.name: currentMatchday,
      CurrentSeasonEnum.winner.name: winner?.toJson(),
    };
  }

  factory CurrentSeason.fromJson(Map<String, Object?> json) {
    dynamic jsonWinner = json[SeasonsEnum.winner.name];
    return CurrentSeason(
      id: int.parse('${json[CurrentSeasonEnum.id.name]}'),
      startDate: DateTime.parse('${json[CurrentSeasonEnum.startDate.name]}'),
      endDate: DateTime.parse('${json[CurrentSeasonEnum.endDate.name]}'),
      currentMatchday: int.tryParse('${json[CurrentSeasonEnum.currentMatchday.name]}') ?? 0,
      winner: jsonWinner == null
          ? null
          : jsonWinner is Map<String, Object?>
              ? Winner.fromJson(jsonWinner)
              : Winner.fromJson(jsonDecode(jsonWinner)),
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentSeason &&
        other.runtimeType == runtimeType &&
        other.id == id && //
        other.startDate == startDate && //
        other.endDate == endDate && //
        other.currentMatchday == currentMatchday && //
        other.winner == winner;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      startDate,
      endDate,
      currentMatchday,
      winner,
    );
  }
}

enum CurrentSeasonEnum {
  id,
  startDate,
  endDate,
  currentMatchday,
  winner,
  none,
}

extension CurrentSeasonSort on List<CurrentSeason> {
  List<CurrentSeason> sorty(String caseField, {bool desc = false}) {
    return this
      ..sort((CurrentSeason a, CurrentSeason b) {
        int fact = (desc ? -1 : 1);

        if (caseField == CurrentSeasonEnum.id.name) {
          // unsortable

          int akey = a.id;
          int bkey = b.id;

          return fact * (bkey - akey);
        }

        if (caseField == CurrentSeasonEnum.startDate.name) {
          // unsortable

          DateTime akey = a.startDate;
          DateTime bkey = b.startDate;

          return fact * bkey.compareTo(akey);
        }

        if (caseField == CurrentSeasonEnum.endDate.name) {
          // unsortable

          DateTime akey = a.endDate;
          DateTime bkey = b.endDate;

          return fact * bkey.compareTo(akey);
        }

        if (caseField == CurrentSeasonEnum.currentMatchday.name) {
          // unsortable

          int akey = a.currentMatchday;
          int bkey = b.currentMatchday;

          return fact * (bkey - akey);
        }

        if (caseField == CurrentSeasonEnum.winner.name) {
          // unsortable
        }
        return 0;
      });
  }
}
