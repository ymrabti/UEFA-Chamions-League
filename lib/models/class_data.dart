import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:uefa_champions_league/lib.dart';

class GlobalGoalRanking {
  int scoredFTHome;
  int scoredRTHome;
  int scoredETHome;
  int scoredPTHome;
  int scoredFTAway;
  int scoredRTAway;
  int scoredETAway;
  int scoredPTAway;
  int scoredFT;
  int scoredRT;
  int scoredET;
  int scoredPT;
  GlobalGoalRanking({
    this.scoredFT = 0,
    this.scoredRT = 0,
    this.scoredET = 0,
    this.scoredPT = 0,
    this.scoredFTHome = 0,
    this.scoredRTHome = 0,
    this.scoredETHome = 0,
    this.scoredPTHome = 0,
    this.scoredFTAway = 0,
    this.scoredRTAway = 0,
    this.scoredETAway = 0,
    this.scoredPTAway = 0,
  });

  int get allScored => scoredRT + scoredET + scoredPT;
}

class GoalRanking {
  Team team;
  int scoredHT;
  int receivedHT;
  int scoredRT;
  int receivedRT;
  int scoredET;
  int receivedET;
  int scoredPT;
  int receivedPT;
  GoalRanking({
    required this.team,
    this.receivedHT = 0,
    this.scoredHT = 0,
    this.scoredRT = 0,
    this.receivedRT = 0,
    this.scoredET = 0,
    this.receivedET = 0,
    this.scoredPT = 0,
    this.receivedPT = 0,
  });

  int get allReceived => receivedRT + receivedET + receivedPT;
  int get allScored => scoredRT + scoredET + scoredPT;
  int get difference => allScored - allReceived;
}

// LEAGUE
class PhaseMatches {
  int matchday;

  List<Matche> matches;
  PhaseMatches({required this.matchday, required this.matches});
}

// Champions league
class MonthMatches {
  DateTime month;
  List<Matche> matches;
  MonthMatches({required this.month, required this.matches});
}

// Cup
class StageWithMatches {
  String stage;
  List<Matche> matches;
  StageWithMatches({
    required this.stage,
    required this.matches,
  });
}

// Cup
class StagePhaseMatches {
  String title;
  bool initialExpand;
  Standing? groupStanding;
  List<Matche> matches;
  List<StagePhaseMatches> subPhase;
  StagePhaseMatches({
    required this.title,
    this.groupStanding,
    this.initialExpand = false,
    this.matches = const [],
    this.subPhase = const [],
  });
}

extension ListMatchesX on List<Matche> {
  GlobalGoalRanking get goalsStatistics {
    int scoreRTHome = 0;
    int scoreRTAway = 0;
    int scoreETHome = 0;
    int scoreETAway = 0;
    int scorePTHome = 0;
    int scorePTAway = 0;
    int scoreFTHome = 0;
    int scoreFTAway = 0;
    int scoredFT = 0;
    int scoredRT = 0;
    int scoredET = 0;
    int scoredPT = 0;
    for (var match in this) {
      int _scoreRTHome = match.score.regularTime.home;
      int _scoreRTAway = match.score.regularTime.away;
      int _scoreETHome = match.score.extraTime.home;
      int _scoreETAway = match.score.extraTime.away;
      int _scorePTHome = match.score.penalties.home;
      int _scorePTAway = match.score.penalties.away;
      int _scoreFTHome = match.score.fullTime.home;
      int _scoreFTAway = match.score.fullTime.away;
      scoreRTHome += _scoreRTHome;
      scoreRTAway += _scoreRTAway;
      scoreETHome += _scoreETHome;
      scoreETAway += _scoreETAway;
      scorePTHome += _scorePTHome;
      scorePTAway += _scorePTAway;
      scoreFTHome += _scoreFTHome;
      scoreFTAway += _scoreFTAway;
      scoredRT += _scoreRTHome + _scoreRTAway;
      scoredET += _scoreETHome + _scoreETAway;
      scoredPT += _scorePTHome + _scorePTAway;
      scoredFT += _scoreFTHome + _scoreFTAway;
    }

    return GlobalGoalRanking(
      scoredRTHome: scoreRTHome,
      scoredRTAway: scoreRTAway,
      scoredETHome: scoreETHome,
      scoredETAway: scoreETAway,
      scoredPTHome: scorePTHome,
      scoredPTAway: scorePTAway,
      scoredFTHome: scoreFTHome,
      scoredFTAway: scoreFTAway,
      scoredFT: scoredFT,
      scoredRT: scoredRT,
      scoredET: scoredET,
      scoredPT: scoredPT,
    );
  }

