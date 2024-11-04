import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:botola_max/lib.dart';

// LEAGUE
class PhaseMatches {
  int matchday;

  bool get allFinished => matches.every((er) => er.status == AppConstants.FINISHED);
  List<Matche> matches;
  PhaseMatches({required this.matchday, required this.matches});
}

// Champions league
class MonthMatches {
  DateTime month;
  List<Matche> matches;
  bool get allFinished => matches.every((er) => er.status == AppConstants.FINISHED);
  MonthMatches({required this.month, required this.matches});
}

// Cup
class StageWithMatches {
  String stage;
  List<Matche> matches;
  bool get allFinished => matches.every((er) => er.status == AppConstants.FINISHED);
  StageWithMatches({
    required this.stage,
    required this.matches,
  });
}

// General
class GeneralStageWithMatchesData<T> {
  T title;
  List<Matche> matches;

  GeneralStageWithMatchesData({
    required this.title,
    required this.matches,
  });

  Map<String, Object?> toJson() {
    return {
      'Title': title,
      'Matches': matches.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  bool get allFinished => matches.every((er) => er.status == AppConstants.FINISHED);
}

// General
class GeneralStageWithMatches<T> {
  bool Function(T prevTitle, T currentTitle)? test;
  T Function(Matche match) getTitle;

  List<Matche> matches;

  List<GeneralStageWithMatchesData<T>> get subphases {
    var localTest = test;
    if (localTest == null) return [];
    return matches.fold(
      <GeneralStageWithMatchesData<T>>[],
      (value, current) {
        GeneralStageWithMatchesData<T>? prev = value.firstWhereOrNull((kel) => localTest(kel.title, getTitle(current)));
        if (prev != null) {
          prev.matches.add(current);
          return value;
        } else {
          return value..add(GeneralStageWithMatchesData<T>(title: getTitle(current), matches: [current]));
        }
      },
    );
  }

  GeneralStageWithMatches({
    required this.matches,
    required this.getTitle,
    this.test,
  });
  bool get allFinished => matches.every((er) => er.status == AppConstants.FINISHED);
}

// Cup, League, Champions league
class StagePhaseMatches {
  String title;
  String uuid;
  bool initiallyExpanded;
  bool isSubPhase;
  Standing? groupStanding;
  List<Matche> matches;
  List<StagePhaseMatches> subPhase;
  GlobalKey<State<StatefulWidget>> globalKey;
  StagePhaseMatches({
    required this.title,
    required this.uuid,
    required this.globalKey,
    this.groupStanding,
    this.initiallyExpanded = false,
    this.isSubPhase = true,
    this.matches = const [],
    this.subPhase = const [],
  });
  Widget view(BuildContext context, {Size? splashedSize, String? splashedId, bool? splashing}) {
    Standing? groupStand = groupStanding;
    return Stack(
      children: [
        ExpansionTile(
          key: globalKey,
          title: Text(
            title,
            style: isSubPhase
                ? null
                : const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
          ),
          initiallyExpanded: context.watch<AppState>().getEntryExpansion(uuid),
          onExpansionChanged: (value) {
            context.read<AppState>().setExpansion(uuid, value);
          },
          childrenPadding: EdgeInsets.only(left: 4),
          children: [
            ...(subPhase.isEmpty
                ? matches.map(
                    (e) => e.view(),
                  )
                : [
                    ...subPhase.map(
                      (e) => e.view(context, splashedSize: splashedSize, splashedId: splashedId, splashing: splashing),
                    ),
                    if (groupStand != null) groupStand.view(),
                  ]),
          ],
        ),
        if (splashedId == uuid && (splashing ?? false))
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Theme.of(context).primaryColor.withOpacity(0.7),
                Theme.of(context).brightness == Brightness.dark ? BlendMode.lighten : BlendMode.multiply,
              ),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        /* AnimatedContainer(
            duration: Duration(milliseconds: 300),
            color: Colors.red.withOpacity(0.3),
            child: SizedBox.fromSize(size: splashedSize),
          ), */
        /* Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.compose(
                outer: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                inner: ImageFilter.matrix(_createBlendMatrix(Colors.blue)),
              ),
              child: Container(
                color: Colors.transparent, // You can apply an optional base color here
              ),
            ),
          ), */
      ],
    );
  }

  Matrix4 createBlendMatrix(Color color) {
    // Create a matrix for the blend mode effect, using the color
    return Matrix4.identity()
      ..setEntry(3, 2, 0.001) // Perspective control
      ..translate(0.0, 0.0, 0.0);
  }
}

class StagePhase {
  String title;
  String uuid;
  bool initiallyExpanded;
  bool isSubPhase;
  Standing? groupStanding;
  List<Matche> matches;
  GlobalKey<State<StatefulWidget>> globalKey;
  StagePhase({
    required this.title,
    required this.uuid,
    required this.globalKey,
    this.groupStanding,
    this.initiallyExpanded = false,
    required this.isSubPhase,
    this.matches = const [],
  });
}

List<StagePhase> extractStagePhases(List<StagePhaseMatches> stagePhaseMatchesList) {
  List<StagePhase> stagePhases = [];

  // Helper function to convert StagePhaseMatches to StagePhase and flatten subphases
  void flatten(StagePhaseMatches spm) {
    // Convert StagePhaseMatches to StagePhase and add to the list
    stagePhases.add(
      StagePhase(
        initiallyExpanded: spm.initiallyExpanded,
        groupStanding: spm.groupStanding,
        isSubPhase: spm.isSubPhase,
        globalKey: spm.globalKey,
        matches: spm.matches,
        title: spm.title,
        uuid: spm.uuid,
      ),
    );

    // Recursively flatten subphases
    for (var subPhase in spm.subPhase) {
      flatten(subPhase);
    }
  }

  // Iterate over the top-level list and flatten each item
  for (var spm in stagePhaseMatchesList) {
    flatten(spm);
  }

  return stagePhases;
}

List<StagePhase> extractStagePhasesWithFold(List<StagePhaseMatches> stagePhaseMatchesList) {
  // Helper function to convert StagePhaseMatches to StagePhase
  List<StagePhase> flatten(StagePhaseMatches spm) {
    List<StagePhase> stagePhases = [];

    // Convert the StagePhaseMatches to StagePhase
    stagePhases.add(
      StagePhase(
        initiallyExpanded: spm.initiallyExpanded,
        groupStanding: spm.groupStanding,
        isSubPhase: spm.isSubPhase,
        globalKey: spm.globalKey,
        matches: spm.matches,
        title: spm.title,
        uuid: spm.uuid,
      ),
    );

    // Recursively flatten subphases
    stagePhases.addAll(spm.subPhase.fold<List<StagePhase>>([], (acc, subPhase) => acc..addAll(flatten(subPhase))));

    return stagePhases;
  }

  // Use fold to accumulate the result into a flat list
  return stagePhaseMatchesList.fold<List<StagePhase>>([], (acc, spm) => acc..addAll(flatten(spm)));
}
