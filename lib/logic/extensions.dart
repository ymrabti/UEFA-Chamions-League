import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:botola_max/lib.dart';
import 'package:uuid/uuid.dart';

abstract class AbstractGoalRanking {
  int scoredFTHome;
  int scoredRTHome;
  int scoredETHome;
  int scoredPTHome;
  int scoredFTAway;
  int scoredRTAway;
  int scoredETAway;
  int scoredPTAway;
  int scoredHTHome;
  int scoredHTAway;
  int get scoredFT => scoredFTHome + scoredFTAway;
  int get scoredRT => scoredRTHome + scoredRTAway;
  int get scoredET => scoredETHome + scoredETAway;
  int get scoredPT => scoredPTHome + scoredPTAway;
  AbstractGoalRanking({
    this.scoredHTAway = 0,
    this.scoredHTHome = 0,
    this.scoredFTHome = 0,
    this.scoredRTHome = 0,
    this.scoredETHome = 0,
    this.scoredPTHome = 0,
    this.scoredFTAway = 0,
    this.scoredRTAway = 0,
    this.scoredETAway = 0,
    this.scoredPTAway = 0,
  });

//   int get allScored => scoredRT + scoredET + scoredPT;
}

class GoalRankingPerCompetition extends AbstractGoalRanking {
  GoalRankingPerCompetition({
    super.scoredHTAway,
    super.scoredHTHome,
    super.scoredFTHome,
    super.scoredRTHome,
    super.scoredETHome,
    super.scoredPTHome,
    super.scoredFTAway,
    super.scoredRTAway,
    super.scoredETAway,
    super.scoredPTAway,
  });
}

class GoalRankingPerTeam extends AbstractGoalRanking {
  Team team;
  GoalRankingPerTeam({
    required this.team,
    super.scoredHTAway,
    super.scoredHTHome,
    super.scoredRTHome,
    super.scoredRTAway,
    super.scoredETHome,
    super.scoredETAway,
    super.scoredPTHome,
    super.scoredPTAway,
  });

  int get allScooreed => scoredFTAway;
  int get allReceived => scoredFTAway;
//   int get allScooreed => scoredRTHome + scoredETHome + scoredPTAway;
//   int get allReceived => scoredRTAway + scoredETAway + scoredPTAway;
  int get difference => allScooreed - allReceived;
}

extension ListStagePhaseMatchesX on List<StagePhaseMatches> {
  List<StagePhase> extractStagePhases() {
    List<StagePhase> stagePhases = [];

    // Helper function to convert StagePhaseMatches to StagePhase and flatten subphases
    void flatten(StagePhaseMatches spm) {
      // Convert StagePhaseMatches to StagePhase and add to the list
      stagePhases.add(
        StagePhase(
          initiallyExpanded: spm.initiallyExpanded,
          groupStanding: spm.groupStanding,
          isSubPhase: spm.isSubPhase,
          globalKey: spm.globalKey,
          matches: spm.matches,
          title: spm.title,
          uuid: spm.uuid,
        ),
      );

      // Recursively flatten subphases
      for (var subPhase in spm.subPhase) {
        flatten(subPhase);
      }
    }

    // Iterate over the top-level list and flatten each item
    for (var spm in this) {
      flatten(spm);
    }

    return stagePhases;
  }

  List<StagePhase> extractStagePhasesWithFold() {
    // Helper function to convert StagePhaseMatches to StagePhase
    List<StagePhase> flatten(StagePhaseMatches spm) {
      List<StagePhase> stagePhases = [];

      // Convert the StagePhaseMatches to StagePhase
      stagePhases.add(
        StagePhase(
          initiallyExpanded: spm.initiallyExpanded,
          groupStanding: spm.groupStanding,
          isSubPhase: spm.isSubPhase,
          globalKey: spm.globalKey,
          matches: spm.matches,
          title: spm.title,
          uuid: spm.uuid,
        ),
      );

      // Recursively flatten subphases
      stagePhases.addAll(spm.subPhase.fold<List<StagePhase>>([], (acc, subPhase) => acc..addAll(flatten(subPhase))));

      return stagePhases;
    }

    // Use fold to accumulate the result into a flat list
    return fold<List<StagePhase>>([], (acc, spm) => acc..addAll(flatten(spm)));
  }
}

