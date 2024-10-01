// import 'package:console_tools/console_tools.dart';
import 'dart:async';
import 'package:uefa_champions_league/lib.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart';

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
}

class MatchView extends StatefulWidget {
  const MatchView({super.key, required this.match});
  final Matche match;
  @override
  State<MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<MatchView> {
  @override
  void initState() {
    unawaited(initializeDateFormatting('ar', null));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var matchTimeLocal = DateFormat.MMMMd(Get.locale).format(matchTime);
    var matchTime = widget.match.utcDate;
    var now = DateTime.now().toUtc();
    var isStarted = matchTime.isBefore(now);
    var homeTeamTla = widget.match.homeTeam.tla;
    var awayTeamTla = widget.match.awayTeam.tla;
    var localeTime = DateFormat.Hm(Get.locale?.languageCode).format(matchTime);
    var localeDate = DateFormat.MEd(Get.locale?.languageCode).format(matchTime);
    var matchStat = widget.match.status;
    var machDura = widget.match.score.duration;
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(
                  color: primaryColor,
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
                  color: primaryColor.shade50,
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('${statusMatch(matchStat)}${durationMatch(machDura, matchStat: matchStat)}'),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${isStarted ? widget.match.score.fullTime.away : '•'}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(convertNumbers(localeTime)),
                              Text(convertNumbers(localeDate)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${isStarted ? widget.match.score.fullTime.home : '•'}',
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
                decoration: const BoxDecoration(
                  color: primaryColor,
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

String convertNumbers(String str) {
  return str.replaceAll('٠', '0').replaceAll('١', '1').replaceAll('٢', '2').replaceAll('٣', '3').replaceAll('٤', '4').replaceAll('٥', '5').replaceAll('٦', '6').replaceAll('٧', '7').replaceAll('٨', '8').replaceAll('٩', '9');
}

String statusMatch(String status) {
  switch (status) {
    case 'FINISHED':
      return "Finished";

    case 'TIMED':
      return "Next match";

    case 'IN_PLAY':
      return "Playing";

    case 'PAUSED':
      return "Half time";

    default:
      return status;
  }
}

String durationMatch(String status, {String? matchStat}) {
  if (['TIMED', 'SCHEDULED'].contains(matchStat)) return '';
  switch (status) {
    case 'PENALTY_SHOOTOUT':
      return " : Penalty shootout";

    case 'REGULAR':
      return " : Regular time";

    case 'EXTRA_TIME':
      return " : Extra time";

    default:
      return ' : ' + status;
  }
}
