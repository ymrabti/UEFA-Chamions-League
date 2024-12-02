import "package:botola_max/lib.dart";

/*    
{
    "filters": {
        "limit": "5",
        "permission": "TIER_ONE"
    },
    "resultSet": {
        "count": 2,
        "competitions": "PL",
        "first": "2022-08-06",
        "last": "2023-03-18"
    },
    "aggregates": {
        "numberOfMatches": 5,
        "totalGoals": 21,
        "homeTeam": {
            "id": 73,
            "name": "Tottenham Hotspur FC",
            "wins": 0,
            "draws": 2,
            "losses": 0
        },
        "awayTeam": {
            "id": 340,
            "name": "Southampton FC",
            "wins": 0,
            "draws": 2,
            "losses": 0
        }
    },
    "matches": [
        {
            "area": {
                "id": 2072,
                "name": "England",
                "code": "ENG",
                "flag": "https://crests.football-data.org/770.svg"
            },
            "competition": {
                "id": 2021,
                "name": "Premier League",
                "code": "PL",
                "type": "LEAGUE",
                "emblem": "https://crests.football-data.org/PL.png"
            },
            "season": {
                "id": 1490,
                "startDate": "2022-08-05",
                "endDate": "2023-05-28",
                "currentMatchday": 38,
                "winner": {
                    "id": 65,
                    "name": "Manchester City FC",
                    "shortName": "Man City",
                    "tla": "MCI",
                    "crest": "https://crests.football-data.org/65.png",
                    "address": "SportCity Manchester M11 3FF",
                    "website": "https://www.mancity.com",
                    "founded": 1880,
                    "clubColors": "Sky Blue / White",
                    "venue": "Etihad Stadium",
                    "lastUpdated": "2022-02-10T19:48:37Z"
                }
            },
            "id": 416106,
            "utcDate": "2023-03-18T15:00:00Z",
            "status": "FINISHED",
            "matchday": 28,
            "stage": "REGULAR_SEASON",
            "group": null,
            "lastUpdated": "2023-04-30T11:48:49Z",
            "homeTeam": {
                "id": 340,
                "name": "Southampton FC",
                "shortName": "Southampton",
                "tla": "SOU",
                "crest": "https://crests.football-data.org/340.png"
            },
            "awayTeam": {
                "id": 73,
                "name": "Tottenham Hotspur FC",
                "shortName": "Tottenham",
                "tla": "TOT",
                "crest": "https://crests.football-data.org/73.png"
            },
            "score": {
                "winner": "DRAW",
                "duration": "REGULAR",
                "fullTime": {
                    "home": 3,
                    "away": 3
                },
                "halfTime": {
                    "home": 0,
                    "away": 1
                }
            },
            "odds": {
                "msg": "Activate Odds-Package in User-Panel to retrieve odds."
            },
            "referees": [
                {
                    "id": 11430,
                    "name": "Simon Hooper",
                    "type": "REFEREE",
                    "nationality": "England"
                }
            ]
        },
        {
            "area": {
                "id": 2072,
                "name": "England",
                "code": "ENG",
                "flag": "https://crests.football-data.org/770.svg"
            },
            "competition": {
                "id": 2021,
                "name": "Premier League",
                "code": "PL",
                "type": "LEAGUE",
                "emblem": "https://crests.football-data.org/PL.png"
            },
            "season": {
                "id": 1490,
                "startDate": "2022-08-05",
                "endDate": "2023-05-28",
                "currentMatchday": 38,
                "winner": {
                    "id": 65,
                    "name": "Manchester City FC",
                    "shortName": "Man City",
                    "tla": "MCI",
                    "crest": "https://crests.football-data.org/65.png",
                    "address": "SportCity Manchester M11 3FF",
                    "website": "https://www.mancity.com",
                    "founded": 1880,
                    "clubColors": "Sky Blue / White",
                    "venue": "Etihad Stadium",
                    "lastUpdated": "2022-02-10T19:48:37Z"
                }
            },
            "id": 416378,
            "utcDate": "2022-08-06T14:00:00Z",
            "status": "FINISHED",
            "matchday": 1,
            "stage": "REGULAR_SEASON",
            "group": null,
            "lastUpdated": "2023-04-30T11:48:54Z",
            "homeTeam": {
                "id": 73,
                "name": "Tottenham Hotspur FC",
                "shortName": "Tottenham",
                "tla": "TOT",
                "crest": "https://crests.football-data.org/73.png"
            },
            "awayTeam": {
                "id": 340,
                "name": "Southampton FC",
                "shortName": "Southampton",
                "tla": "SOU",
                "crest": "https://crests.football-data.org/340.png"
            },
            "score": {
                "winner": "HOME_TEAM",
                "duration": "REGULAR",
                "fullTime": {
                    "home": 4,
                    "away": 1
                },
                "halfTime": {
                    "home": 2,
                    "away": 1
                }
            },
            "odds": {
                "msg": "Activate Odds-Package in User-Panel to retrieve odds."
            },
            "referees": [
                {
                    "id": 11610,
                    "name": "Andre Marriner",
                    "type": "REFEREE",
                    "nationality": "England"
                }
            ]
        }
    ]
}
*/

