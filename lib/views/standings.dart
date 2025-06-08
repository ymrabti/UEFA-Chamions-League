import 'package:collection/collection.dart';
import 'package:botola_max/lib.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TableStanding extends StatelessWidget {
  const TableStanding({super.key, required this.standing});
  final Standing standing;
  TextStyle get textStyle => const TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            width: Get.width,
            alignment: Alignment.center,
            /* child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                standing.group,
                style: textStyle,
              ),
            ), */
          ),
          Container(
            width: Get.width,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(flex: 1, child: Text('#', style: textStyle, textAlign: TextAlign.center)),
                  Expanded(flex: 2, child: Text('Team', style: textStyle, textAlign: TextAlign.center)),
                  Expanded(flex: 1, child: Text('P', style: textStyle, textAlign: TextAlign.center)),
                  Expanded(flex: 1, child: Text('W', style: textStyle, textAlign: TextAlign.center)),
                  Expanded(flex: 1, child: Text('L', style: textStyle, textAlign: TextAlign.center)),
                  Expanded(flex: 1, child: Text('D', style: textStyle, textAlign: TextAlign.center)),
                  Expanded(flex: 1, child: Text('Pts', style: textStyle, textAlign: TextAlign.center)),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.skin(Theme.of(context).brightness == Brightness.dark, 40),
            ),
            width: Get.width,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: standing.table.mapIndexed(
                  (int index, Tabla e) {
                    return Container(
                      width: Get.width,
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(flex: 1, child: Text('${index + 1}', textAlign: TextAlign.center)),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      TeamAvatar(
                                        team: e.team,
                                        tag: e.team.crest,
                                      ),
                                      if (index < 2)
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Icon(
                                            Icons.verified,
                                            color: Theme.of(context).primaryColor,
                                            size: 15,
                                            shadows: <Shadow>[Shadow(blurRadius: 5, color: Colors.white)],
                                          ),
                                        ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(e.team.tla, textAlign: TextAlign.center),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(flex: 1, child: Text('${e.playedGames}', textAlign: TextAlign.center)),
                            Expanded(flex: 1, child: Text('${e.won}', textAlign: TextAlign.center)),
                            Expanded(flex: 1, child: Text('${e.lost}', textAlign: TextAlign.center)),
                            Expanded(flex: 1, child: Text('${e.draw}', textAlign: TextAlign.center)),
                            Expanded(flex: 1, child: Text('${e.points}', textAlign: TextAlign.center)),
                          ],
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
