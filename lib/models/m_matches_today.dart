import 'package:botola_max/lib.dart';

class BotolaHappening extends IGenericAppModel {
  final HappeningResultSet HappeningresultSet;

  final List<Matche> matches;
  BotolaHappening({
    required this.HappeningresultSet,
    required this.matches,
  });

  BotolaHappening copyWith({
    HappeningResultSet? HappeningresultSet,
    List<Matche>? matches,
  }) {
    return BotolaHappening(
      HappeningresultSet: HappeningresultSet ?? this.HappeningresultSet,
      matches: matches ?? this.matches,
    );
  }

  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      BotolaHappeningEnum.resultSet.name: HappeningresultSet.toJson(),
      BotolaHappeningEnum.matches.name: matches.map<Map<String, dynamic>>((Matche data) => data.toJson()).toList(),
    };
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      BotolaHappeningEnum.resultSet.name: HappeningresultSet,
      BotolaHappeningEnum.matches.name: matches,
    };
  }

  factory BotolaHappening.fromJson(Map<String, Object?> json) {
    Map<String, Object?> resultSet = json[BotolaHappeningEnum.resultSet.name] as Map<String, Object?>;
    List<dynamic> matches = json[BotolaHappeningEnum.matches.name] as List<dynamic>;
    return BotolaHappening(
      HappeningresultSet: HappeningResultSet.fromJson(
        resultSet,
      ),
      matches: <Matche>[
        for (dynamic data in matches) Matche.fromJson(data as Map<String, Object?>),
      ],
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is BotolaHappening &&
        other.runtimeType == runtimeType &&
        other.HappeningresultSet == HappeningresultSet && //
        other.matches == matches;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      HappeningresultSet,
      matches,
    );
  }
}

enum BotolaHappeningEnum {
  filters,
  resultSet,
  matches,
  none,
}

enum HalfTimeEnum {
  home,
  away,
  none,
}

class MatchScoreResult {
  final int home;

  final int away;
  MatchScoreResult({
    required this.home,
    required this.away,
  });

  MatchScoreResult copyWith({
    int? home,
    int? away,
  }) {
    return MatchScoreResult(
      home: home ?? this.home,
      away: away ?? this.away,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      FullTimeEnum.home.name: home,
      FullTimeEnum.away.name: away,
    };
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      FullTimeEnum.home.name: home.toString(),
      FullTimeEnum.away.name: away.toString(),
    };
  }

  factory MatchScoreResult.fromJson(Map<String, Object?> json) {
    return MatchScoreResult(
      home: int.tryParse('${json[FullTimeEnum.home.name]}') ?? 0,
      away: int.tryParse('${json[FullTimeEnum.away.name]}') ?? 0,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is MatchScoreResult &&
        other.runtimeType == runtimeType &&
        other.home == home && //
        other.away == away;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      home,
      away,
    );
  }
}

enum FullTimeEnum {
  home,
  away,
  none,
}

extension FullTimeSort on List<MatchScoreResult> {
  List<MatchScoreResult> sorty(String caseField, {bool desc = false}) {
    return this
      ..sort((MatchScoreResult a, MatchScoreResult b) {
        int fact = (desc ? -1 : 1);

        if (caseField == FullTimeEnum.home.name) {
          // unsortable

          int? akey = a.home;
          int? bkey = b.home;
          return fact * (bkey - akey);
        }

        if (caseField == FullTimeEnum.away.name) {
          // unsortable

          int? akey = a.away;
          int? bkey = b.away;
          return fact * (bkey - akey);
        }

        return 0;
      });
  }
}

class HappeningResultSet {
  final int count;

  final String? competitions;

  final DateTime first;

  final DateTime last;

  final int played;
  HappeningResultSet({
    required this.count,
    required this.competitions,
    required this.first,
    required this.last,
    required this.played,
  });

  HappeningResultSet copyWith({
    int? count,
    String? competitions,
    DateTime? first,
    DateTime? last,
    int? played,
  }) {
    return HappeningResultSet(
      count: count ?? this.count,
      competitions: competitions ?? this.competitions,
      first: first ?? this.first,
      last: last ?? this.last,
      played: played ?? this.played,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      HappeningResultSetEnum.count.name: count,
      HappeningResultSetEnum.competitions.name: competitions,
      HappeningResultSetEnum.first.name: first,
      HappeningResultSetEnum.last.name: last,
      HappeningResultSetEnum.played.name: played,
    };
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      HappeningResultSetEnum.count.name: count.toString(),
      HappeningResultSetEnum.competitions.name: competitions,
      HappeningResultSetEnum.first.name: first,
      HappeningResultSetEnum.last.name: last,
      HappeningResultSetEnum.played.name: played.toString(),
    };
  }

  factory HappeningResultSet.fromJson(Map<String, Object?> json) {
    int counter = int.tryParse('${json[HappeningResultSetEnum.count.name]}') ?? 0;
    return HappeningResultSet(
      count: counter,
      competitions: json[HappeningResultSetEnum.competitions.name] as String?,
      first: counter == 0 ? DateTime.now() : DateTime.parse('${json[HappeningResultSetEnum.first.name]}').add(DateTime.now().timeZoneOffset),
      last: counter == 0 ? DateTime.now() : DateTime.parse('${json[HappeningResultSetEnum.last.name]}').add(DateTime.now().timeZoneOffset),
      played: counter == 0 ? 0 : int.parse('${json[HappeningResultSetEnum.played.name]}'),
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is HappeningResultSet &&
        other.runtimeType == runtimeType &&
        other.count == count && //
        other.competitions == competitions && //
        other.first == first && //
        other.last == last && //
        other.played == played;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      count,
      competitions,
      first,
      last,
      played,
    );
  }
}

enum HappeningResultSetEnum {
  count,
  competitions,
  first,
  last,
  played,
  none,
}

extension HappeningResultSetSort on List<HappeningResultSet> {
  List<HappeningResultSet> sorty(String caseField, {bool desc = false}) {
    return this
      ..sort((HappeningResultSet a, HappeningResultSet b) {
        int fact = (desc ? -1 : 1);

        if (caseField == HappeningResultSetEnum.count.name) {
          // unsortable

          int akey = a.count;
          int bkey = b.count;

          return fact * (bkey - akey);
        }

        if (caseField == HappeningResultSetEnum.first.name) {
          // unsortable

          DateTime akey = a.first;
          DateTime bkey = b.first;

          return fact * bkey.compareTo(akey);
        }

        if (caseField == HappeningResultSetEnum.last.name) {
          // unsortable

          DateTime akey = a.last;
          DateTime bkey = b.last;

          return fact * bkey.compareTo(akey);
        }

        if (caseField == HappeningResultSetEnum.played.name) {
          // unsortable

          int akey = a.played;
          int bkey = b.played;

          return fact * (bkey - akey);
        }

        return 0;
      });
  }
}
