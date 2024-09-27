import 'package:collection/collection.dart';
import 'package:uefa_champions_league/lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';

import 'package:path/path.dart';

class TableStanding extends StatelessWidget {
  const TableStanding({super.key, required this.standing});
  final Standings standing;
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
              color: primaryColor.shade700,
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
                  Expanded(flex: 2, child: Text('الفريق', style: textStyle, textAlign: TextAlign.center)),
                  Expanded(flex: 1, child: Text('ل', style: textStyle, textAlign: TextAlign.center)),
                  Expanded(flex: 1, child: Text('ر', style: textStyle, textAlign: TextAlign.center)),
                  Expanded(flex: 1, child: Text('خ', style: textStyle, textAlign: TextAlign.center)),
                  Expanded(flex: 1, child: Text('ت', style: textStyle, textAlign: TextAlign.center)),
                  Expanded(flex: 1, child: Text('نقاط', style: textStyle, textAlign: TextAlign.center)),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: primaryColor.shade50),
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
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      TeamAvatar(team: e.team),
                                      if (index < 2)
                                        const Align(
                                          alignment: Alignment.bottomRight,
                                          child: Icon(
                                            Icons.verified,
                                            color: primaryColor,
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
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        clipBehavior: Clip.hardEdge,
        child: team.crest.isEmpty
            ? const Icon(
                Icons.sports_soccer_sharp,
                size: size - 8,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 5, color: Colors.white)],
              )
            : extension(team.crest) == '.svg'
                ? FutureBuilder(
                    future: svgNetwork(team.crest),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? SvgPicture.string(
                              snapshot.data!,
                              width: size,
                              height: size,
                              fit: BoxFit.cover,
                            )
                          : const Center(child: CupertinoActivityIndicator());
                    },
                  )
                : Image.network(
                    team.crest,
                    width: size,
                    fit: BoxFit.fitHeight,
                    height: size,
                  ),
      ),
    );
  }
}

Future<String?> svgNetwork(String url) async {
  var request = Request('GET', Uri.parse(url));

  StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var svgtext = await response.stream.bytesToString();
    var regExp1 = RegExp(r"<use (.+)\/>");
    var regExp2 = RegExp(r'xlink:href="#[a-zA-Z]{1,}"');
    return svgtext.replaceAll(regExp1, '').replaceAll(regExp2, '');
  } else {
    return null;
  }
}
