import 'package:botola_max/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class MatchDetails extends StatelessWidget {
  const MatchDetails({super.key, required this.matchDetails});
  final MatchDetailSupperClass matchDetails;
  @override
  Widget build(BuildContext context) {
    int? matchday = matchDetails.matchDetails.matchday;
    String? group = matchDetails.matchDetails.group;
    String stage = matchDetails.matchDetails.stage;
    Winner? winnerSeason = matchDetails.matchDetails.season.winner;
    return ScaffoldBuilder(
      appBar: AppBar(
        title: Text('${matchDetails.matchDetails.homeTeam.name} vs. ${matchDetails.matchDetails.awayTeam.name}'),
      ),
      body: ListView(
        children: [
          matchDetails.matchDetails.matche.view,
          ExpansionTile(
            title: Text('Infos'),
            initiallyExpanded: true,
            children: <Widget>[
              Row(
                children: [
                  SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.trophy)),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: matchDetails.matchDetails.competition.name,
                      ),
                    ),
                  ),
                ],
              ),
              if (matchday != null)
                Row(
                  children: [
                    SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.bridge)),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'Matchday $matchday',
                        ),
                      ),
                    ),
                  ],
                ),
              if (group != null)
                Row(
                  children: [
                    SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.groupArrowsRotate)),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'Group $group',
                        ),
                      ),
                    ),
                  ],
                ),
              Row(
                children: [
                  SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.periscope)),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'Season: ',
                        children: [
                          TextSpan(text: DateFormat.yM().format(matchDetails.matchDetails.season.startDate)),
                          TextSpan(text: ' - ${DateFormat.yM().format(matchDetails.matchDetails.season.endDate)}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 50.w, child: Icon(Icons.pin_drop_rounded)),
                  Expanded(child: Text.rich(TextSpan(text: matchDetails.matchDetails.area.name))),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 50.w, child: Icon(Icons.stairs)),
                  Expanded(child: Text.rich(TextSpan(text: BotolaServices.stageName(stage)))),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 50.w, child: Icon(Icons.date_range)),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: DateFormat.yMMMEd().format(matchDetails.matchDetails.utcDate),
                        children: [
                          TextSpan(text: ' - '),
                          TextSpan(text: DateFormat.Hm().format(matchDetails.matchDetails.utcDate)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.satellite)),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: BotolaServices.statusMatch(matchDetails.matchDetails.status),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.house)),
                  Expanded(
                    child: Text.rich(
                      TextSpan(text: matchDetails.matchDetails.homeTeam.name),
                    ),
                  ),
                  AppFileImageViewer(url: matchDetails.matchDetails.homeTeam.crest, width: 50.r),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.planeDeparture)),
                  Expanded(
                    child: Text.rich(
                      TextSpan(text: matchDetails.matchDetails.awayTeam.name),
                    ),
                  ),
                  AppFileImageViewer(url: matchDetails.matchDetails.awayTeam.crest, width: 50.r),
                ],
              ),
            ].joinBy(
              item: Gap(12.w),
            ),
          ),
          ExpansionTile(
            title: Text('Competition'),
            children: <Widget>[
              Row(
                children: [
                  SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.trophy)),
                  Expanded(child: Text.rich(TextSpan(text: matchDetails.matchDetails.competition.name))),
                ],
              ),
              if (winnerSeason != null)
                Row(
                  children: [
                    SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.star)),
                    Expanded(child: Text('${winnerSeason.name}(${winnerSeason.founded})')),
                    SizedBox(width: 50.w, child: AppFileImageViewer(url: winnerSeason.crest, width: 50.w)),
                    Gap(12.w),
                  ],
                ),
            ].joinBy(
              item: Gap(12.w),
            ),
          ),
          ExpansionTile(
            title: Text('Head2Head'),
            initiallyExpanded: true,
            children: [
              for (var match in matchDetails.head2head.matches.where((e) => e.id != matchDetails.matchDetails.id)) match.view,
            ],
          ),
        ],
      ),
    );
  }
}