  List<GoalRanking> get teamGoalRanking {
    List<GoalRanking> teams = fold(
      <GoalRanking>[],
      (List<GoalRanking> pmm, Matche cmm) {
        List<int> mapIDs = pmm.map((e) => e.team.id).toList();
        if (!mapIDs.contains(cmm.homeTeam.id)) {
          return pmm..add(GoalRanking(team: cmm.homeTeam));
        }
        return pmm;
      },
    );

    List<GoalRanking> gls = fold<List<GoalRanking>>(
      teams,
      (pm, cm) {
        GoalRanking? homeTeam = pm.firstWhereOrNull((e) => e.team.id == cm.homeTeam.id);
        GoalRanking? awayTeam = pm.firstWhereOrNull((e) => e.team.id == cm.awayTeam.id);
        awayTeam?.receivedHT += cm.score.halfTime.home;
        homeTeam?.scoredHT += cm.score.halfTime.home;
        //
        awayTeam?.scoredHT += cm.score.halfTime.away;
        homeTeam?.receivedHT += cm.score.halfTime.away;
        //
        awayTeam?.receivedET += cm.score.extraTime.home;
        homeTeam?.scoredET += cm.score.extraTime.home;
        //
        awayTeam?.scoredET += cm.score.extraTime.away;
        homeTeam?.receivedET += cm.score.extraTime.away;
        //
        awayTeam?.receivedRT += cm.score.regularTime.home;
        homeTeam?.scoredRT += cm.score.regularTime.home;
        //
        awayTeam?.scoredRT += cm.score.regularTime.away;
        homeTeam?.receivedRT += cm.score.regularTime.away;
        //
        awayTeam?.receivedPT += cm.score.penalties.home;
        homeTeam?.scoredPT += cm.score.penalties.home;
        //
        awayTeam?.scoredPT += cm.score.penalties.away;
        homeTeam?.receivedPT += cm.score.penalties.away;
        return pm;
      },
    );

    return gls;
  }

  List<StagePhaseMatches> get _modelCL {
    List<StageWithMatches> folding = fold<List<StageWithMatches>>(
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

    List<StagePhaseMatches> expandStagePhase = folding.mapIndexed(
      (index, elm) {
        List<Matche> matches = elm.matches..sort((a, b) => a.utcDate.compareTo(b.utcDate));
        bool everyThisFinished = matches.every((er) => er.status == AppConstants.FINISHED);
        bool initilExpand = index == 0 ? !everyThisFinished : folding.elementAt(index - 1).matches.every((er) => er.status == AppConstants.FINISHED) && !everyThisFinished;
        return StagePhaseMatches(
          initialExpand: initilExpand,
          title: stageName(elm.stage),
          subPhase: (elm.stage == AppConstants.LEAGUESTAGE)
              ? [
                  ...() {
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
                    return foldedMonths.mapIndexed(
                      (i, f) {
                        List<Matche> matches = f.matches..sort((a, b) => a.utcDate.compareTo(b.utcDate));
                        bool everyThisFinished = matches.every((er) => er.status == AppConstants.FINISHED);
                        bool initilExpand = i == 0 ? !everyThisFinished : foldedMonths.elementAt(i - 1).matches.every((er) => er.status == AppConstants.FINISHED) && !everyThisFinished;
                        return StagePhaseMatches(
                          initialExpand: initilExpand,
                          title: DateFormat.yMMMM().format(f.month),
                          matches: matches,
                        );
                      },
                    );
                  }()
                ]
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
        List<Matche> matches = e.matches..sort((a, b) => a.utcDate.compareTo(b.utcDate));
        bool everyThisFinished = matches.every((er) => er.status == AppConstants.FINISHED);
        bool initilExpand = index == 0 ? !everyThisFinished : reducing.elementAt(index - 1).matches.every((er) => er.status == AppConstants.FINISHED) && !everyThisFinished;
        List<StagePhaseMatches> Function() list = () {
          var foldGroups = e.matches.fold(
            <StageWithMatches>[],
            (value, element) {
              if (value.isEmpty) return value..add(StageWithMatches(stage: element.group, matches: [element]));
              bool foldCondition = value.map((e) => e.stage).contains(element.group);
              if (foldCondition) {
                value.firstWhere((ve) => ve.stage == element.group).matches.add(element);
              } else {
                value.add(StageWithMatches(stage: element.group, matches: [element]));
              }
              return value;
            },
          )..sort((a, b) => a.stage.compareTo(b.stage));
          return foldGroups.mapIndexed(
            (i, f) {
              List<Matche> matches = f.matches..sort((a, b) => a.utcDate.compareTo(b.utcDate));
              bool everyThisFinished = matches.every((er) => er.status == AppConstants.FINISHED);
              bool initilExpand = i == 0 ? !everyThisFinished : foldGroups.elementAt(i - 1).matches.every((er) => er.status == AppConstants.FINISHED) && !everyThisFinished;
              Standing? groupStanding = standings.firstWhereOrNull((Standing ke) => ke.group == f.stage.replaceAll('GROUP_', 'Group '));
              return StagePhaseMatches(
                initialExpand: initilExpand,
                title: f.stage.replaceAll('GROUP_', 'Group '),
                groupStanding: groupStanding,
                matches: f.matches,
              );
            },
          ).toList();
        };
        return StagePhaseMatches(
          initialExpand: initilExpand,
          title: stageName(e.stage),
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
        List<Matche> matches = e.matches..sort((a, b) => a.utcDate.compareTo(b.utcDate));
        bool everyThisFinished = matches.every((er) => er.status == AppConstants.FINISHED);
        bool initilExpand = i == 0 ? !everyThisFinished : reducingMatchdays.elementAt(i - 1).matches.every((er) => er.status == AppConstants.FINISHED) && !everyThisFinished;
        return StagePhaseMatches(
          initialExpand: initilExpand,
          title: stageName('Matchday ${e.matchday}'),
          matches: e.matches,
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
    return Stack(
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
                  color: primaryColor,
                  size: 125,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ...widgets(widget.matches.matches).map((e) => e.view()),
/* ListView.builder(
    itemCount: widgets2.length,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) => _buildList(widgets2[index]),
), */
// leading: list.icon != null ? Icon(list.icon) : null,