extension ListMatchesX on List<Matche> {
  GoalRankingPerCompetition get goalStatsCompetition {
    int scoreRTHome = 0;
    int scoreRTAway = 0;
    int scoreETHome = 0;
    int scoreETAway = 0;
    int scorePTHome = 0;
    int scorePTAway = 0;
    int scoreFTHome = 0;
    int scoreFTAway = 0;
    for (var match in this) {
      int _scoreRTHome = match.score.regularTime.home ?? 0;
      int _scoreRTAway = match.score.regularTime.away ?? 0;
      int _scoreETHome = match.score.extraTime.home ?? 0;
      int _scoreETAway = match.score.extraTime.away ?? 0;
      int _scorePTHome = match.score.penalties.home ?? 0;
      int _scorePTAway = match.score.penalties.away ?? 0;
      int _scoreFTHome = match.score.fullTime.home ?? 0;
      int _scoreFTAway = match.score.fullTime.away ?? 0;
      scoreRTHome += _scoreRTHome;
      scoreRTAway += _scoreRTAway;
      scoreETHome += _scoreETHome;
      scoreETAway += _scoreETAway;
      scorePTHome += _scorePTHome;
      scorePTAway += _scorePTAway;
      scoreFTHome += _scoreFTHome;
      scoreFTAway += _scoreFTAway;
    }

    return GoalRankingPerCompetition(
      scoredRTHome: scoreRTHome,
      scoredRTAway: scoreRTAway,
      scoredETHome: scoreETHome,
      scoredETAway: scoreETAway,
      scoredPTHome: scorePTHome,
      scoredPTAway: scorePTAway,
      scoredFTHome: scoreFTHome,
      scoredFTAway: scoreFTAway,
    );
  }

  List<GoalRankingPerTeam> get goalStatsTeam {
    List<GoalRankingPerTeam> teams = fold(
      <GoalRankingPerTeam>[],
      (List<GoalRankingPerTeam> pmm, Matche cmm) {
        List<int> mapIDs = pmm.map((e) => e.team.id).toList();
        if (!mapIDs.contains(cmm.homeTeam.id)) {
          return pmm..add(GoalRankingPerTeam(team: cmm.homeTeam));
        }
        return pmm;
      },
    );

    return fold<List<GoalRankingPerTeam>>(
      teams,
      (List<GoalRankingPerTeam> pm, Matche cm) {
        const String tla = 'FRA';
        // // //
        GoalRankingPerTeam? homeTeam = pm.firstWhereOrNull((e) => e.team.id == cm.homeTeam.id);
        homeTeam?.scoredHTHome += cm.score.halfTime.home ?? 0;
        homeTeam?.scoredHTAway += cm.score.halfTime.away ?? 0;
        homeTeam?.scoredRTHome += cm.score.regularTime.home ?? 0;
        homeTeam?.scoredRTAway += cm.score.regularTime.away ?? 0;
        homeTeam?.scoredETHome += cm.score.extraTime.home ?? 0;
        homeTeam?.scoredETAway += cm.score.extraTime.away ?? 0;
        homeTeam?.scoredPTHome += cm.score.penalties.home ?? 0;
        homeTeam?.scoredPTAway += cm.score.penalties.away ?? 0;
        homeTeam?.scoredFTHome += cm.score.fullTime.home ?? 0;
        homeTeam?.scoredFTAway += cm.score.fullTime.away ?? 0;
        GoalRankingPerTeam? awayTeam = pm.firstWhereOrNull((e) => e.team.id == cm.awayTeam.id);
        awayTeam?.scoredHTAway += cm.score.halfTime.home ?? 0;
        awayTeam?.scoredHTHome += cm.score.halfTime.away ?? 0;
        awayTeam?.scoredRTAway += cm.score.regularTime.home ?? 0;
        awayTeam?.scoredRTHome += cm.score.regularTime.away ?? 0;
        awayTeam?.scoredETAway += cm.score.extraTime.home ?? 0;
        awayTeam?.scoredETHome += cm.score.extraTime.away ?? 0;
        awayTeam?.scoredPTAway += cm.score.penalties.home ?? 0;
        awayTeam?.scoredPTHome += cm.score.penalties.away ?? 0;
        awayTeam?.scoredFTAway += cm.score.fullTime.home ?? 0;
        awayTeam?.scoredFTHome += cm.score.fullTime.away ?? 0;
        if (awayTeam?.team.tla == tla) {
          List<int> audit = [
            /*****/ cm.score.halfTime.home,
            /**/ cm.score.regularTime.home,
            /****/ cm.score.extraTime.home,
            /****/ cm.score.penalties.home,
            /*****/ cm.score.halfTime.away,
            /**/ cm.score.regularTime.away,
            /****/ cm.score.extraTime.away,
            /****/ cm.score.penalties.away,
          ].whereNotNull().toList();
          logg('${cm.stage}\t${audit.sum}', name: tla);
        }

        return pm;
      },
    );
  }

