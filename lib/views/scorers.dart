import 'package:collection/collection.dart';
import 'package:botola_max/lib.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class CompetitionScorersPage extends StatelessWidget {
  const CompetitionScorersPage({super.key, required this.scorers});
  final BotolaScorers scorers;
  @override
  Widget build(BuildContext context) {
    final ascensorWidget = context.findAncestorWidgetOfExactType<HomeScreen>();

    if (ascensorWidget != null) {
      // You can now access properties of ascensorWidget
      logg("Found AscensorType widget with properties: ${ascensorWidget.competitions.competitions.length}");
    } else {
      logg("AscensorType widget not found in the widget tree.");
    }
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppFileImageViewer(
            url: context.watch<AppState>().exchangeCrest(scorers.competition.emblem),
            width: 40,
            color: elbrem.contains(scorers.competition.code) ? Theme.of(context).colorScheme.background.invers(true) : null,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(scorers.competition.name + ' scorers'),
        ),
      ),
      body: ListView(
        children: scorers.scorers.mapIndexed(
          (i, e) {
            int? penalties = e.penalties;
            int? assists = e.assists;
            int? shirtNumber = e.player.shirtNumber;
            DateTime? dateOfBirth2 = e.player.dateOfBirth;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                title: Text(
                  '${e.player.name}${shirtNumber != null ? ' (N° $shirtNumber)' : ''}',
                ),
                maintainState: true,
                subtitle: Text(
                  'Goals: ${e.goals}',
                  style: TextStyle(fontSize: 10),
                ),
                leading: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('#${i + 1}'),
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        AppFileImageViewer(
                          url: context.watch<AppState>().exchangeCrest(e.team.crest),
                          width: 36,
                          height: 36,
                        ),
                        Gap(8),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3.0),
                                child: Text.rich(
                                  TextSpan(
                                    text: 'Position',
                                    children: [
                                      TextSpan(text: ': '),
                                      TextSpan(
                                        text: e.player.section,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor.invers(
                                                Theme.of(context).brightness == Brightness.dark,
                                              ),
                                        ),
                                      ),
                                      TextSpan(text: ' for '),
                                      TextSpan(
                                        text: e.team.name,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor.invers(
                                                Theme.of(context).brightness == Brightness.dark,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3.0),
                                child: Text.rich(
                                  TextSpan(
                                    text: 'Home',
                                    children: [
                                      TextSpan(text: ': '),
                                      TextSpan(
                                        text: e.player.nationality,
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor.invers(
                                                  Theme.of(context).brightness == Brightness.dark,
                                                )),
                                      ),
                                      TextSpan(text: ' '),
                                      if (dateOfBirth2 != null) TextSpan(text: '(${DateTime.now().difference(dateOfBirth2).inDays ~/ 365} yo)'),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(8),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Played matches ${e.playedMatches}',
                              style: TextStyle(fontSize: 10),
                            ),
                            if (penalties != null)
                              Text(
                                'Penalties $penalties',
                                style: TextStyle(fontSize: 10),
                              ),
                            if (assists != null)
                              Text(
                                'Assists $assists',
                                style: TextStyle(fontSize: 10),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
