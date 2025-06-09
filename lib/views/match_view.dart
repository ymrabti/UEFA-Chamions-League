import 'package:botola_max/lib.dart';
import 'package:botola_max/views/match_detail.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MatchView extends StatelessWidget {
  const MatchView({super.key, required this.match});
  final Matche match;
  @override
  Widget build(BuildContext context) {
    // var matchTimeLocal = DateFormat.MMMMd(Get.locale).format(matchTime);
    DateTime matchTime = match.utcDate;
    DateTime now = DateTime.now();
    bool isStarted = matchTime.isBefore(now);
    String homeTeamTla = match.homeTeam.tla;
    String awayTeamTla = match.awayTeam.tla;
    String localeTime = DateFormat.Hm(Get.locale?.languageCode).format(matchTime);
    String localeDate = DateFormat.yMEd(Get.locale?.languageCode).format(matchTime);
    String matchStat = match.status;
    String machDura = match.score.duration;
    int awayScore = match.score.fullTime.away;
    int homeScore = match.score.fullTime.home;
    bool dark = Theme.of(context).brightness == Brightness.dark;
    bool isPlaying = now.between(matchTime, matchTime.add(Duration(minutes: 110)));
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    bottomLeft: Radius.circular(36),
                  ),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TeamAvatar(
                      team: Team(
                        crest: match.awayTeam.crest,
                        id: match.awayTeam.id,
                        name: match.awayTeam.name,
                        shortName: match.awayTeam.name,
                        tla: awayTeamTla,
                      ),
                      tag: 'MatchTeamAway${match.id}${match.awayTeam.id}${match.awayTeam.name}',
                    ),
                    const Gap(5),
                    Text(
                      awayTeamTla.isEmpty ? 'TBD' : awayTeamTla,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: () async {
                  context.read<AppState>().setLoading(true);
                  MatchDetailsModel? matchDetail = await AppLogic.getMatchDetails(match.id);
                  MatchHead2HeadModel? head2head = await AppLogic.head2head(match.id);
                  if (matchDetail == null || head2head == null) return;
                  MatchDetailSupperClass matchDetails = MatchDetailSupperClass(
                    matchDetails: matchDetail,
                    head2head: head2head,
                  );
                  if (!context.mounted) return;
                  context.read<AppState>().setLoading(false);
                  await Get.to<void>(
                    () => MatchDetails(matchDetails: matchDetails),
                    transition: Transition.cupertino,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.skin(dark, dark ? 20 : 10),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(height: 8),
                      Text('${BotolaServices.statusMatch(matchStat)}${BotolaServices.durationMatch(machDura, matchStat: matchStat)}'),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${isStarted ? awayScore : '•'}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  if (matchTime.hour + matchTime.minute != 0) Text(BotolaServices.convertNumbers(localeTime)),
                                  Text(BotolaServices.convertNumbers(localeDate)),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${isStarted ? homeScore : '•'}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isPlaying) LinearProgressIndicator(),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TeamAvatar(
                      team: Team(
                        crest: match.homeTeam.crest,
                        id: match.homeTeam.id,
                        name: match.homeTeam.name,
                        shortName: match.homeTeam.name,
                        tla: homeTeamTla,
                      ),
                      tag: 'MatchTeamHome${match.id}${match.homeTeam.id}${match.homeTeam.name}',
                    ),
                    const Gap(5),
                    Text(
                      homeTeamTla.isEmpty ? 'TBD' : homeTeamTla,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
