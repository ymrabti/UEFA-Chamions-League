import 'package:collection/collection.dart';
import 'package:uefa_champions_league/lib.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class GoalRankk extends StatelessWidget {
  const GoalRankk({
    super.key,
    required this.goals,
    required this.goalRanking,
  });
  final GlobalGoalRanking goalRanking;
  final List<GoalRanking> goals;

  @override
  Widget build(BuildContext context) {
    // var matchTimeLocal = DateFormat.MMMMd(Get.locale).format(matchTime);
    List<GoalRanking> sortDownToUpReceived = goals.map((e) => e).toList()..sort((a, b) => a.allReceived - b.allReceived);
    List<GoalRanking> sortUpToDownReceived = sortDownToUpReceived.reversed.toList();
    GoalRanking leastReceived = sortDownToUpReceived.first;
    GoalRanking mostReceived = sortUpToDownReceived.first;
    // // //
    List<GoalRanking> sortUpToDownScored = goals.map((e) => e).toList()..sort((a, b) => a.allScored - b.allScored);
    List<GoalRanking> sortDownToUpScored = sortUpToDownScored.reversed.toList();
    GoalRanking leastScored = sortUpToDownScored.first;
    GoalRanking mostScored = sortDownToUpScored.first;
    // // //
    List<GoalRanking> sortDownToUpScoreDifference = goals.map((e) => e).toList()..sort((a, b) => a.difference - b.difference);
    List<GoalRanking> sortUpToDownScoreDifference = sortDownToUpScoreDifference.reversed.toList();
    GoalRanking leastDifference = sortDownToUpScoreDifference.first;
    GoalRanking mostDifference = sortUpToDownScoreDifference.first;
    //

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExpansionTile(
          title: const Text(
            'Statistics',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: sortDownToUpScored.mapIndexed((index, teamLeft) {
            GoalRanking teamRight = sortDownToUpReceived[index];
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: LimitedBox(
                maxHeight: 100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                  child: Row(
                    children: [
                      RoundedTeam(team: teamLeft, left: false),
                      CenterContent(
                        valueLeft: teamLeft.allScored,
                        valueRight: teamRight.allReceived,
                        textLeft: _scoringText(index, sortDownToUpScored.length),
                        textRight: _receiveText(index, sortDownToUpScored.length),
                      ),
                      RoundedTeam(team: teamRight, left: true),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        ExpansionTile(
          title: const Text(
            'Quick statistics',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: [
            SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                child: Row(
                  children: [
                    RoundedTeam(team: mostScored, left: false),
                    CenterContent(
                      textLeft: 'لأكثر تسجيلا', //
                      textRight: 'الأقل استقبالا',
                      valueLeft: mostScored.allScored,
                      valueRight: leastReceived.allReceived,
                    ),
                    RoundedTeam(team: leastReceived, left: true),
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
                    children: [
                      RoundedTeam(team: leastScored, left: false),
                      CenterContent(
                        textLeft: 'الأقل تسجيلا',
                        textRight: 'لأكثر استقبالا',
                        valueLeft: leastScored.allScored,
                        valueRight: mostReceived.allReceived,
                      ),
                      RoundedTeam(team: mostReceived, left: true),
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
                    children: [
                      RoundedTeam(team: leastDifference, left: false),
                      CenterContent(
                        textLeft: 'Less difference',
                        textRight: 'Most difference',
                        valueLeft: leastDifference.difference,
                        valueRight: mostDifference.difference,
                      ),
                      RoundedTeam(team: mostDifference, left: true),
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
          initiallyExpanded: true,
          children: [
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
            children: [
              Text.rich(
                TextSpan(
                  text: 'The total number of goals scored during ',
                  style: TextStyle(),
                  children: [
                    TextSpan(
                      text: text,
                      style: TextStyle(
                        color: primaryColor,
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
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'Home',
                        children: [
                          TextSpan(text: ' : '),
                          TextSpan(
                            text: '$home',
                            style: TextStyle(
                              color: primaryColor,
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
                        children: [
                          TextSpan(text: ' : '),
                          TextSpan(
                            text: '$away',
                            style: TextStyle(
                              color: primaryColor,
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
              children: [
                TextSpan(
                  text: '$home',
                  style: TextStyle(
                    color: primaryColor,
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
          color: primaryColor.shade50,
        ),
        height: 100,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                  children: [
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

class RoundedTeam extends StatelessWidget {
  const RoundedTeam({
    Key? key,
    required this.team,
    this.left = true,
  }) : super(key: key);

  final GoalRanking team;
  final bool left;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only(
            topRight: left ? const Radius.circular(36) : Radius.zero,
            bottomRight: left ? const Radius.circular(36) : Radius.zero,
            topLeft: !left ? const Radius.circular(36) : Radius.zero,
            bottomLeft: !left ? const Radius.circular(36) : Radius.zero,
          ),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TeamAvatar(team: team.team),
              const Gap(5),
              Text(
                team.team.tla,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
