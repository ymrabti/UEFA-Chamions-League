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
          title: const Text('Statistics'),
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
                        teamLeftText: _scoringText(index, sortDownToUpScored.length),
                        teamRightText: _receiveText(index, sortDownToUpScored.length),
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
          title: const Text('Quick statistics'),
          children: [
            SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                child: Row(
                  children: [
                    RoundedTeam(team: mostScored, left: false),
                    CenterContent(
                      valueLeft: mostScored.allScored,
                      teamLeftText: 'لأكثر تسجيلا', //
                      valueRight: leastReceived.allReceived,
                      teamRightText: 'الأقل استقبالا',
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
                        valueLeft: leastScored.allScored,
                        teamLeftText: 'الأقل تسجيلا',
                        valueRight: mostReceived.allReceived,
                        teamRightText: 'لأكثر استقبالا',
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
                        valueLeft: leastDifference.difference,
                        teamLeftText: 'الأقل فارقا',
                        valueRight: mostDifference.difference,
                        teamRightText: 'لأكثر فارقا',
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
          title: const Text('Goal statistics'),
          initiallyExpanded: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GoalStatistic(
                text: 'الوقت الأصلي',
                intvalueScored: goals.map((e) => e.scoredRT).reduce((a, b) => a + b),
                intvalueReceived: goals.map((e) => e.receivedRT).reduce((a, b) => a + b),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GoalStatistic(
                text: 'الوقت الاضافي',
                intvalueScored: goals.map((e) => e.scoredET).reduce((a, b) => a + b),
                intvalueReceived: goals.map((e) => e.receivedET).reduce((a, b) => a + b),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GoalStatistic(
                text: 'ركلات الترجيح',
                intvalueScored: goals.map((e) => e.scoredPT).reduce((a, b) => a + b),
                intvalueReceived: goals.map((e) => e.receivedPT).reduce((a, b) => a + b),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GoalStatistic(
                text: 'المبارات',
                intvalueScored: goalRanking.scoredFT,
                intvalueReceived: goalRanking.scoredFT,
              ),
            ),
          ],
        )
      ],
    );
  }

  String _scoringText(int index, int len) {
    if (index == 0) return 'لأكثر تسجيلا';
    if (index == len - 1) return 'الأقل تسجيلا';
    return 'سجل';
  }

  String _receiveText(int index, int len) {
    if (index == 0) return 'الأقل استقبالا';
    if (index == len - 1) return 'لأكثر استقبالا';
    return 'استقبل';
  }
}

class GoalStatistic extends StatelessWidget {
  const GoalStatistic({
    Key? key,
    required this.text,
    required this.intvalueScored,
    required this.intvalueReceived,
  }) : super(key: key);

  final String text;
  final int intvalueScored;
  final int intvalueReceived;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                text: 'مجموع الأهداف المسجلة في ',
                children: [
                  TextSpan(
                    text: text,
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' : '),
                  TextSpan(
                    text: '$intvalueScored',
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
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
                text: 'إجمالي الأهداف التي تم تلقيها في ',
                children: [
                  TextSpan(
                    text: text,
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' : '),
                  TextSpan(
                    text: '$intvalueReceived',
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class CenterContent extends StatelessWidget {
  const CenterContent({
    Key? key,
    required this.valueLeft,
    required this.valueRight,
    required this.teamLeftText,
    required this.teamRightText,
  }) : super(key: key);

  final int valueLeft;
  final int valueRight;
  final String teamLeftText;
  final String teamRightText;

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
                    Text(teamLeftText, textAlign: TextAlign.right),
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
                    Text(teamRightText, textAlign: TextAlign.right),
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
