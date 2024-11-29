import 'package:botola_max/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamDetails extends StatelessWidget {
  const TeamDetails({
    super.key,
    required this.team,
    required this.tag,
  });
  final String tag;
  final Teams team;

  @override
  Widget build(BuildContext context) {
    String crest = (team.crest);
    String? website = team.website;
    var founded = team.founded;
    DateTime? coachBirth = team.coach.dateOfBirth;
    DateTime? coachContractStart = team.coach.contract?.start;
    DateTime? coachContractEnd = team.coach.contract?.until;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () async {
            await Get.to<void>(
              () => Scaffold(
                body: InteractiveCrest(crest: crest, tag: tag),
              ),
            );
          },
          child: AppFileImageViewer(url: crest),
        ),
        title: Text(team.name),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ExpansionTile(
            title: Text('Infos'),
            initiallyExpanded: true,
            children: <Widget>[
              Row(
                children: [
                  SizedBox(width: 50.w, child: Icon(Icons.pin_drop_rounded)),
                  Expanded(child: Text.rich(TextSpan(text: team.area.name))),
                  InkWell(
                    onTap: () async {
                      String? flag = team.area.flag;
                      if (flag == null) return;
                      await Get.to<void>(
                        () {
                          return Scaffold(
                            body: InteractiveCrest(crest: flag, tag: tag),
                          );
                        },
                      );
                    },
                    child: SizedBox(
                      width: 50.w,
                      child: AppFileImageViewer(width: 50.w, url: team.area.flag),
                    ),
                  ),
                  SizedBox(width: 12.w),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.idBadge)),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: team.name,
                        children: [
                          TextSpan(text: ' - '),
                          TextSpan(text: team.shortName),
                          TextSpan(text: ' - '),
                          TextSpan(text: team.tla),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (founded != null)
                Row(
                  children: [
                    SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.starOfLife)),
                    Expanded(child: Text.rich(TextSpan(text: founded.toString()))),
                  ],
                ),
              Row(
                children: [
                  SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.addressCard)),
                  Expanded(child: Text.rich(TextSpan(text: team.address))),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.house)),
                  Expanded(child: Text.rich(TextSpan(text: team.venue))),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.paintRoller)),
                  Expanded(child: Text.rich(TextSpan(text: team.clubColors))),
                ],
              ),
              if (website != null)
                InkWell(
                  onTap: () async {
                    !await launchUrl(Uri.parse(website), mode: LaunchMode.inAppBrowserView);
                  },
                  child: Row(
                    children: [
                      SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.intercom, color: Colors.blue.shade700)),
                      Expanded(child: Text.rich(TextSpan(text: team.website, style: TextStyle(color: Colors.blue.shade700)))),
                    ],
                  ),
                ),
            ].joinBy(
              item: Gap(12.w),
            ),
          ),
          ExpansionTile(
            title: Text('Coach'),
            initiallyExpanded: true,
            children: <Widget>[
              Row(
                children: [
                  SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.personBooth)),
                  Expanded(child: Text.rich(TextSpan(text: team.coach.name))),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.house)),
                  Expanded(child: Text.rich(TextSpan(text: team.coach.nationality))),
                ],
              ),
              if (coachBirth != null)
                Row(
                  children: [
                    SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.lifeRing)),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: (DateTime.now().difference(coachBirth).inDays / 365).round().toString() + ' Y.O',
                        ),
                      ),
                    ),
                  ],
                ),
              if (coachContractStart != null)
                Row(
                  children: [
                    SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.fileContract)),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: DateFormat.yMMMM().format(coachContractStart),
                          children: [
                            TextSpan(text: ' - '),
                            if (coachContractEnd != null)
                              TextSpan(
                                text: DateFormat.yMMMM().format(coachContractEnd),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ].joinBy(
              item: Gap(12.w),
            ),
          ),
          ExpansionTile(
            title: Text('Squad'),
            initiallyExpanded: false,
            children: <Widget>[
              for (var player in team.squad)
                Builder(builder: (context) {
                  var playerBirth = player.dateOfBirth;
                  return ExpansionTile(
                    title: Text(player.name),
                    initiallyExpanded: false,
                    children: <Widget>[
                      Row(
                        children: [
                          SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.personChalkboard)),
                          Expanded(child: Text.rich(TextSpan(text: player.position))),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.house)),
                          Expanded(child: Text.rich(TextSpan(text: player.nationality))),
                        ],
                      ),
                      if (playerBirth != null)
                        Row(
                          children: [
                            SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.lifeRing)),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text: (DateTime.now().difference(playerBirth).inDays / 365).round().toString() + ' Y.O',
                                ),
                              ),
                            ),
                          ],
                        ),
                    ].joinBy(
                      item: Gap(12.w),
                    ),
                  );
                }),
            ].joinBy(
              item: Gap(12.w),
            ),
          ),
          ExpansionTile(
            title: Text('Running Competitions'),
            initiallyExpanded: true,
            children: <Widget>[
              for (var runnin in team.runningCompetitions)
                CompetitionEntry(
                  code: runnin.code,
                  child: Row(
                    children: [
                      SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.trophy)),
                      Expanded(child: Text.rich(TextSpan(text: runnin.name))),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Theme.of(context).colorScheme.background.darker(20),
                        ),
                        padding: EdgeInsets.all(8.r),
                        child: SizedBox(
                          width: 50.w,
                          child: AppFileImageViewer(
                            url: runnin.emblem,
                            color: elbrem.contains(runnin.code) ? Theme.of(context).colorScheme.background.invers(true) : null,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                    ],
                  ),
                ),
            ].joinBy(
              item: Gap(12.w),
            ),
          ),
        ],
      ),
    );
  }
}

class CompetitionEntry extends StatelessWidget {
  const CompetitionEntry({
    super.key,
    this.code,
    required this.child,
  });

  final String? code;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        /* await Get.to(
          () => AppLeague(
            competition: competition,
            refreshCompetition: refreshCompetition,
          ),
        ); */
      },
      child: child,
    );
  }
}

class InteractiveCrest extends StatelessWidget {
  const InteractiveCrest({
    super.key,
    required this.crest,
    required this.tag,
  });

  final String crest;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: InteractiveViewer(
        maxScale: crest.endsWith('.svg') ? 2000 : 16,
        child: Center(
          child: Hero(
            tag: tag,
            child: AppFileImageViewer(
              url: crest,
              width: Get.width,
            ),
          ),
        ),
      ),
    );
  }
}