class MatchHead2HeadModel extends IGenericAppModel {
  final H2HResultSet resultSet;

  final Aggregates aggregates;

  final List<Matche> matches;
  MatchHead2HeadModel({
    required this.resultSet,
    required this.aggregates,
    required this.matches,
  });

  MatchHead2HeadModel copyWith({
    H2HResultSet? resultSet,
    Aggregates? aggregates,
    List<Matche>? matches,
  }) {
    return MatchHead2HeadModel(
      resultSet: resultSet ?? this.resultSet,
      aggregates: aggregates ?? this.aggregates,
      matches: matches ?? this.matches,
    );
  }

  @override
  Map<String, Object?> toJson() {
    return {
      MatchHead2HeadModelEnum.resultSet.name: resultSet.toJson(),
      MatchHead2HeadModelEnum.aggregates.name: aggregates.toJson(),
      MatchHead2HeadModelEnum.matches.name: matches.map<Map<String, dynamic>>((data) => data.toJson()).toList(),
    };
  }

  factory MatchHead2HeadModel.fromJson(Map<String, Object?> json) {
    return MatchHead2HeadModel(
      resultSet: H2HResultSet.fromJson(json[MatchHead2HeadModelEnum.resultSet.name] as Map<String, Object?>),
      aggregates: Aggregates.fromJson(json[MatchHead2HeadModelEnum.aggregates.name] as Map<String, Object?>),
      matches: (json[MatchHead2HeadModelEnum.matches.name] as List).map<Matche>((data) => Matche.fromJson(data as Map<String, Object?>)).toList(),
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is MatchHead2HeadModel &&
        other.runtimeType == runtimeType &&
        other.resultSet == resultSet && //
        other.aggregates == aggregates && //
        other.matches == matches;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      resultSet,
      aggregates,
      matches,
    );
  }
}

enum MatchHead2HeadModelEnum {
  filters,
  resultSet,
  aggregates,
  matches,
  none,
}

class Season {
  final int id;

  final DateTime startDate;

  final DateTime endDate;

  final int? currentMatchday;