  List<StagePhaseMatches> get _modelCL {
    List<StageWithMatches> foldingStage = fold<List<StageWithMatches>>(
      [],
      (previousValue, element) {
        var wheras = previousValue.where((e) => e.stage == element.stage);
        if (wheras.isEmpty) {
          previousValue.add(StageWithMatches(stage: element.stage, matches: [element]));
        } else {
          wheras.first.matches.add(element);
        }
        return previousValue;
      },
    );

    List<StagePhaseMatches> expandStagePhase = foldingStage.mapIndexed(
      (index, elm) {
        bool thisFinished = elm.allFinished;
        bool initilExpand = index == 0 ? !thisFinished : foldingStage.elementAt(index - 1).allFinished && !thisFinished;
        List<MonthMatches> foldedMonths = elm.matches.fold(
          <MonthMatches>[],
          (value, element) {
            if (value.isEmpty) return value..add(MonthMatches(month: element.utcDate, matches: [element]));
            bool sameMonth = value.last.month.sameMonth(element.utcDate);
            if (sameMonth) {
              value.last.matches.add(element);
            } else {
              value.add(MonthMatches(month: element.utcDate, matches: [element]));
            }
            return value;
          },
        )..sort((a, b) => a.month.compareTo(b.month));
        return StagePhaseMatches(
          initiallyExpanded: initilExpand,
          uuid: Uuid().v4(),
          globalKey: GlobalKey(),
          isSubPhase: false,
          title: BotolaServices.stageName(elm.stage),
          subPhase: (elm.stage == AppConstants.LEAGUESTAGE)
              ? foldedMonths.mapIndexed(
                  (iiii, ffff) {
                    bool thisFinished = ffff.allFinished;
                    bool initilExpand = iiii == 0 ? !thisFinished : foldedMonths.elementAt(iiii - 1).allFinished && !thisFinished;
                    List<PhaseMatches> foldedMatchdays = ffff.matches.fold(
                      <PhaseMatches>[],
                      (value, element) {
                        if (value.isEmpty) return value..add(PhaseMatches(matchday: element.matchday, matches: [element]));
                        bool sameMonth = value.last.matchday == (element.matchday);
                        if (sameMonth) {
                          value.last.matches.add(element);
                        } else {
                          value.add(PhaseMatches(matchday: element.matchday, matches: [element]));
                        }
                        return value;
                      },
                    )..sort((a, b) => a.matchday.compareTo(b.matchday));
                    logg(foldedMatchdays.map((e) => e.matchday), name: 'matchdays');
                    return StagePhaseMatches(
                      globalKey: GlobalKey(),
                      uuid: Uuid().v4(),
                      initiallyExpanded: initilExpand,
                      title: DateFormat.yMMMM().format(ffff.month),
                      matches: [],
                      subPhase: foldedMatchdays.mapIndexed((jjjj, gggg) {
                        bool thisFinished = gggg.allFinished;
                        bool initilExpand = jjjj == 0 ? !thisFinished : foldedMonths.elementAt(jjjj - 1).allFinished && !thisFinished;
                        return StagePhaseMatches(
                          title: 'Matchday ${gggg.matchday}',
                          uuid: Uuid().v4(),
                          initiallyExpanded: initilExpand,
                          globalKey: GlobalKey(),
                          matches: gggg.matches..sort((a, b) => a.matchday.compareTo(b.matchday)),
                        );
                      }).toList(),
                    );
                  },
                ).toList()
              : [],
          matches: (elm.stage == AppConstants.LEAGUESTAGE) ? [] : elm.matches,
        );
      },
    ).toList();

    return expandStagePhase;
  }

