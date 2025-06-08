import 'package:collection/collection.dart';
import 'package:botola_max/lib.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class GoalRankk extends StatelessWidget {
  const GoalRankk({
    super.key,
    required this.goals,
    required this.goalRanking,
  });
  final GoalRankingPerCompetition goalRanking;
  final List<GoalRankingPerTeam> goals;

  @override
  Widget build(BuildContext context) {
    // var matchTimeLocal = DateFormat.MMMMd(Get.locale).format(matchTime);
    Iterable<GoalRankingPerTeam> goalsPure = goals.where((GoalRankingPerTeam e) => e.team.crest.isNotEmpty);
    List<GoalRankingPerTeam> sortDownToUpReceived = goalsPure.map((GoalRankingPerTeam e) => e).toList()..sort((GoalRankingPerTeam a, GoalRankingPerTeam b) => a.allReceived - b.allReceived);
    List<GoalRankingPerTeam> sortUpToDownReceived = sortDownToUpReceived.reversed.toList();
    GoalRankingPerTeam leastReceived = sortDownToUpReceived.first;
    GoalRankingPerTeam mostReceived = sortUpToDownReceived.first;
    // // //
    List<GoalRankingPerTeam> sortUpToDownScored = goalsPure.map((GoalRankingPerTeam e) => e).toList()..sort((GoalRankingPerTeam a, GoalRankingPerTeam b) => a.allScooreed - b.allScooreed);
    List<GoalRankingPerTeam> sortDownToUpScored = sortUpToDownScored.reversed.toList();
    GoalRankingPerTeam leastScored = sortUpToDownScored.first;
    GoalRankingPerTeam mostScored = sortDownToUpScored.first;
    // // //
    List<GoalRankingPerTeam> sortDownToUpScoreDifference = goalsPure.map((GoalRankingPerTeam e) => e).toList()..sort((GoalRankingPerTeam a, GoalRankingPerTeam b) => a.difference - b.difference);
    List<GoalRankingPerTeam> sortUpToDownScoreDifference = sortDownToUpScoreDifference.reversed.toList();
    GoalRankingPerTeam leastDifference = sortDownToUpScoreDifference.first;
    GoalRankingPerTeam mostDifference = sortUpToDownScoreDifference.first;
    //

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ExpansionTile(
          maintainState: true,
          title: const Text(
            'Statistics',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          initiallyExpanded: true,
          children: sortDownToUpScored.mapIndexed((int index, GoalRankingPerTeam teamLeft) {
            GoalRankingPerTeam teamRight = sortDownToUpReceived[index];
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: LimitedBox(
                maxHeight: 100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                  child: Row(
                    children: <Widget>[
                      RoundedTeam(team: teamLeft, left: false, tag: 'Statistics'),
                      CenterContent(
                        valueLeft: teamLeft.allScooreed,
                        valueRight: teamRight.allReceived,
                        textLeft: _scoringText(index, sortDownToUpScored.length),
                        textRight: _receiveText(index, sortDownToUpScored.length),
                      ),
                      RoundedTeam(team: teamRight, left: true, tag: 'Statistics'),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        ExpansionTile(
          maintainState: true,
          title: const Text(
            'Quick statistics',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                child: Row(
                  children: <Widget>[
                    RoundedTeam(team: mostScored, left: false, tag: 'mostScored'),
                    CenterContent(
                      textLeft: 'لأكثر تسجيلا', //
                      textRight: 'الأقل استقبالا',
                      valueLeft: mostScored.allScooreed,
                      valueRight: leastReceived.allReceived,
                    ),
                    RoundedTeam(team: leastReceived, left: true, tag: 'leastReceived'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                  child: Row(
                    children: <Widget>[
                      RoundedTeam(team: leastScored, left: false, tag: 'leastScored'),
                      CenterContent(
                        textLeft: 'الأقل تسجيلا',
                        textRight: 'لأكثر استقبالا',
                        valueLeft: leastScored.allScooreed,
                        valueRight: mostReceived.allReceived,
                      ),
                      RoundedTeam(team: mostReceived, left: true, tag: 'mostReceived'),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                  child: Row(
                    children: <Widget>[
                      RoundedTeam(team: leastDifference, left: false, tag: 'leastDifference'),
                      CenterContent(
                        textLeft: 'Less difference',
                        textRight: 'Most difference',
                        valueLeft: leastDifference.difference,
                        valueRight: mostDifference.difference,
                      ),
                      RoundedTeam(team: mostDifference, left: true, tag: 'mostDifference'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text(
            'Goal statistics',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          maintainState: true,
          initiallyExpanded: true,
          children: <Widget>[
            GoalStatistic(text: 'regular time', home: goalRanking.scoredRTHome, away: goalRanking.scoredRTAway),
            GoalStatistic(text: 'extra time', home: goalRanking.scoredETHome, away: goalRanking.scoredETAway),
            GoalStatistic(text: 'penalty shootout', home: goalRanking.scoredPTHome, away: goalRanking.scoredPTAway),
            GoalStatistic(total: true, text: '', home: goalRanking.scoredFT, away: goalRanking.scoredFT),
          ],
        ),
        Gap(20),
      ],
    );
  }

  String _scoringText(int index, int len) {
    if (index == 0) return 'Most scorer';
    if (index == len - 1) return 'Less scorer';
    return 'Score';
  }

  String _receiveText(int index, int len) {
    if (index == 0) return 'Less receiving';
    if (index == len - 1) return 'Most receiving';
    return 'Receive';
  }
}

class GoalStatistic extends StatelessWidget {
  const GoalStatistic({
    Key? key,
    required this.text,
    required this.home,
    required this.away,
    this.total = false,
  }) : super(key: key);

  final String text;
  final bool total;
  final int home;
  final int away;

  @override
  Widget build(BuildContext context) {
    if (home + away != 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 4),
        child: Visibility(
          visible: total,
          replacement: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text.rich(
                TextSpan(
                  text: 'The total number of goals scored during ',
                  style: TextStyle(),
                  children: <InlineSpan>[
                    TextSpan(
                      text: text,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor.invers(
                              Theme.of(context).brightness == Brightness.dark,
                            ),
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'Home',
                        children: <InlineSpan>[
                          TextSpan(text: ' : '),
                          TextSpan(
                            text: '$home',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor.invers(
                                    Theme.of(context).brightness == Brightness.dark,
                                  ),
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const Divider(height: 50, thickness: 5),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'Away',
                        children: <InlineSpan>[
                          TextSpan(text: ' : '),
                          TextSpan(
                            text: '$away',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor.invers(
                                    Theme.of(context).brightness == Brightness.dark,
                                  ),
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              Divider(height: 5, color: Theme.of(context).primaryColor)
            ],
          ),
          child: Text.rich(
            TextSpan(
              text: 'Total goals : ',
              children: <InlineSpan>[
                TextSpan(
                  text: '$home',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor.invers(
                          Theme.of(context).brightness == Brightness.dark,
                        ),
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.left,
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}

class CenterContent extends StatelessWidget {
  const CenterContent({
    Key? key,
    required this.valueLeft,
    required this.valueRight,
    required this.textLeft,
    required this.textRight,
  }) : super(key: key);

  final int valueLeft;
  final int valueRight;
  final String textLeft;
  final String textRight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.skin(Theme.of(context).brightness == Brightness.dark, 50),
        ),
        height: 100,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(textLeft, textAlign: TextAlign.right),
                    Text('$valueLeft', textAlign: TextAlign.right),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(textRight, textAlign: TextAlign.right),
                    Text('$valueRight', textAlign: TextAlign.left),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
