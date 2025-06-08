import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:botola_max/lib.dart';
import 'package:timeago/timeago.dart';
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
  int get scoredFT => scoredFTHome + scoredFTAway;
  int get scoredRT => scoredRTHome + scoredRTAway;
  int get scoredET => scoredETHome + scoredETAway;
  int get scoredPT => scoredPTHome + scoredPTAway;
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

  // int get allScooreed => scoredFTHome;
  // int get allReceived => scoredFTAway;

  int get allScooreed => scoredRTHome + scoredETHome + scoredPTHome;
  int get allReceived => scoredRTAway + scoredETAway + scoredPTAway;
  int get difference => allScooreed - allReceived;
}

extension ListStagePhaseMatchesX on List<StagePhaseMatches> {
  List<StagePhase> extractStagePhases() {
    List<StagePhase> stagePhases = <StagePhase>[];

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
      for (StagePhaseMatches subPhase in spm.subPhase) {
        flatten(subPhase);
      }
    }

    // Iterate over the top-level list and flatten each item
    for (StagePhaseMatches spm in this) {
      flatten(spm);
    }

    return stagePhases;
  }

  List<StagePhase> extractStagePhasesWithFold() {
    // Helper function to convert StagePhaseMatches to StagePhase
    List<StagePhase> flatten(StagePhaseMatches spm) {
      List<StagePhase> stagePhases = <StagePhase>[];

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
      stagePhases.addAll(spm.subPhase.fold<List<StagePhase>>(<StagePhase>[], (List<StagePhase> acc, StagePhaseMatches subPhase) => acc..addAll(flatten(subPhase))));

      return stagePhases;
    }

    // Use Fold to accumulate the result into a flat list
    return fold<List<StagePhase>>(<StagePhase>[], (List<StagePhase> acc, StagePhaseMatches spm) => acc..addAll(flatten(spm)));
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
    for (Matche match in this) {
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
    List<GoalRankingPerTeam> teams = fold<List<GoalRankingPerTeam>>(
      <GoalRankingPerTeam>[],
      (List<GoalRankingPerTeam> pmm, Matche cmm) {
        List<int> mapIDs = pmm.map((GoalRankingPerTeam e) => e.team.id).toList();
        if (!mapIDs.contains(cmm.homeTeam.id)) {
          return pmm..add(GoalRankingPerTeam(team: cmm.homeTeam));
        }
        return pmm;
      },
    );

    return fold<List<GoalRankingPerTeam>>(
      teams,
      (List<GoalRankingPerTeam> pm, Matche cm) {
        // // //
        GoalRankingPerTeam? homeTeam = pm.firstWhereOrNull((GoalRankingPerTeam e) => e.team.id == cm.homeTeam.id);
        homeTeam?.scoredHTHome += cm.score.halfTime.home;
        homeTeam?.scoredHTAway += cm.score.halfTime.away;
        homeTeam?.scoredRTHome += cm.score.regularTime.home;
        homeTeam?.scoredRTAway += cm.score.regularTime.away;
        homeTeam?.scoredETHome += cm.score.extraTime.home;
        homeTeam?.scoredETAway += cm.score.extraTime.away;
        homeTeam?.scoredPTHome += cm.score.penalties.home;
        homeTeam?.scoredPTAway += cm.score.penalties.away;
        homeTeam?.scoredFTHome += cm.score.fullTime.home;
        homeTeam?.scoredFTAway += cm.score.fullTime.away;
        GoalRankingPerTeam? awayTeam = pm.firstWhereOrNull((GoalRankingPerTeam e) => e.team.id == cm.awayTeam.id);
        awayTeam?.scoredHTAway += cm.score.halfTime.home;
        awayTeam?.scoredHTHome += cm.score.halfTime.away;
        awayTeam?.scoredRTAway += cm.score.regularTime.home;
        awayTeam?.scoredRTHome += cm.score.regularTime.away;
        awayTeam?.scoredETAway += cm.score.extraTime.home;
        awayTeam?.scoredETHome += cm.score.extraTime.away;
        awayTeam?.scoredPTAway += cm.score.penalties.home;
        awayTeam?.scoredPTHome += cm.score.penalties.away;
        awayTeam?.scoredFTAway += cm.score.fullTime.home;
        awayTeam?.scoredFTHome += cm.score.fullTime.away;
        return pm;
      },
    );
  }

  List<StagePhaseMatches> get _modelCL {
    List<GeneralStageWithMatchesData<String>> stages = GeneralStageWithMatches<String>(
      getTitle: (Matche data) => data.stage,
      matches: this,
      test: (String prev, String last) => prev == last,
    ).subphases;

    List<StagePhaseMatches> expandStagePhase = stages.mapIndexed(
      (int index, GeneralStageWithMatchesData<String> elm) {
        bool thisFinished = elm.allFinished;
        bool initilExpand = index == 0 ? !thisFinished : stages.elementAt(index - 1).allFinished && !thisFinished;

        List<GeneralStageWithMatchesData<DateTime>> gg = GeneralStageWithMatches<DateTime>(
          getTitle: (Matche data) => data.utcDate,
          matches: elm.matches,
          test: (DateTime prev, DateTime last) => prev.sameMonth(last),
        ).subphases
          ..sort((GeneralStageWithMatchesData<DateTime> a, GeneralStageWithMatchesData<DateTime> b) => a.title.compareTo(b.title));
        return StagePhaseMatches(
          initiallyExpanded: initilExpand,
          uuid: Uuid().v4(),
          globalKey: GlobalKey(debugLabel: Uuid().v6()),
          isSubPhase: false,
          title: BotolaServices.stageName(elm.title),
          subPhase: (elm.title == AppConstants.LEAGUESTAGE)
              ? gg.mapIndexed(
                  (int iiii, GeneralStageWithMatchesData<DateTime> ffff) {
                    bool thisFinished = ffff.allFinished;
                    bool initilExpand = iiii == 0 ? !thisFinished : gg.elementAt(iiii - 1).allFinished && !thisFinished;
                    List<GeneralStageWithMatchesData<int>> g = GeneralStageWithMatches<int>(
                      getTitle: (Matche data) => data.matchday,
                      matches: ffff.matches,
                      test: (int prev, int last) => last == prev,
                    ).subphases
                      ..sort((GeneralStageWithMatchesData<int> a, GeneralStageWithMatchesData<int> b) {
                        int titleA = a.title;
                        int titleB = b.title;
                        return Comparable.compare(titleA, titleB);
                      });
                    return StagePhaseMatches(
                      globalKey: GlobalKey(debugLabel: Uuid().v6()),
                      uuid: Uuid().v4(),
                      initiallyExpanded: initilExpand,
                      title: DateFormat.yMMMM().format(ffff.title),
                      matches: <Matche>[],
                      subPhase: g.mapIndexed((int jjjj, GeneralStageWithMatchesData<int> gggg) {
                        bool thisFinished = gggg.allFinished;
                        bool initilExpand = jjjj == 0 ? !thisFinished : gg.elementAt(jjjj - 1).allFinished && !thisFinished;
                        return StagePhaseMatches(
                          title: 'Matchday ${gggg.title}',
                          uuid: Uuid().v4(),
                          initiallyExpanded: initilExpand,
                          globalKey: GlobalKey(debugLabel: Uuid().v6()),
                          matches: gggg.matches..sort((Matche a, Matche b) => a.matchday.compareTo(b.matchday)),
                        );
                      }).toList(),
                    );
                  },
                ).toList()
              : <StagePhaseMatches>[],
          matches: (elm.title == AppConstants.LEAGUESTAGE) ? <Matche>[] : elm.matches,
        );
      },
    ).toList();

    return expandStagePhase;
  }

  List<StagePhaseMatches> _modelCup(List<Standing> standings) {
    List<GeneralStageWithMatchesData<String>> g = GeneralStageWithMatches<String>(
      getTitle: (Matche data) => data.stage,
      matches: this,
      test: (String prev, String last) => prev == last,
    ).subphases;
    List<StagePhaseMatches> expandPhaseStage = g.mapIndexed(
      (int index, GeneralStageWithMatchesData<String> e) {
        bool thisFinished = e.allFinished;
        bool initilExpand = index == 0 ? !thisFinished : g.elementAt(index - 1).allFinished && !thisFinished;
        List<StagePhaseMatches> Function() list = () {
          List<GeneralStageWithMatchesData<String?>> gg = GeneralStageWithMatches<String?>(
            getTitle: (Matche data) => data.group,
            matches: e.matches,
            test: (String? prev, String? last) => prev == last,
          ).subphases
            ..sort((GeneralStageWithMatchesData<String?> a, GeneralStageWithMatchesData<String?> b) => a.title?.compareTo(b.title ?? '') ?? 0);
          return gg.mapIndexed(
            (int i, GeneralStageWithMatchesData<String?> f) {
              bool thisFinished = f.allFinished;
              bool initilExpand = i == 0 ? !thisFinished : gg.elementAt(i - 1).allFinished && !thisFinished;
              Standing? groupStanding = standings.firstWhereOrNull((Standing ke) => ke.group == f.title?.replaceAll('GROUP_', 'Group '));
              return StagePhaseMatches(
                globalKey: GlobalKey(debugLabel: Uuid().v6()),
                initiallyExpanded: initilExpand,
                uuid: Uuid().v4(),
                title: f.title?.replaceAll('GROUP_', 'Group ') ?? '',
                groupStanding: groupStanding,
                matches: f.matches,
              );
            },
          ).toList();
        };
        return StagePhaseMatches(
          initiallyExpanded: initilExpand,
          uuid: Uuid().v4(),
          globalKey: GlobalKey(debugLabel: Uuid().v6()),
          title: BotolaServices.stageName(e.title),
          isSubPhase: false,
          matches: (e.title != AppConstants.GROUPSTAGE) ? e.matches : <Matche>[],
          subPhase: (e.title == AppConstants.GROUPSTAGE) ? list() : <StagePhaseMatches>[],
        );
      },
    ).toList();

    return expandPhaseStage;
  }

  List<StagePhaseMatches> get _modelLeague {
    List<GeneralStageWithMatchesData<int>> gg = GeneralStageWithMatches<int>(
      getTitle: (Matche data) => data.matchday,
      matches: this,
      test: (int prev, int last) => prev == last,
    ).subphases
      ..sort((GeneralStageWithMatchesData<int> a, GeneralStageWithMatchesData<int> b) => a.title.compareTo(b.title));

    return gg.mapIndexed(
      (int i, GeneralStageWithMatchesData<int> e) {
        bool thisFinished = e.allFinished;
        bool initilExpand = i == 0 ? !thisFinished : gg.elementAt(i - 1).allFinished && !thisFinished;
        return StagePhaseMatches(
          uuid: Uuid().v4(),
          globalKey: GlobalKey(debugLabel: Uuid().v6()),
          initiallyExpanded: initilExpand,
          title: BotolaServices.stageName('Matchday ${e.title}'),
          isSubPhase: false,
          matches: e.matches..sort((Matche a, Matche b) => a.utcDate.compareTo(b.utcDate)),
        );
      },
    ).toList();
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
        return <StagePhaseMatches>[];
    }
  }
}

