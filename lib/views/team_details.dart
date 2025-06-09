import 'package:botola_max/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RoundedTeam extends StatelessWidget {
  const RoundedTeam({
    Key? key,
    required this.team,
    required this.tag,
    this.left = true,
  }) : super(key: key);

  final GoalRankingPerTeam team;
  final String tag;
  final bool left;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
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
            children: <Widget>[
              TeamAvatar(
                team: team.team,
                tag: '${left ? 'LEFT' : 'RIGHT'}${team.team.name}$tag',
              ),
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

class TeamAvatar extends StatelessWidget {
  const TeamAvatar({
    Key? key,
    required this.tag,
    required this.team,
  }) : super(key: key);
  final String tag;
  final Team team;

  @override
  Widget build(BuildContext context) {
    const double size = 33;
    String crest = (team.crest);
    return TeamDetailsEntry(
      id: team.id,
      tag: tag,
      child: Hero(
        tag: tag,
        child: SizedBox(
          width: size,
          height: size,
          child: () {
            if (team.crest.isEmpty) {
              return const Icon(
                Icons.sports_soccer_sharp,
                size: size - 8,
                color: Colors.white,
                shadows: <Shadow>[Shadow(blurRadius: 5, color: Colors.white)],
              );
            } else {
              return AppFileImageViewer(
                url: crest,
                width: size,
                height: size,
                boxFit: BoxFit.fitWidth,
              );
            }
          }(),
        ),
      ),
    );
  }
}

class TeamDetailsEntry extends StatelessWidget {
  const TeamDetailsEntry({
    super.key,
    required this.child,
    required this.tag,
    required this.id,
  });
  final Widget child;
  final String tag;
  final int id;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        context.read<AppState>().setLoading(true);
        Teams? teams = await AppLogic.getTeam(id);
        if (!context.mounted) return;
        context.read<AppState>().setLoading(false);
        if (teams == null) return;
        Get.to(
          () {
            return TeamDetails(team: teams, tag: tag);
          },
        );
      },
      child: child,
    );
  }
}

class PersonEntry extends StatelessWidget {
  const PersonEntry({
    super.key,
    required this.child,
    required this.id,
  });
  final Widget child;
  final int id;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        context.read<AppState>().setLoading(true);
        BotolaXPerson? person = await AppLogic.person(id);
        if (person == null) return;
        if (!context.mounted) return;
        context.read<AppState>().setLoading(false);
        await Get.to(() => BotolaPerson(player: person));
      },
      child: child,
    );
  }
}

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
    int? founded = team.founded;
    DateTime? coachBirth = team.coach.dateOfBirth;
    DateTime? coachContractStart = team.coach.contract?.start;
    DateTime? coachContractEnd = team.coach.contract?.until;
    String? nationality = team.coach.nationality;
    // int? coachID = team.coach.id;
    return ScaffoldBuilder(
      appBar: AppBar(
        leading: InkWell(
          onTap: () async {
            await Get.to<void>(
              () => ScaffoldBuilder(
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
        children: <Widget>[
          ExpansionTile(
            title: Text('Infos'),
            initiallyExpanded: true,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(width: 50.w, child: Icon(Icons.pin_drop_rounded)),
                  Expanded(child: Text.rich(TextSpan(text: team.area.name))),
                  InkWell(
                    onTap: () async {
                      String? flag = team.area.flag;
                      if (flag == null) return;
                      await Get.to<void>(
                        () {
                          return ScaffoldBuilder(
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
                children: <Widget>[
                  SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.idBadge)),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: team.name,
                        children: <InlineSpan>[
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
                  children: <Widget>[
                    SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.starOfLife)),
                    Expanded(child: Text.rich(TextSpan(text: founded.toString()))),
                  ],
                ),
              Row(
                children: <Widget>[
                  SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.addressCard)),
                  Expanded(child: Text.rich(TextSpan(text: team.address))),
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.house)),
                  Expanded(child: Text.rich(TextSpan(text: team.venue))),
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.paintRoller)),
                  Expanded(child: Text.rich(TextSpan(text: team.clubColors))),
                ],
              ),
              if (website != null) BotolaWebsite(website: website),
            ].joinBy(
              item: Gap(12.w),
            ),
          ),
          ExpansionTile(
            title: Text('Coach'),
            initiallyExpanded: true,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.personBooth)),
                  Expanded(child: Text.rich(TextSpan(text: team.coach.name))),
                ],
              ),
              BotolaNationality(nationality: nationality),
              if (coachBirth != null) BotolaPersonAge(birth: coachBirth),
              if (coachContractStart != null)
                BotolaContract(
                  contractStart: coachContractStart,
                  contractEnd: coachContractEnd,
                ),
              /* if (coachID != null)
                PersonEntry(
                  id: coachID,
                  child: BootolaLinq(text: 'Infos'),
                ), */
            ].joinBy(item: Gap(12.w)),
          ),
          ExpansionTile(
            title: Text('Squad'),
            initiallyExpanded: false,
            children: <Widget>[
              for (Squad player in team.squad) TeamSquadMember(player: player),
            ].joinBy(item: Gap(12.w)),
          ),
          ExpansionTile(
            title: Text('Running Competitions'),
            initiallyExpanded: true,
            children: <Widget>[
              for (RunningCompetitions runnin in team.runningCompetitions) TeamRunningCompetition(runnin: runnin),
            ].joinBy(item: Gap(12.w)),
          ),
        ],
      ),
    );
  }
}

class TeamRunningCompetition extends StatelessWidget {
  const TeamRunningCompetition({
    super.key,
    required this.runnin,
  });

  final RunningCompetitions runnin;

  @override
  Widget build(BuildContext context) {
    return CompetitionEntry(
      code: runnin.code,
      type: runnin.type,
      child: Row(
        children: <Widget>[
          SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.trophy)),
          Expanded(child: Text.rich(TextSpan(text: runnin.name))),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Theme.of(context).colorScheme.surface.darker(20),
            ),
            padding: EdgeInsets.all(8.r),
            child: SizedBox(
              width: 50.w,
              child: AppFileImageViewer(
                url: runnin.emblem,
                color: elbrem.contains(runnin.code) ? Theme.of(context).colorScheme.surface.invers(true) : null,
              ),
            ),
          ),
          SizedBox(width: 12.w),
        ],
      ),
    );
  }
}

class TeamSquadMember extends StatelessWidget {
  const TeamSquadMember({
    super.key,
    required this.player,
  });

  final Squad player;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      DateTime? playerBirth = player.dateOfBirth;
      String? position = player.position;
      return ExpansionTile(
        title: Text(player.name),
        initiallyExpanded: false,
        children: <Widget>[
          PersonEntry(id: player.id, child: BootolaLinq(text: player.name)),
          PlayerPosition(position: position),
          BotolaNationality(nationality: player.nationality),
          if (playerBirth != null) BotolaPersonAge(birth: playerBirth),
        ].joinBy(item: Gap(12.w)),
      );
    });
  }
}

class BootolaLinq extends StatelessWidget {
  const BootolaLinq({super.key, required this.text, this.onTap});
  final String text;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 50.w,
            child: Icon(
              // ignore: deprecated_member_use
              FontAwesomeIcons.externalLink,
              color: Colors.blue.shade700,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.blue.shade700),
            ),
          ),
        ],
      ),
    );
  }
}
