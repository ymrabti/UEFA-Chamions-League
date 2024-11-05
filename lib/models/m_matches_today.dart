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
    return {
      BotolaHappeningEnum.resultSet.name: HappeningresultSet.toJson(),
      BotolaHappeningEnum.matches.name: matches.map<Map<String, dynamic>>((data) => data.toJson()).toList(),
    };
  }

  Map<String, Object?> toMap() {
    return {
      BotolaHappeningEnum.resultSet.name: HappeningresultSet,
      BotolaHappeningEnum.matches.name: matches,
    };
  }

  factory BotolaHappening.fromJson(Map<String, Object?> json) {
    // logg(PowerJSON(json).toText());
    return BotolaHappening(
      HappeningresultSet: HappeningResultSet.fromJson(json[BotolaHappeningEnum.resultSet.name] as Map<String, Object?>),
      matches: (json[BotolaHappeningEnum.matches.name] as List).map<Matche>((data) => Matche.fromJson(data as Map<String, Object?>)).toList(),
    );
  }

  factory BotolaHappening.fromMap(Map<String, Object?> json) {
    return BotolaHappening(
      HappeningresultSet: json[BotolaHappeningEnum.resultSet.name] as HappeningResultSet,
      matches: json[BotolaHappeningEnum.matches.name] as List<Matche>,
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
  final int? home;

  final int? away;
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
    return {
      FullTimeEnum.home.name: home,
      FullTimeEnum.away.name: away,
    };
  }

  Map<String, Object?> toMap() {
    return {
      FullTimeEnum.home.name: home.toString(),
      FullTimeEnum.away.name: away.toString(),
    };
  }

  factory MatchScoreResult.fromJson(Map<String, Object?> json) {
    return MatchScoreResult(
      home: int.tryParse('${json[FullTimeEnum.home.name]}'),
      away: int.tryParse('${json[FullTimeEnum.away.name]}'),
    );
  }

  factory MatchScoreResult.fromMap(Map<String, Object?> json) {
    return MatchScoreResult(
      home: json[FullTimeEnum.home.name] as int,
      away: json[FullTimeEnum.away.name] as int,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  String stringify() {
    return 'FullTime(home:$home, away:$away)';
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
      ..sort((a, b) {
        int fact = (desc ? -1 : 1);

        if (caseField == FullTimeEnum.home.name) {
          // unsortable

          int? akey = a.home;
          int? bkey = b.home;
          if (akey == null || bkey == null) return 0;
          return fact * (bkey - akey);
        }

        if (caseField == FullTimeEnum.away.name) {
          // unsortable

          int? akey = a.away;
          int? bkey = b.away;
          if (akey == null || bkey == null) return 0;
          return fact * (bkey - akey);
        }

        return 0;
      });
  }
}

class Season {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final int currentMatchday;
  final dynamic winner;
  Season({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.currentMatchday,
    required this.winner,
  });

  Season copyWith({
    int? id,
    DateTime? startDate,
    DateTime? endDate,
    int? currentMatchday,
    dynamic winner,
  }) {
    return Season(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currentMatchday: currentMatchday ?? this.currentMatchday,
      winner: winner ?? this.winner,
    );
  }

  Map<String, Object?> toJson() {
    return {
      SeasonEnum.id.name: id,
      SeasonEnum.startDate.name: startDate,
      SeasonEnum.endDate.name: endDate,
      SeasonEnum.currentMatchday.name: currentMatchday,
      SeasonEnum.winner.name: winner,
    };
  }

  Map<String, Object?> toMap() {
    return {
      SeasonEnum.id.name: id.toString(),
      SeasonEnum.startDate.name: startDate,
      SeasonEnum.endDate.name: endDate,
      SeasonEnum.currentMatchday.name: currentMatchday.toString(),
      SeasonEnum.winner.name: winner,
    };
  }

  factory Season.fromJson(Map<String, Object?> json) {
    return Season(
      id: int.parse('${json[SeasonEnum.id.name]}'),
      startDate: DateTime.parse('${json[SeasonEnum.startDate.name]}'),
      endDate: DateTime.parse('${json[SeasonEnum.endDate.name]}'),
      currentMatchday: int.parse('${json[SeasonEnum.currentMatchday.name]}'),
      winner: json[SeasonEnum.winner.name],
    );
  }

  factory Season.fromMap(Map<String, Object?> json) {
    return Season(
      id: json[SeasonEnum.id.name] as int,
      startDate: json[SeasonEnum.startDate.name] as DateTime,
      endDate: json[SeasonEnum.endDate.name] as DateTime,
      currentMatchday: json[SeasonEnum.currentMatchday.name] as int,
      winner: json[SeasonEnum.winner.name] as dynamic,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  String stringify() {
    return 'Season(id:$id, startDate:$startDate, endDate:$endDate, currentMatchday:$currentMatchday, winner:$winner)';
  }

  @override
  bool operator ==(Object other) {
    return other is Season &&
        other.runtimeType == runtimeType &&
        other.id == id && //
        other.startDate == startDate && //
        other.endDate == endDate && //
        other.currentMatchday == currentMatchday && //
        other.winner == winner;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      startDate,
      endDate,
      currentMatchday,
      winner,
    );
  }
}

enum SeasonEnum {
  id,
  startDate,
  endDate,
  currentMatchday,
  winner,
  none,
}

class HappeningResultSet {
  final int count;

  final String competitions;

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
    return {
      HappeningResultSetEnum.count.name: count,
      HappeningResultSetEnum.competitions.name: competitions,
      HappeningResultSetEnum.first.name: first,
      HappeningResultSetEnum.last.name: last,
      HappeningResultSetEnum.played.name: played,
    };
  }

  Map<String, Object?> toMap() {
    return {
      HappeningResultSetEnum.count.name: count.toString(),
      HappeningResultSetEnum.competitions.name: competitions,
      HappeningResultSetEnum.first.name: first,
      HappeningResultSetEnum.last.name: last,
      HappeningResultSetEnum.played.name: played.toString(),
    };
  }

  factory HappeningResultSet.fromJson(Map<String, Object?> json) {
    return HappeningResultSet(
      count: int.parse('${json[HappeningResultSetEnum.count.name]}'),
      competitions: json[HappeningResultSetEnum.competitions.name] as String,
      first: DateTime.parse('${json[HappeningResultSetEnum.first.name]}'),
      last: DateTime.parse('${json[HappeningResultSetEnum.last.name]}'),
      played: int.parse('${json[HappeningResultSetEnum.played.name]}'),
    );
  }

  factory HappeningResultSet.fromMap(Map<String, Object?> json) {
    return HappeningResultSet(
      count: json[HappeningResultSetEnum.count.name] as int,
      competitions: json[HappeningResultSetEnum.competitions.name] as String,
      first: json[HappeningResultSetEnum.first.name] as DateTime,
      last: json[HappeningResultSetEnum.last.name] as DateTime,
      played: json[HappeningResultSetEnum.played.name] as int,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  String stringify() {
    return 'HappeningResultSet(count:$count, competitions:$competitions, first:$first, last:$last, played:$played)';
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
      ..sort((a, b) {
        int fact = (desc ? -1 : 1);

        if (caseField == HappeningResultSetEnum.count.name) {
          // unsortable

          int akey = a.count;
          int bkey = b.count;

          return fact * (bkey - akey);
        }

        if (caseField == HappeningResultSetEnum.competitions.name) {
          // unsortable

          String akey = a.competitions;
          String bkey = b.competitions;

          return fact * (bkey.compareTo(akey));
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
