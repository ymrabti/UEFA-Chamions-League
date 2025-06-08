import "package:botola_max/lib.dart";

enum MatchDetailSupperClassEnum {
  matchDetail,
  head2head,
}

class MatchDetailSupperClass {
  final MatchDetailsModel matchDetails;
  final MatchHead2HeadModel head2head;

  MatchDetailSupperClass({
    required this.matchDetails,
    required this.head2head,
  });
}

/*    
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
        "id": 733,
        "startDate": "2021-08-13",
        "endDate": "2022-05-22",
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
    "id": 327117,
    "utcDate": "2022-02-12T12:30:00Z",
    "status": "FINISHED",
    "venue": null,
    "matchday": 25,
    "stage": "REGULAR_SEASON",
    "group": null,
    "lastUpdated": "2022-06-16T08:20:23Z",
    "homeTeam": {
        "id": 66,
        "name": "Manchester United FC",
        "shortName": "Man United",
        "tla": "MUN",
        "crest": "https://crests.football-data.org/66.png"
    },
    "awayTeam": {
        "id": 340,
        "name": "Southampton FC",
        "shortName": "Southampton",
        "tla": "SOU",
        "crest": "https://crests.football-data.org/340.png"
    },
    "score": {
        "winner": "DRAW",
        "duration": "REGULAR",
        "fullTime": {
            "home": 1,
            "away": 1
        },
        "halfTime": {
            "home": 1,
            "away": 0
        }
    },
    "odds": {
        "msg": "Activate Odds-Package in User-Panel to retrieve odds."
    },
    "referees": [
        {
            "id": 11494,
            "name": "Stuart Attwell",
            "type": "REFEREE",
            "nationality": "England"
        }
    ]
}
*/

class MatchDetailsModel extends IGenericAppModel {
  final Area area;

  final Competition competition;

  final Season season;

  final int id;

  final DateTime utcDate;

  final String status;

  final dynamic venue;

  final int? matchday;

  final String stage;

  final String? group;

  final DateTime lastUpdated;

  final Team homeTeam;

  final Team awayTeam;

  final Score score;

  final List<Referees> referees;
  MatchDetailsModel({
    required this.area,
    required this.competition,
    required this.season,
    required this.id,
    required this.utcDate,
    required this.status,
    required this.venue,
    required this.matchday,
    required this.stage,
    required this.group,
    required this.lastUpdated,
    required this.homeTeam,
    required this.awayTeam,
    required this.score,
    required this.referees,
  });

  MatchDetailsModel copyWith({
    Area? area,
    Competition? competition,
    Season? season,
    int? id,
    DateTime? utcDate,
    String? status,
    dynamic venue,
    int? matchday,
    String? stage,
    dynamic group,
    DateTime? lastUpdated,
    Team? homeTeam,
    Team? awayTeam,
    Score? score,
    List<Referees>? referees,
  }) {
    return MatchDetailsModel(
      area: area ?? this.area,
      competition: competition ?? this.competition,
      season: season ?? this.season,
      id: id ?? this.id,
      utcDate: utcDate ?? this.utcDate,
      status: status ?? this.status,
      venue: venue ?? this.venue,
      matchday: matchday ?? this.matchday,
      stage: stage ?? this.stage,
      group: group ?? this.group,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      score: score ?? this.score,
      referees: referees ?? this.referees,
    );
  }

  Matche get matche => Matche(
        area: area,
        competition: competition,
        season: season,
        id: id,
        utcDate: utcDate,
        status: status,
        matchday: matchday ?? 0,
        stage: stage,
        group: group,
        lastUpdated: lastUpdated,
        homeTeam: homeTeam,
        awayTeam: awayTeam,
        score: score,
        referees: referees,
      );
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      MatchDetailsModelEnum.area.name: area.toJson(),
      MatchDetailsModelEnum.competition.name: competition.toJson(),
      MatchDetailsModelEnum.season.name: season.toJson(),
      MatchDetailsModelEnum.id.name: id,
      MatchDetailsModelEnum.utcDate.name: utcDate,
      MatchDetailsModelEnum.status.name: status,
      MatchDetailsModelEnum.venue.name: venue,
      MatchDetailsModelEnum.matchday.name: matchday,
      MatchDetailsModelEnum.stage.name: stage,
      MatchDetailsModelEnum.group.name: group,
      MatchDetailsModelEnum.lastUpdated.name: lastUpdated,
      MatchDetailsModelEnum.homeTeam.name: homeTeam.toJson(),
      MatchDetailsModelEnum.awayTeam.name: awayTeam.toJson(),
      MatchDetailsModelEnum.score.name: score.toJson(),
      MatchDetailsModelEnum.referees.name: referees.map<Map<String, dynamic>>((Referees data) => data.toJson()).toList(),
    };
  }

  factory MatchDetailsModel.fromJson(Map<String, Object?> json) {
    return MatchDetailsModel(
      area: Area.fromJson(json[MatchDetailsModelEnum.area.name] as Map<String, Object?>),
      competition: Competition.fromJson(json[MatchDetailsModelEnum.competition.name] as Map<String, Object?>),
      season: Season.fromJson(json[MatchDetailsModelEnum.season.name] as Map<String, Object?>),
      id: int.parse('${json[MatchDetailsModelEnum.id.name]}'),
      utcDate: DateTime.parse('${json[MatchDetailsModelEnum.utcDate.name]}').add(DateTime.now().timeZoneOffset),
      status: json[MatchDetailsModelEnum.status.name] as String,
      venue: json[MatchDetailsModelEnum.venue.name],
      matchday: int.tryParse('${json[MatchDetailsModelEnum.matchday.name]}'),
      stage: json[MatchDetailsModelEnum.stage.name] as String,
      group: json[MatchDetailsModelEnum.group.name] as String?,
      lastUpdated: DateTime.parse('${json[MatchDetailsModelEnum.lastUpdated.name]}').add(DateTime.now().timeZoneOffset),
      homeTeam: Team.fromJson(json[MatchDetailsModelEnum.homeTeam.name] as Map<String, Object?>),
      awayTeam: Team.fromJson(json[MatchDetailsModelEnum.awayTeam.name] as Map<String, Object?>),
      score: Score.fromJson(json[MatchDetailsModelEnum.score.name] as Map<String, Object?>),
      referees: (json[MatchDetailsModelEnum.referees.name] as List<dynamic>).map<Referees>((dynamic data) => Referees.fromJson(data as Map<String, Object?>)).toList(),
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is MatchDetailsModel &&
        other.runtimeType == runtimeType &&
        other.area == area && //
        other.competition == competition && //
        other.season == season && //
        other.id == id && //
        other.utcDate == utcDate && //
        other.status == status && //
        other.venue == venue && //
        other.matchday == matchday && //
        other.stage == stage && //
        other.group == group && //
        other.lastUpdated == lastUpdated && //
        other.homeTeam == homeTeam && //
        other.awayTeam == awayTeam && //
        other.score == score && //
        other.referees == referees;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      area,
      competition,
      season,
      id,
      utcDate,
      status,
      venue,
      matchday,
      stage,
      group,
      lastUpdated,
      homeTeam,
      awayTeam,
      score,
      referees,
    );
  }
}

enum MatchDetailsModelEnum {
  area,
  competition,
  season,
  id,
  utcDate,
  status,
  venue,
  matchday,
  stage,
  group,
  lastUpdated,
  homeTeam,
  awayTeam,
  score,
  odds,
  referees,
  none,
}