  final Winner? winner;
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
    Winner? winner,
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
      if (winner != null) SeasonEnum.winner.name: winner?.toJson(),
    };
  }

  factory Season.fromJson(Map<String, Object?> json) {
    Map<String, Object?>? winner = json[SeasonEnum.winner.name] as Map<String, Object?>?;
    return Season(
      id: int.parse('${json[SeasonEnum.id.name]}'),
      startDate: DateTime.parse('${json[SeasonEnum.startDate.name]}').add(DateTime.now().timeZoneOffset),
      endDate: DateTime.parse('${json[SeasonEnum.endDate.name]}').add(DateTime.now().timeZoneOffset),
      currentMatchday: int.parse('${json[SeasonEnum.currentMatchday.name]}'),
      winner: (winner != null) ? Winner.fromJson(winner) : null,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
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

class Winner {
  final int id;

  final String name;

  final String shortName;

  final String tla;

  final String crest;

  final String address;

  final String website;

  final int founded;

  final String? clubColors;

  final String? venue;

  final DateTime lastUpdated;
  Winner({
    required this.id,
    required this.name,
    required this.shortName,
    required this.tla,
    required this.crest,
    required this.address,
    required this.website,
    required this.founded,
    required this.clubColors,
    required this.venue,
    required this.lastUpdated,
  });

  Winner copyWith({
    int? id,
    String? name,
    String? shortName,
    String? tla,
    String? crest,
    String? address,
    String? website,
    int? founded,
    String? clubColors,
    String? venue,
    DateTime? lastUpdated,
  }) {
    return Winner(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      tla: tla ?? this.tla,
      crest: crest ?? this.crest,
      address: address ?? this.address,
      website: website ?? this.website,
      founded: founded ?? this.founded,
      clubColors: clubColors ?? this.clubColors,
      venue: venue ?? this.venue,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, Object?> toJson() {
    return {
      WinnerEnum.id.name: id,
      WinnerEnum.name.name: name,
      WinnerEnum.shortName.name: shortName,
      WinnerEnum.tla.name: tla,
      WinnerEnum.crest.name: crest,
      WinnerEnum.address.name: address,
      WinnerEnum.website.name: website,
      WinnerEnum.founded.name: founded,
      WinnerEnum.clubColors.name: clubColors,
      WinnerEnum.venue.name: venue,
      WinnerEnum.lastUpdated.name: lastUpdated,
    };
  }

  factory Winner.fromJson(Map<String, Object?> json) {
    return Winner(
      id: int.parse('${json[WinnerEnum.id.name]}'),
      name: json[WinnerEnum.name.name] as String,
      shortName: json[WinnerEnum.shortName.name] as String,
      tla: json[WinnerEnum.tla.name] as String,
      crest: json[WinnerEnum.crest.name] as String,
      address: json[WinnerEnum.address.name] as String,
      website: json[WinnerEnum.website.name] as String,
      founded: int.parse('${json[WinnerEnum.founded.name]}'),
      clubColors: json[WinnerEnum.clubColors.name] as String?,
      venue: json[WinnerEnum.venue.name] as String?,
      lastUpdated: DateTime.parse('${json[WinnerEnum.lastUpdated.name]}').add(DateTime.now().timeZoneOffset),
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is Winner &&
        other.runtimeType == runtimeType &&
        other.id == id && //
        other.name == name && //
        other.shortName == shortName && //
        other.tla == tla && //
        other.crest == crest && //
        other.address == address && //
        other.website == website && //
        other.founded == founded && //
        other.clubColors == clubColors && //
        other.venue == venue && //
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      name,
      shortName,
      tla,
      crest,
      address,
      website,
      founded,
      clubColors,
      venue,
      lastUpdated,
    );
  }
}

enum WinnerEnum {
  id,
  name,
  shortName,
  tla,
  crest,
  address,
  website,
  founded,
  clubColors,
  venue,
  lastUpdated,
  none,
}

class Aggregates {
  final int numberOfMatches;

  final int totalGoals;

  final Team homeTeam;

  final Team awayTeam;
  Aggregates({
    required this.numberOfMatches,
    required this.totalGoals,
    required this.homeTeam,
    required this.awayTeam,
  });

  Aggregates copyWith({
    int? numberOfMatches,
    int? totalGoals,
    Team? homeTeam,
    Team? awayTeam,
  }) {
    return Aggregates(
      numberOfMatches: numberOfMatches ?? this.numberOfMatches,
      totalGoals: totalGoals ?? this.totalGoals,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
    );
  }

  Map<String, Object?> toJson() {
    return {
      AggregatesEnum.numberOfMatches.name: numberOfMatches,
      AggregatesEnum.totalGoals.name: totalGoals,
      AggregatesEnum.homeTeam.name: homeTeam.toJson(),
      AggregatesEnum.awayTeam.name: awayTeam.toJson(),
    };
  }

  factory Aggregates.fromJson(Map<String, Object?> json) {
    return Aggregates(
      numberOfMatches: int.parse('${json[AggregatesEnum.numberOfMatches.name]}'),
      totalGoals: int.parse('${json[AggregatesEnum.totalGoals.name]}'),
      homeTeam: Team.fromJson(json[AggregatesEnum.homeTeam.name] as Map<String, Object?>),
      awayTeam: Team.fromJson(json[AggregatesEnum.awayTeam.name] as Map<String, Object?>),
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is Aggregates &&
        other.runtimeType == runtimeType &&
        other.numberOfMatches == numberOfMatches && //
        other.totalGoals == totalGoals && //
        other.homeTeam == homeTeam && //
        other.awayTeam == awayTeam;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      numberOfMatches,
      totalGoals,
      homeTeam,
      awayTeam,
    );
  }
}

enum AggregatesEnum {
  numberOfMatches,
  totalGoals,
  homeTeam,
  awayTeam,
  none,
}

class H2HResultSet {
  final int count;

  final String competitions;

  final DateTime first;

  final DateTime last;
  H2HResultSet({
    required this.count,
    required this.competitions,
    required this.first,
    required this.last,
  });

  H2HResultSet copyWith({
    int? count,
    String? competitions,
    DateTime? first,
    DateTime? last,
  }) {
    return H2HResultSet(
      count: count ?? this.count,
      competitions: competitions ?? this.competitions,
      first: first ?? this.first,
      last: last ?? this.last,
    );
  }

  Map<String, Object?> toJson() {
    return {
      ResultSetEnum.count.name: count,
      ResultSetEnum.competitions.name: competitions,
      ResultSetEnum.first.name: first,
      ResultSetEnum.last.name: last,
    };
  }

  factory H2HResultSet.fromJson(Map<String, Object?> json) {
    return H2HResultSet(
      count: int.parse('${json[ResultSetEnum.count.name]}'),
      competitions: json[ResultSetEnum.competitions.name] as String,
      first: DateTime.parse('${json[ResultSetEnum.first.name]}').add(DateTime.now().timeZoneOffset),
      last: DateTime.parse('${json[ResultSetEnum.last.name]}').add(DateTime.now().timeZoneOffset),
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is H2HResultSet &&
        other.runtimeType == runtimeType &&
        other.count == count && //
        other.competitions == competitions && //
        other.first == first && //
        other.last == last;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      count,
      competitions,
      first,
      last,
    );
  }
}

enum ResultSetEnum {
  count,
  competitions,
  first,
  last,
  none,
}
