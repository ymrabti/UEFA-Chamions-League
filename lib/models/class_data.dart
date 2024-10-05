import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:botola_max/lib.dart';
import 'package:uuid/uuid.dart';

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

  bool get allFinished => matches.every((er) => er.status == AppConstants.FINISHED);
  List<Matche> matches;
  PhaseMatches({required this.matchday, required this.matches});
}

// Champions league
class MonthMatches {
  DateTime month;
  List<Matche> matches;
  bool get allFinished => matches.every((er) => er.status == AppConstants.FINISHED);
  MonthMatches({required this.month, required this.matches});
}

// Cup
class StageWithMatches {
  String stage;
  List<Matche> matches;
  bool get allFinished => matches.every((er) => er.status == AppConstants.FINISHED);
  StageWithMatches({
    required this.stage,
    required this.matches,
  });
}

// Cup, League, Champions league
class StagePhaseMatches {
  String title;
  String uuid;
  bool initiallyExpanded;
  bool isSubPhase;
  Standing? groupStanding;
  List<Matche> matches;
  List<StagePhaseMatches> subPhase;
  GlobalKey<State<StatefulWidget>> globalKey;
  StagePhaseMatches({
    required this.title,
    required this.uuid,
    required this.globalKey,
    this.groupStanding,
    this.initiallyExpanded = false,
    this.isSubPhase = true,
    this.matches = const [],
    this.subPhase = const [],
  });
  Widget view(BuildContext context, {Size? splashedSize, String? splashedId, bool? splashing}) {
    Standing? groupStand = groupStanding;
    return Stack(
      children: [
        ExpansionTile(
          key: globalKey,
          title: Text(
            title,
            style: isSubPhase
                ? null
                : const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
          ),
          initiallyExpanded: context.watch<AppState>().getEntryExpansion(uuid),
          onExpansionChanged: (value) {
            context.read<AppState>().setExpansion(uuid, value);
          },
          childrenPadding: EdgeInsets.only(left: 4),
          children: [
            ...(subPhase.isEmpty
                ? matches.map(
                    (e) => e.view(),
                  )
                : [
                    ...subPhase.map(
                      (e) => e.view(context, splashedSize: splashedSize, splashedId: splashedId, splashing: splashing),
                    ),
                    if (groupStand != null) groupStand.view(),
                  ]),
          ],
        ),
        if (splashedId == uuid && (splashing ?? false))
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Theme.of(context).primaryColor.withOpacity(0.7),
                Theme.of(context).brightness == Brightness.dark ? BlendMode.lighten : BlendMode.multiply,
              ),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        /* AnimatedContainer(
            duration: Duration(milliseconds: 300),
            color: Colors.red.withOpacity(0.3),
            child: SizedBox.fromSize(size: splashedSize),
          ), */
        /* Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.compose(
                outer: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                inner: ImageFilter.matrix(_createBlendMatrix(Colors.blue)),
              ),
              child: Container(
                color: Colors.transparent, // You can apply an optional base color here
              ),
            ),
          ), */
      ],
    );
  }

  Matrix4 createBlendMatrix(Color color) {
    // Create a matrix for the blend mode effect, using the color
    return Matrix4.identity()
      ..setEntry(3, 2, 0.001) // Perspective control
      ..translate(0.0, 0.0, 0.0);
  }
}

class StagePhase {
  String title;
  String uuid;
  bool initiallyExpanded;
  bool isSubPhase;
  Standing? groupStanding;
  List<Matche> matches;
  GlobalKey<State<StatefulWidget>> globalKey;
  StagePhase({
    required this.title,
    required this.uuid,
    required this.globalKey,
    this.groupStanding,
    this.initiallyExpanded = false,
    required this.isSubPhase,
    this.matches = const [],
  });
}

List<StagePhase> extractStagePhases(List<StagePhaseMatches> stagePhaseMatchesList) {
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
  for (var spm in stagePhaseMatchesList) {
    flatten(spm);
  }

  return stagePhases;
}

List<StagePhase> extractStagePhasesWithFold(List<StagePhaseMatches> stagePhaseMatchesList) {
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
  return stagePhaseMatchesList.fold<List<StagePhase>>([], (acc, spm) => acc..addAll(flatten(spm)));
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
        //
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
          title: stageName(elm.stage),
          subPhase: (elm.stage == AppConstants.LEAGUESTAGE)
              ? foldedMonths.mapIndexed(
                  (iiii, ffff) {
                    bool thisFinished = ffff.allFinished;
                    bool initilExpand = iiii == 0 ? !thisFinished : foldedMonths.elementAt(iiii - 1).allFinished && !thisFinished;
                    //
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
          title: stageName(e.stage),
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
          title: stageName('Matchday ${e.matchday}'),
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