extension DateTimeX on DateTime {
  String eeeDDDMMM() {
    return DateFormat("EEE, dd MMM", Get.locale?.languageCode).format(this);
  }

  String formated() {
    // return DateFormat("hh:mm a").format(this);
    return format(this, allowFromNow: isAfter(DateTime.now()));
  }

  bool sameDay(DateTime other) => sameMonth(other) && day == other.day;

  bool sameMonth(DateTime other) => year == other.year && month == other.month;

  bool between(DateTime down, DateTime up) => isAfter(down) && isBefore(up);
}

extension ListX<T> on List<T> {
  List<T> reverse(bool arabic) {
    return arabic ? reversed.toList() : this;
  }

  List<T> joinBy({required T item, T Function(T index)? transformer, bool outline = true}) {
    List<T> inline = mapIndexed((int i, T e) => <T>[if (i != 0) item, (transformer ?? (T it) => it)(e)]).toList().expand((List<T> ex) => ex).toList();
    return <T>[if (outline) item, ...inline, if (outline) item];
  }

  List<T> joinByBuilder(T Function(int index) builder, {bool outline = true}) {
    List<T> inline = mapIndexed((int i, T e) => <T>[if (i != 0) builder(i), e]).toList().expand((List<T> e) => e).toList();
    return <T>[if (outline) builder(0), ...inline, if (outline) builder(length)];
  }
}

extension CardIconX on Widget {
  Widget toCard({Color? color, double pad = 6}) {
    return Card(
      elevation: 1,
      color: color ?? Get.theme.colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.all(pad),
        child: this,
      ),
    );
  }
}
