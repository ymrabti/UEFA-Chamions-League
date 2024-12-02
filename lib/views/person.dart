import 'package:botola_max/lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class BotolaPerson extends StatelessWidget {
  const BotolaPerson({super.key, required this.player});
  final BotolaXPerson player;

  @override
  Widget build(BuildContext context) {
    DateTime? startContact = player.currentTeam.contract.start;
    DateTime? endContact = player.currentTeam.contract.until;
    int shirtNumber = player.shirtNumber;
    return ScaffoldBuilder(
      appBar: AppBar(
        title: Text(player.name),
      ),
      body: ListView(
        children: <Widget>[
          PlayerPosition(position: '${player.position} (${player.section})'),
          BotolaNationality(nationality: player.nationality),
          BotolaPersonAge(birth: player.dateOfBirth),
          if (startContact != null) BotolaContract(contractStart: startContact, contractEnd: endContact),
          PlayerShirtNumber(shirtNumber: shirtNumber),
          Row(
            children: [
              SizedBox(width: 50.w, child: Icon(FontAwesomeIcons.peopleGroup)),
              Expanded(
                child: TeamDetailsEntry(
                  id: player.currentTeam.id,
                  tag: player.currentTeam.crest,
                  child: BootolaLinq(text: player.currentTeam.shortName),
                ),
              ),
            ],
          ),
        ].joinBy(
          item: Gap(12.w),
        ),
      ),
    );
  }
}

class PlayerShirtNumber extends StatelessWidget {
  const PlayerShirtNumber({
    super.key,
    required this.shirtNumber,
  });

  final int shirtNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 50.w, child: Icon(CupertinoIcons.number_circle)),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: 'Shirt Number: ',
              children: [
                TextSpan(text: shirtNumber.toString()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
