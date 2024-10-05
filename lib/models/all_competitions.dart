import 'package:botola_max/lib.dart';

class ElBotolaChampionsList extends IGenericAppModel {
  final int count;

  final List<Competitions> competitions;
  ElBotolaChampionsList({
    required this.count,
    required this.competitions,
  });

  ElBotolaChampionsList copyWith({
    int? count,
    List<Competitions>? competitions,
  }) {
    return ElBotolaChampionsList(
      count: count ?? this.count,
      competitions: competitions ?? this.competitions,
    );
  }

  @override
  Map<String, Object?> toJson() {
    return Map.fromEntries([
      MapEntry(
        ElBotolaChampionsListEnum.count.name,
        count,
      ),
      MapEntry(
        ElBotolaChampionsListEnum.competitions.name,
        competitions
            .map<Map<String, Object?>>(
              (data) => data.toJson(),
            )
            .toList(),
      ),
    ]);
  }

  factory ElBotolaChampionsList.fromJson(Map<String, Object?> json) {
    return ElBotolaChampionsList(
      count: int.parse('${json[ElBotolaChampionsListEnum.count.name]}'),
      competitions: (json[ElBotolaChampionsListEnum.competitions.name] as List)
          .map<Competitions>(
            (data) => Competitions.fromJson(data as Map<String, Object?>),
          )
          .toList(),
    );
  }

  factory ElBotolaChampionsList.fromMap(Map<String, Object?> json) {
    return ElBotolaChampionsList(
      count: json[ElBotolaChampionsListEnum.count.name] as int,
      competitions: json[ElBotolaChampionsListEnum.competitions.name] as List<Competitions>,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is ElBotolaChampionsList &&
        other.runtimeType == runtimeType &&
        other.count == count && //
        other.competitions == competitions;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      count,
      competitions,
    );
  }
}

enum ElBotolaChampionsListEnum {
  count,
  competitions,
  none,
}

extension ElBotolaChampionsListSort on List<ElBotolaChampionsList> {
  List<ElBotolaChampionsList> sorty(String caseField, {bool desc = false}) {
    return this
      ..sort((a, b) {
        int fact = (desc ? -1 : 1);

        if (caseField == ElBotolaChampionsListEnum.count.name) {
          // unsortable

          int akey = a.count;
          int bkey = b.count;

          return fact * (bkey - akey);
        }

        //   case ElBotolaChampionsListEnum.competitions:
        // unsortable

        return 0;
      });
  }
}

class Competitions {
  final int id;

  final Area area;

  final String name;

  final String code;

  final String type;

  final String emblem;

  final String plan;

  final CurrentSeason currentSeason;

  final int numberOfAvailableSeasons;

  final DateTime lastUpdated;
  Competitions({
    required this.id,
    required this.area,
    required this.name,
    required this.code,
    required this.type,
    required this.emblem,
    required this.plan,
    required this.currentSeason,
    required this.numberOfAvailableSeasons,
    required this.lastUpdated,
  });

  String get anthem {
    switch (code) {
      case 'CL':
        return 'assets/bg_audio.mp3';
      case 'WC':
        return 'assets/wc_qatar.mp3';
      default:
        return '';
    }
  }

