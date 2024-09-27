import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uefa_champions_league/lib.dart';

class GlobalGoalRanking {
  int scoredFT;
  int scoredRT;
  int scoredET;
  int scoredPT;
  GlobalGoalRanking({
    this.scoredFT = 0,
    this.scoredRT = 0,
    this.scoredET = 0,
    this.scoredPT = 0,
  });
}

class GroupMatches {
  String group;
  List<Matche> matches;
  GroupMatches({required this.group, required this.matches});
}

class StageWithMatches {
  String stage;
  List<Matche> matches;
  List<GroupMatches> groupMatches = [];
  StageWithMatches({required this.stage, required this.matches, this.groupMatches = const []});
  Widget view() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            stage,
            style: const TextStyle(
              fontSize: 36,
              color: Color(0xFFA9A9A9),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...matches.where((e) => e.homeTeam.crest.isNotEmpty).map((e) => e.toView())
      ],
    );
  }
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

class MonthMatches {
  DateTime month;
  List<Matche> matches;
  MonthMatches({required this.month, required this.matches});
}

extension ListMatchesX on List<Matche> {
  GlobalGoalRanking goalsRanking2() {
    int scoredFT = 0;
    int scoredRT = 0;
    int scoredET = 0;
    int scoredPT = 0;
    for (var match in this) {
      scoredRT += match.score.regularTime.home + match.score.regularTime.away;
      scoredET += match.score.extraTime.home + match.score.extraTime.away;
      scoredPT += match.score.penalties.home + match.score.penalties.away;
      scoredFT += match.score.fullTime.home + match.score.fullTime.away;
    }

    return GlobalGoalRanking(
      scoredFT: scoredFT,
      scoredRT: scoredRT,
      scoredET: scoredET,
      scoredPT: scoredPT,
    );
  }

  List<GoalRanking> goalsRanking() {
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

  List<StageWithMatches> get modelData {
    var vari = fold<List<StageWithMatches>>(
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
    List<StageWithMatches> groupStage = vari.where((e) => e.stage == 'LEAGUE_STAGE').toList();
    bool groupStageNotEmpty = groupStage.isNotEmpty;
    if (groupStageNotEmpty) {
      var expansionGroups = groupStage.first.matches.fold<List<GroupMatches>>([], (previousValue, element) {
        var wheras = previousValue.where((e) => e.group == element.group);
        if (wheras.isEmpty) {
          previousValue.add(GroupMatches(group: element.group, matches: [element]));
        } else {
          wheras.first.matches.add(element);
        }
        return previousValue;
      });
      expansionGroups.sort((a, b) => Comparable.compare(a.group, b.group));
      groupStage.first.groupMatches = expansionGroups;
    }
    return vari;
  }
}

// SizedBox(width: Get.width * .75, child: Image.asset('assets/qatar_word.png')),
// ...widgets(widget.matches.matches).map((e) => e.view()),
/* ListView.builder(
    itemCount: widgets2.length,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) => _buildList(widgets2[index]),
), */
// leading: list.icon != null ? Icon(list.icon) : null,
