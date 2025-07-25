import 'package:botola_max/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ElBotolaChampionsList extends IGenericAppModel {
  final int count;

  final List<TheCompetition> competitions;
  ElBotolaChampionsList({
    required this.count,
    required this.competitions,
  });

  ElBotolaChampionsList copyWith({
    int? count,
    List<TheCompetition>? competitions,
  }) {
    return ElBotolaChampionsList(
      count: count ?? this.count,
      competitions: competitions ?? this.competitions,
    );
  }

  @override
  Map<String, Object?> toJson() {
    return Map<String, Object?>.fromEntries(<MapEntry<String, Object?>>[
      MapEntry<String, Object?>(
        ElBotolaChampionsListEnum.count.name,
        count,
      ),
      MapEntry<String, Object?>(
        ElBotolaChampionsListEnum.competitions.name,
        competitions
            .map<Map<String, Object?>>(
              (TheCompetition data) => data.toJson(),
            )
            .toList(),
      ),
    ]);
  }

  factory ElBotolaChampionsList.fromJson(Map<String, Object?> json) {
    return ElBotolaChampionsList(
      count: int.parse('${json[ElBotolaChampionsListEnum.count.name]}'),
      competitions: (json[ElBotolaChampionsListEnum.competitions.name] as List<dynamic>)
          .map<TheCompetition>(
            (dynamic data) => TheCompetition.fromJson(data as Map<String, Object?>),
          )
          .toList(),
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
      ..sort((ElBotolaChampionsList a, ElBotolaChampionsList b) {
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

class TheCompetition {
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
  TheCompetition({
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

  TheCompetition copyWith({
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
    return TheCompetition(
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

  Future<void> gotoParticularCompetition(BuildContext context) async {
    RefreshCompetiton? refreshCompetition = await SharedPrefsDatabase.refreshCompetition(
      context: context,
      code: code,
      type: type,
    );
    if (!context.mounted) return;
    if (refreshCompetition == null) return;
    context.read<AppState>().setExpansionAll(refreshCompetition.stagedData);
    await Get.to<void>(
      () => AppLeague(
        competition: refreshCompetition,
      ),
      arguments: <String, String>{'competition-id': code},
    );
  }

  Widget view() {
    TheCompetition theCompitition = this;
    String startYear = DateFormat.y().format(theCompitition.currentSeason.startDate);
    String endYear = DateFormat.y().format(theCompitition.currentSeason.endDate);
    return Builder(builder: (BuildContext context) {
      return Card(
        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: InkWell(
          onTap: () => gotoParticularCompetition(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Row(
              children: <Widget>[
                AppFileImageViewer(
                  width: 80.r,
                  height: 80.r,
                  url: (theCompitition.emblem),
                  color: elbrem.contains(theCompitition.code) //
                      ? Theme.of(context).colorScheme.surface.invers(true)
                      : null,
                ),
                Gap(12),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: theCompitition.name,
                      children: <InlineSpan>[
                        TextSpan(
                          text: ' (${theCompitition.code})',
                          style: TextStyle(fontSize: 10),
                        ),
                        if (theCompitition.type == 'LEAGUE') ...<InlineSpan>[
                          TextSpan(
                            text: '\nMatchday: ',
                            style: TextStyle(fontSize: 10),
                          ),
                          TextSpan(
                            text: '${theCompitition.currentSeason.currentMatchday}',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor.invers(
                                      Theme.of(context).brightness == Brightness.dark,
                                    ),
                                fontSize: 10),
                          ),
                        ],
                        TextSpan(
                          text: '\nSeason: $startYear/$endYear',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    softWrap: true,
                    maxLines: 4,
                    // style: TextStyle(color: e.colorText),
                  ),
                ),
                Text(theCompitition.area.name)
              ],
            ),
          ),
        ),
      );
    });
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
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

  factory TheCompetition.fromJson(Map<String, Object?> json) {
    return TheCompetition(
      id: int.parse('${json[CompetitionsEnum.id.name]}'),
      area: Area.fromJson(json[CompetitionsEnum.area.name] as Map<String, Object?>),
      name: json[CompetitionsEnum.name.name] as String,
      code: json[CompetitionsEnum.code.name] as String,
      type: json[CompetitionsEnum.type.name] as String,
      emblem: json[CompetitionsEnum.emblem.name] as String,
      plan: json[CompetitionsEnum.plan.name] as String,
      currentSeason: CurrentSeason.fromJson(json[CompetitionsEnum.currentSeason.name] as Map<String, Object?>),
      numberOfAvailableSeasons: int.parse('${json[CompetitionsEnum.numberOfAvailableSeasons.name]}'),
      lastUpdated: DateTime.parse('${json[CompetitionsEnum.lastUpdated.name]}').add(DateTime.now().timeZoneOffset),
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is TheCompetition &&
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

extension CompetitionsSort on List<TheCompetition> {
  List<TheCompetition> sorty(String caseField, {bool desc = false}) {
    return this
      ..sort((TheCompetition a, TheCompetition b) {
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
    return <String, Object?>{
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
      ..sort((Area a, Area b) {
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
