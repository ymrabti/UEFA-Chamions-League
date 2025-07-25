import 'package:botola_max/lib.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class FallBackMap {
  Map<String, String> map;
  Map<String, bool> availableIds;
  FallBackMap({
    required this.map,
    required this.availableIds,
  });
}

/* typedef FallBackAndMap = ({
  Map<String, String> map,
  Map<String, bool> availableIds,
}); */

class CompetitonIdData {
  String id;
  DataCompetition data;
  CompetitonIdData({
    required this.data,
    required this.id,
  });
}

// LEAGUE
class PhaseMatches {
  int matchday;

  bool get allFinished => matches.every((Matche er) => er.status == AppConstants.FINISHED);
  List<Matche> matches;
  PhaseMatches({required this.matchday, required this.matches});
}

// Champions league
class MonthMatches {
  DateTime month;
  List<Matche> matches;
  bool get allFinished => matches.every((Matche er) => er.status == AppConstants.FINISHED);
  MonthMatches({required this.month, required this.matches});
}

// Cup
class StageWithMatches {
  String stage;
  List<Matche> matches;
  bool get allFinished => matches.every((Matche er) => er.status == AppConstants.FINISHED);
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
    return <String, Object?>{
      'Title': title,
      'Matches': matches.map((Matche e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  bool get allFinished => matches.every((Matche er) => er.status == AppConstants.FINISHED);
}

// General
class GeneralStageWithMatches<T> {
  bool Function(T prevTitle, T currentTitle)? test;
  T Function(Matche match) getTitle;

  List<Matche> matches;

  List<GeneralStageWithMatchesData<T>> get subphases {
    bool Function(T prevTitle, T currentTitle)? localTest = test;
    if (localTest == null) return <GeneralStageWithMatchesData<T>>[];
    return matches.fold(
      <GeneralStageWithMatchesData<T>>[],
      (List<GeneralStageWithMatchesData<T>> value, Matche current) {
        GeneralStageWithMatchesData<T>? prev = value.firstWhereOrNull((GeneralStageWithMatchesData<T> kel) => localTest(kel.title, getTitle(current)));
        if (prev != null) {
          prev.matches.add(current);
          return value;
        } else {
          return value..add(GeneralStageWithMatchesData<T>(title: getTitle(current), matches: <Matche>[current]));
        }
      },
    );
  }

  GeneralStageWithMatches({
    required this.matches,
    required this.getTitle,
    this.test,
  });
  bool get allFinished => matches.every((Matche er) => er.status == AppConstants.FINISHED);
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
    this.matches = const <Matche>[],
    this.subPhase = const <StagePhaseMatches>[],
  });
  Widget view(BuildContext context, {Size? splashedSize, String? splashedId, bool? splashing}) {
    Standing? groupStand = groupStanding;
    return Stack(
      children: <Widget>[
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
          onExpansionChanged: (bool value) {
            context.read<AppState>().setExpansion(uuid, value);
          },
          childrenPadding: EdgeInsets.only(left: 4),
          children: <Widget>[
            ...(subPhase.isEmpty
                ? matches.map(
                    (Matche match) => match.view,
                  )
                : <Widget>[
                    ...subPhase.map(
                      (StagePhaseMatches e) => e.view(context, splashedSize: splashedSize, splashedId: splashedId, splashing: splashing),
                    ),
                    if (groupStand != null) groupStand.view(),
                  ]),
          ],
        ),
        if (splashedId == uuid && (splashing ?? false))
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Theme.of(context).primaryColor.withValues(alpha: 0.7),
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
    this.matches = const <Matche>[],
  });
}