  List<StagePhaseMatches> _modelCup(List<Standing> standings) {
    List<StageWithMatches> reducing = fold<List<StageWithMatches>>(
      [],
      (previousValue, element) {
        var wheras = previousValue.where((e) => e.stage == element.stage);
        if (wheras.isEmpty) {
          previousValue.add(StageWithMatches(stage: element.stage, matches: [element]));
        } else {
          wheras.first.matches.add(element);
        }
        return previousValue;
      },
    );

    List<StagePhaseMatches> expandPhaseStage = reducing.mapIndexed(
      (index, e) {
        bool thisFinished = e.allFinished;
        bool initilExpand = index == 0 ? !thisFinished : reducing.elementAt(index - 1).allFinished && !thisFinished;
        List<StagePhaseMatches> Function() list = () {
          var foldGroups = e.matches.fold(
            <StageWithMatches>[],
            (value, element) {
              if (value.isEmpty) return value..add(StageWithMatches(stage: element.group ?? '', matches: [element]));
              bool foldCondition = value.map((e) => e.stage).contains(element.group);
              if (foldCondition) {
                value.firstWhere((ve) => ve.stage == element.group).matches.add(element);
              } else {
                value.add(StageWithMatches(stage: element.group ?? '', matches: [element]));
              }
              return value;
            },
          )..sort((a, b) => a.stage.compareTo(b.stage));
          return foldGroups.mapIndexed(
            (i, f) {
              bool thisFinished = f.allFinished;
              bool initilExpand = i == 0 ? !thisFinished : foldGroups.elementAt(i - 1).allFinished && !thisFinished;
              Standing? groupStanding = standings.firstWhereOrNull((Standing ke) => ke.group == f.stage.replaceAll('GROUP_', 'Group '));
              return StagePhaseMatches(
                globalKey: GlobalKey(),
                initiallyExpanded: initilExpand,
                uuid: Uuid().v4(),
                title: f.stage.replaceAll('GROUP_', 'Group '),
                groupStanding: groupStanding,
                matches: f.matches,
              );
            },
          ).toList();
        };
        return StagePhaseMatches(
          initiallyExpanded: initilExpand,
          uuid: Uuid().v4(),
          globalKey: GlobalKey(),
          title: BotolaServices.stageName(e.stage),
          isSubPhase: false,
          matches: (e.stage != AppConstants.GROUPSTAGE) ? e.matches : <Matche>[],
          subPhase: (e.stage == AppConstants.GROUPSTAGE) ? list() : <StagePhaseMatches>[],
        );
      },
    ).toList();

    return expandPhaseStage;
  }

  List<StagePhaseMatches> get _modelLeague {
    var reducingMatchdays = fold<List<PhaseMatches>>(
      [],
      (previousValue, element) {
        var wheras = previousValue.where((e) => e.matchday == element.matchday);
        if (wheras.isEmpty) {
          previousValue.add(PhaseMatches(matchday: element.matchday, matches: [element]));
        } else {
          wheras.first.matches.add(element);
        }
        return previousValue;
      },
    )..sort((a, b) => a.matchday - b.matchday);

    var foldExpandMatchdays = reducingMatchdays.mapIndexed(
      (i, e) {
        bool thisFinished = e.allFinished;
        bool initilExpand = i == 0 ? !thisFinished : reducingMatchdays.elementAt(i - 1).allFinished && !thisFinished;
        return StagePhaseMatches(
          uuid: Uuid().v4(),
          globalKey: GlobalKey(),
          initiallyExpanded: initilExpand,
          title: BotolaServices.stageName('Matchday ${e.matchday}'),
          isSubPhase: false,
          matches: e.matches..sort((a, b) => a.utcDate.compareTo(b.utcDate)),
        );
      },
    ).toList();

    return foldExpandMatchdays;
  }

  List<StagePhaseMatches> stagePhaseData({
    required String type,
    required String code,
    required List<Standing> standings,
  }) {
    switch (type) {
      case 'CUP':
        return code == 'CL' ? _modelCL : _modelCup(standings);
      case 'LEAGUE':
        return _modelLeague;
      default:
        return [];
    }
  }
}

class WidgetWithWaiter extends StatelessWidget {
  WidgetWithWaiter({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomThemeSwitchingArea(
      child: Stack(
        children: [
          child,
          if (context.watch<AppState>().loading)
            AbsorbPointer(
              child: Container(
                color: Theme.of(context).cardColor.withOpacity(0.4),
                width: Get.width,
                height: Get.height,
                child: Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: Theme.of(context).primaryColor,
                    size: 125,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
