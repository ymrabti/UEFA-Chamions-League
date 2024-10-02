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
    var gls = fold<List<GoalRanking>>(
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

  List<Widget> get modelDataCL {
    var folding = fold<List<StageWithMatches>>(
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
    return folding.map(
      (e) {
        return ExpansionTile(
          title: Text(
            stageName(e.stage),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: [
            if (e.stage == AppConstants.LEAGUESTAGE)
              ...e.matches.fold(
                <MonthMatches>[],
                (value, element) {
                  if (value.isEmpty) return value..add(MonthMatches(month: element.utcDate, matches: [element]));
                  var sameMonth = value.last.month.sameMonth(element.utcDate);
                  if (sameMonth) {
                    value.last.matches.add(element);
                  } else {
                    value.add(MonthMatches(month: element.utcDate, matches: [element]));
                  }
                  return value;
                },
              ).map(
                (f) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 10),
                    child: ExpansionTile(
                      title: Text(DateFormat.yMMMM().format(f.month)),
                      children: f.matches.map((e) => e.toView()).toList(),
                    ),
                  );
                },
              ),
            if (e.stage != AppConstants.LEAGUESTAGE) ...e.matches.map((e) => e.toView()).toList()
          ],
        );
      },
    ).toList();
  }

  List<Widget> modelDataCup(List<Standing> standings) {
    var reducing = fold<List<StageWithMatches>>(
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

    return reducing.map(
      (e) {
        return ExpansionTile(
          title: Text(
            stageName(e.stage),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: [
            if (e.stage == AppConstants.GROUPSTAGE)
              ...e.matches.fold(
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
              ).map(
                (f) {
                  Standing? groupStanding = standings.firstWhereOrNull((Standing ke) => ke.group == f.stage.replaceAll('GROUP_', 'Group '));
                  return Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 10),
                    child: ExpansionTile(
                      title: Text(f.stage.replaceAll('GROUP_', 'Group ')),
                      children: [
                        ...f.matches.map((e) => e.toView()),
                        if (groupStanding != null) groupStanding.toView(),
                      ],
                    ),
                  );
                },
              ),
            if (e.stage != AppConstants.GROUPSTAGE) ...e.matches.map((e) => e.toView()).toList()
          ],
        );
      },
    ).toList();
  }

  List<Widget> get modelDataLeague {
    var reducing = fold<List<PhaseMatches>>(
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
    );

    return reducing.map(
      (e) {
        return ExpansionTile(
          title: Text(
            stageName('Matchday ${e.matchday}'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: e.matches.map((e) => e.toView()).toList(),
        );
      },
    ).toList();
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
