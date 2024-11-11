import 'package:collection/collection.dart';
import 'package:botola_max/lib.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class TableStanding extends StatelessWidget {
  const TableStanding({super.key, required this.standing});
  final Standing standing;
  TextStyle get textStyle => const TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
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
                children: [
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
                  (index, e) {
                    return Container(
                      width: Get.width,
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(flex: 1, child: Text('${index + 1}', textAlign: TextAlign.center)),
                            Expanded(
                              flex: 2,
                              child: FittedBox(
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        TeamAvatar(team: e.team),
                                        if (index < 2)
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Icon(
                                              Icons.verified,
                                              color: Theme.of(context).primaryColor,
                                              size: 15,
                                              shadows: [Shadow(blurRadius: 5, color: Colors.white)],
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

class TeamAvatar extends StatelessWidget {
  const TeamAvatar({
    Key? key,
    required this.team,
  }) : super(key: key);
  final Team team;

  @override
  Widget build(BuildContext context) {
    const double size = 33;
    String crest = context.watch<AppState>().exchangeCrest(team.crest);
    return InkWell(
      onTap: () {
        Get.to(
          () {
            return Scaffold(
              body: Center(
                child: InteractiveViewer(
                  maxScale: 10,
                  child: AppFileImageViewer(
                    url: crest,
                    width: Get.width,
                  ),
                ),
              ),
            );
          },
        );
      },
      child: SizedBox(
        width: size,
        height: size,
        child: () {
          if (team.crest.isEmpty) {
            return const Icon(
              Icons.sports_soccer_sharp,
              size: size - 8,
              color: Colors.white,
              shadows: [Shadow(blurRadius: 5, color: Colors.white)],
            );
          } else {
            return AppFileImageViewer(
              url: crest,
              urlNetwork: team.crest,
              width: size,
              height: size,
              boxFit: BoxFit.fitWidth,
            );
          }
        }(),
      ),
    );
  }
}
