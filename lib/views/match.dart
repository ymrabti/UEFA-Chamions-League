// import 'package:console_tools/console_tools.dart';
import 'package:botola_max/lib.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MatchView extends StatefulWidget {
  const MatchView({super.key, required this.match});
  final Matche match;
  @override
  State<MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<MatchView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var matchTimeLocal = DateFormat.MMMMd(Get.locale).format(matchTime);
    DateTime matchTime = widget.match.utcDate;
    DateTime now = DateTime.now().toUtc();
    bool isStarted = matchTime.isBefore(now);
    String homeTeamTla = widget.match.homeTeam.tla;
    String awayTeamTla = widget.match.awayTeam.tla;
    String localeTime = DateFormat.Hm(Get.locale?.languageCode).format(matchTime);
    String localeDate = DateFormat.MEd(Get.locale?.languageCode).format(matchTime);
    String matchStat = widget.match.status;
    String machDura = widget.match.score.duration;
    var away2 = widget.match.score.fullTime.away;
    var home2 = widget.match.score.fullTime.home;
    var dark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
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
                  children: [
                    TeamAvatar(
                      team: Team(
                        crest: widget.match.awayTeam.crest,
                        id: widget.match.awayTeam.id,
                        name: widget.match.awayTeam.name,
                        shortName: widget.match.awayTeam.name,
                        tla: awayTeamTla,
                      ),
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
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.skin(dark, dark ? 20 : 10),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('${BotolaServices.statusMatch(matchStat)}${BotolaServices.durationMatch(machDura, matchStat: matchStat)}'),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${isStarted ? away2 : '•'}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (matchTime.hour + matchTime.minute != 0) Text(BotolaServices.convertNumbers(localeTime)),
                              Text(BotolaServices.convertNumbers(localeDate)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${isStarted ? home2 : '•'}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                  ],
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
                  children: [
                    TeamAvatar(
                      team: Team(
                        crest: widget.match.homeTeam.crest,
                        id: widget.match.homeTeam.id,
                        name: widget.match.homeTeam.name,
                        shortName: widget.match.homeTeam.name,
                        tla: homeTeamTla,
                      ),
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