  Competitions copyWith({
    int? id,
    Area? area,
    String? name,
    String? code,
    String? type,
    String? emblem,
    String? plan,
    CurrentSeason? currentSeason,
    int? numberOfAvailableSeasons,
    DateTime? lastUpdated,
  }) {
    return Competitions(
      id: id ?? this.id,
      area: area ?? this.area,
      name: name ?? this.name,
      code: code ?? this.code,
      type: type ?? this.type,
      emblem: emblem ?? this.emblem,
      plan: plan ?? this.plan,
      currentSeason: currentSeason ?? this.currentSeason,
      numberOfAvailableSeasons: numberOfAvailableSeasons ?? this.numberOfAvailableSeasons,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, Object?> toJson() {
    return {
      CompetitionsEnum.id.name: id,
      CompetitionsEnum.area.name: area.toJson(),
      CompetitionsEnum.name.name: name,
      CompetitionsEnum.code.name: code,
      CompetitionsEnum.type.name: type,
      CompetitionsEnum.emblem.name: emblem,
      CompetitionsEnum.plan.name: plan,
      CompetitionsEnum.currentSeason.name: currentSeason.toJson(),
      CompetitionsEnum.numberOfAvailableSeasons.name: numberOfAvailableSeasons,
      CompetitionsEnum.lastUpdated.name: lastUpdated,
    };
  }

  factory Competitions.fromJson(Map<String, Object?> json) {
    return Competitions(
      id: int.parse('${json[CompetitionsEnum.id.name]}'),
      area: Area.fromJson(json[CompetitionsEnum.area.name] as Map<String, Object?>),
      name: json[CompetitionsEnum.name.name] as String,
      code: json[CompetitionsEnum.code.name] as String,
      type: json[CompetitionsEnum.type.name] as String,
      emblem: json[CompetitionsEnum.emblem.name] as String,
      plan: json[CompetitionsEnum.plan.name] as String,
      currentSeason: CurrentSeason.fromJson(json[CompetitionsEnum.currentSeason.name] as Map<String, Object?>),
      numberOfAvailableSeasons: int.parse('${json[CompetitionsEnum.numberOfAvailableSeasons.name]}'),
      lastUpdated: DateTime.parse('${json[CompetitionsEnum.lastUpdated.name]}'),
    );
  }

  factory Competitions.fromMap(Map<String, Object?> json) {
    return Competitions(
      id: json[CompetitionsEnum.id.name] as int,
      area: json[CompetitionsEnum.area.name] as Area,
      name: json[CompetitionsEnum.name.name] as String,
      code: json[CompetitionsEnum.code.name] as String,
      type: json[CompetitionsEnum.type.name] as String,
      emblem: json[CompetitionsEnum.emblem.name] as String,
      plan: json[CompetitionsEnum.plan.name] as String,
      currentSeason: json[CompetitionsEnum.currentSeason.name] as CurrentSeason,
      numberOfAvailableSeasons: json[CompetitionsEnum.numberOfAvailableSeasons.name] as int,
      lastUpdated: json[CompetitionsEnum.lastUpdated.name] as DateTime,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is Competitions &&
        other.runtimeType == runtimeType &&
        other.id == id && //
        other.area == area && //
        other.name == name && //
        other.code == code && //
        other.type == type && //
        other.emblem == emblem && //
        other.plan == plan && //
        other.currentSeason == currentSeason && //
        other.numberOfAvailableSeasons == numberOfAvailableSeasons && //
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      area,
      name,
      code,
      type,
      emblem,
      plan,
      currentSeason,
      numberOfAvailableSeasons,
      lastUpdated,
    );
  }
}

enum CompetitionsEnum {
  id,
  area,
  name,
  code,
  type,
  emblem,
  plan,
  currentSeason,
  numberOfAvailableSeasons,
  lastUpdated,
  none,
}

extension CompetitionsSort on List<Competitions> {
  List<Competitions> sorty(String caseField, {bool desc = false}) {
    return this
      ..sort((a, b) {
        int fact = (desc ? -1 : 1);

        if (caseField == CompetitionsEnum.id.name) {
          // unsortable

          int akey = a.id;
          int bkey = b.id;

          return fact * (bkey - akey);
        }

        if (caseField == CompetitionsEnum.name.name) {
          // unsortable

          String akey = a.name;
          String bkey = b.name;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == CompetitionsEnum.code.name) {
          // unsortable

          String akey = a.code;
          String bkey = b.code;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == CompetitionsEnum.type.name) {
          // unsortable

          String akey = a.type;
          String bkey = b.type;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == CompetitionsEnum.emblem.name) {
          // unsortable

          String akey = a.emblem;
          String bkey = b.emblem;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == CompetitionsEnum.plan.name) {
          // unsortable

          String akey = a.plan;
          String bkey = b.plan;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == CompetitionsEnum.numberOfAvailableSeasons.name) {
          // unsortable

          int akey = a.numberOfAvailableSeasons;
          int bkey = b.numberOfAvailableSeasons;

          return fact * (bkey - akey);
        }

        if (caseField == CompetitionsEnum.lastUpdated.name) {
          // unsortable

          DateTime akey = a.lastUpdated;
          DateTime bkey = b.lastUpdated;

          return fact * bkey.compareTo(akey);
        }
        /* 
          case CompetitionsEnum.area:
            // unsortable
            
case CompetitionsEnum.currentSeason: */
        // unsortable

        return 0;
      });
  }
}

class CurrentSeason {
  final int id;

  final DateTime startDate;

  final DateTime endDate;

  final int currentMatchday;

  final dynamic winner;
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
    String? winner,
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
    return {
      CurrentSeasonEnum.id.name: id,
      CurrentSeasonEnum.startDate.name: startDate,
      CurrentSeasonEnum.endDate.name: endDate,
      CurrentSeasonEnum.currentMatchday.name: currentMatchday,
      CurrentSeasonEnum.winner.name: winner,
    };
  }

  factory CurrentSeason.fromJson(Map<String, Object?> json) {
    return CurrentSeason(
      id: int.parse('${json[CurrentSeasonEnum.id.name]}'),
      startDate: DateTime.parse('${json[CurrentSeasonEnum.startDate.name]}'),
      endDate: DateTime.parse('${json[CurrentSeasonEnum.endDate.name]}'),
      currentMatchday: int.parse('${json[CurrentSeasonEnum.currentMatchday.name]}'),
      winner: json[CurrentSeasonEnum.winner.name],
    );
  }

  factory CurrentSeason.fromMap(Map<String, Object?> json) {
    return CurrentSeason(
      id: json[CurrentSeasonEnum.id.name] as int,
      startDate: json[CurrentSeasonEnum.startDate.name] as DateTime,
      endDate: json[CurrentSeasonEnum.endDate.name] as DateTime,
      currentMatchday: json[CurrentSeasonEnum.currentMatchday.name] as int,
      winner: json[CurrentSeasonEnum.winner.name],
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
      ..sort((a, b) {
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

class Area {
  final int id;

  final String name;

  final String code;

  final String? flag;
  Area({
    required this.id,
    required this.name,
    required this.code,
    required this.flag,
  });

  Area copyWith({
    int? id,
    String? name,
    String? code,
    String? flag,
  }) {
    return Area(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      flag: flag ?? this.flag,
    );
  }

  Map<String, Object?> toJson() {
    return {
      AreaEnum.id.name: id,
      AreaEnum.name.name: name,
      AreaEnum.code.name: code,
      AreaEnum.flag.name: flag,
    };
  }

  factory Area.fromJson(Map<String, Object?> json) {
    return Area(
      id: int.parse('${json[AreaEnum.id.name]}'),
      name: json[AreaEnum.name.name] as String,
      code: json[AreaEnum.code.name] as String,
      flag: json[AreaEnum.flag.name] as String?,
    );
  }

  factory Area.fromMap(Map<String, Object?> json) {
    return Area(
      id: json[AreaEnum.id.name] as int,
      name: json[AreaEnum.name.name] as String,
      code: json[AreaEnum.code.name] as String,
      flag: json[AreaEnum.flag.name] as String?,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is Area &&
        other.runtimeType == runtimeType &&
        other.id == id && //
        other.name == name && //
        other.code == code && //
        other.flag == flag;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      name,
      code,
      flag,
    );
  }
}

enum AreaEnum {
  id,
  name,
  code,
  flag,
  none,
}

extension AreaSort on List<Area> {
  List<Area> sorty(String caseField, {bool desc = false}) {
    return this
      ..sort((a, b) {
        int fact = (desc ? -1 : 1);

        if (caseField == AreaEnum.id.name) {
          // unsortable

          int akey = a.id;
          int bkey = b.id;

          return fact * (bkey - akey);
        }

        if (caseField == AreaEnum.name.name) {
          // unsortable

          String akey = a.name;
          String bkey = b.name;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == AreaEnum.code.name) {
          // unsortable

          String akey = a.code;
          String bkey = b.code;

          return fact * (bkey.compareTo(akey));
        }

        return 0;
      });
  }
}
