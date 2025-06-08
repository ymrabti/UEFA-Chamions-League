import "dart:convert";

import "package:botola_max/lib.dart";

/*    
{
    "area": {
        "id": 2072,
        "name": "England",
        "code": "ENG",
        "flag": "https://crests.football-data.org/770.svg"
    },
    "id": 2021,
    "name": "Premier League",
    "code": "PL",
    "type": "LEAGUE",
    "emblem": "https://crests.football-data.org/PL.png",
    "currentSeason": {
        "id": 2287,
        "startDate": "2024-08-16",
        "endDate": "2025-05-25",
        "currentMatchday": 13,
        "winner": null
    },
    "seasons": [
        {
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
        {
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
        {
            "id": 619,
            "startDate": "2020-09-12",
            "endDate": "2021-05-23",
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
        {
            "id": 468,
            "startDate": "2019-08-09",
            "endDate": "2020-07-26",
            "currentMatchday": 38,
            "winner": {
                "id": 64,
                "name": "Liverpool FC",
                "shortName": "Liverpool",
                "tla": "LIV",
                "crest": "https://crests.football-data.org/64.png",
                "address": "Anfield Road Liverpool L4 0TH",
                "website": "http://www.liverpoolfc.tv",
                "founded": 1892,
                "clubColors": "Red / White",
                "venue": "Anfield",
                "lastUpdated": "2022-02-10T19:30:22Z"
            }
        },
        {
            "id": 151,
            "startDate": "2018-08-10",
            "endDate": "2019-05-12",
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
        {
            "id": 23,
            "startDate": "2017-08-11",
            "endDate": "2018-05-13",
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
        {
            "id": 256,
            "startDate": "2016-08-13",
            "endDate": "2017-05-21",
            "currentMatchday": null,
            "winner": {
                "id": 61,
                "name": "Chelsea FC",
                "shortName": "Chelsea",
                "tla": "CHE",
                "crest": "https://crests.football-data.org/61.png",
                "address": "Fulham Road London SW6 1HS",
                "website": "http://www.chelseafc.com",
                "founded": 1905,
                "clubColors": "Royal Blue / White",
                "venue": "Stamford Bridge",
                "lastUpdated": "2022-02-10T19:24:40Z"
            }
        },
        {
            "id": 257,
            "startDate": "2015-08-08",
            "endDate": "2016-05-17",
            "currentMatchday": null,
            "winner": {
                "id": 338,
                "name": "Leicester City FC",
                "shortName": "Leicester City",
                "tla": "LEI",
                "crest": "https://crests.football-data.org/338.png",
                "address": "The Walkers Stadium, Filbert Way Leicester LE2 7FL",
                "website": "http://www.lcfc.com",
                "founded": 1884,
                "clubColors": "Royal Blue / White",
                "venue": "King Power Stadium",
                "lastUpdated": "2022-02-10T19:48:23Z"
            }
        },
        {
            "id": 258,
            "startDate": "2014-08-16",
            "endDate": "2015-05-24",
            "currentMatchday": null,
            "winner": {
                "id": 61,
                "name": "Chelsea FC",
                "shortName": "Chelsea",
                "tla": "CHE",
                "crest": "https://crests.football-data.org/61.png",
                "address": "Fulham Road London SW6 1HS",
                "website": "http://www.chelseafc.com",
                "founded": 1905,
                "clubColors": "Royal Blue / White",
                "venue": "Stamford Bridge",
                "lastUpdated": "2022-02-10T19:24:40Z"
            }
        },
        {
            "id": 259,
            "startDate": "2013-08-17",
            "endDate": "2014-05-11",
            "currentMatchday": null,
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
        {
            "id": 260,
            "startDate": "2012-08-18",
            "endDate": "2013-05-19",
            "currentMatchday": null,
            "winner": {
                "id": 66,
                "name": "Manchester United FC",
                "shortName": "Man United",
                "tla": "MUN",
                "crest": "https://crests.football-data.org/66.png",
                "address": "Sir Matt Busby Way Manchester M16 0RA",
                "website": "http://www.manutd.com",
                "founded": 1878,
                "clubColors": "Red / White",
                "venue": "Old Trafford",
                "lastUpdated": "2022-02-10T19:27:46Z"
            }
        },
        {
            "id": 261,
            "startDate": "2011-08-13",
            "endDate": "2012-05-13",
            "currentMatchday": null,
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
        {
            "id": 262,
            "startDate": "2010-08-14",
            "endDate": "2011-05-22",
            "currentMatchday": null,
            "winner": {
                "id": 66,
                "name": "Manchester United FC",
                "shortName": "Man United",
                "tla": "MUN",
                "crest": "https://crests.football-data.org/66.png",
                "address": "Sir Matt Busby Way Manchester M16 0RA",
                "website": "http://www.manutd.com",
                "founded": 1878,
                "clubColors": "Red / White",
                "venue": "Old Trafford",
                "lastUpdated": "2022-02-10T19:27:46Z"
            }
        },
        {
            "id": 263,
            "startDate": "2009-08-15",
            "endDate": "2010-05-09",
            "currentMatchday": null,
            "winner": {
                "id": 61,
                "name": "Chelsea FC",
                "shortName": "Chelsea",
                "tla": "CHE",
                "crest": "https://crests.football-data.org/61.png",
                "address": "Fulham Road London SW6 1HS",
                "website": "http://www.chelseafc.com",
                "founded": 1905,
                "clubColors": "Royal Blue / White",
                "venue": "Stamford Bridge",
                "lastUpdated": "2022-02-10T19:24:40Z"
            }
        },
        {
            "id": 264,
            "startDate": "2008-08-16",
            "endDate": "2009-05-24",
            "currentMatchday": null,
            "winner": {
                "id": 66,
                "name": "Manchester United FC",
                "shortName": "Man United",
                "tla": "MUN",
                "crest": "https://crests.football-data.org/66.png",
                "address": "Sir Matt Busby Way Manchester M16 0RA",
                "website": "http://www.manutd.com",
                "founded": 1878,
                "clubColors": "Red / White",
                "venue": "Old Trafford",
                "lastUpdated": "2022-02-10T19:27:46Z"
            }
        },
        {
            "id": 265,
            "startDate": "2007-08-11",
            "endDate": "2008-05-11",
            "currentMatchday": null,
            "winner": {
                "id": 66,
                "name": "Manchester United FC",
                "shortName": "Man United",
                "tla": "MUN",
                "crest": "https://crests.football-data.org/66.png",
                "address": "Sir Matt Busby Way Manchester M16 0RA",
                "website": "http://www.manutd.com",
                "founded": 1878,
                "clubColors": "Red / White",
                "venue": "Old Trafford",
                "lastUpdated": "2022-02-10T19:27:46Z"
            }
        },
        {
            "id": 266,
            "startDate": "2006-08-19",
            "endDate": "2007-05-13",
            "currentMatchday": null,
            "winner": {
                "id": 66,
                "name": "Manchester United FC",
                "shortName": "Man United",
                "tla": "MUN",
                "crest": "https://crests.football-data.org/66.png",
                "address": "Sir Matt Busby Way Manchester M16 0RA",
                "website": "http://www.manutd.com",
                "founded": 1878,
                "clubColors": "Red / White",
                "venue": "Old Trafford",
                "lastUpdated": "2022-02-10T19:27:46Z"
            }
        },
        {
            "id": 267,
            "startDate": "2005-08-13",
            "endDate": "2006-05-07",
            "currentMatchday": null,
            "winner": {
                "id": 61,
                "name": "Chelsea FC",
                "shortName": "Chelsea",
                "tla": "CHE",
                "crest": "https://crests.football-data.org/61.png",
                "address": "Fulham Road London SW6 1HS",
                "website": "http://www.chelseafc.com",
                "founded": 1905,
                "clubColors": "Royal Blue / White",
                "venue": "Stamford Bridge",
                "lastUpdated": "2022-02-10T19:24:40Z"
            }
        },
        {
            "id": 268,
            "startDate": "2004-08-14",
            "endDate": "2005-05-15",
            "currentMatchday": null,
            "winner": {
                "id": 61,
                "name": "Chelsea FC",
                "shortName": "Chelsea",
                "tla": "CHE",
                "crest": "https://crests.football-data.org/61.png",
                "address": "Fulham Road London SW6 1HS",
                "website": "http://www.chelseafc.com",
                "founded": 1905,
                "clubColors": "Royal Blue / White",
                "venue": "Stamford Bridge",
                "lastUpdated": "2022-02-10T19:24:40Z"
            }
        },
        {
            "id": 269,
            "startDate": "2003-08-16",
            "endDate": "2004-05-15",
            "currentMatchday": null,
            "winner": {
                "id": 57,
                "name": "Arsenal FC",
                "shortName": "Arsenal",
                "tla": "ARS",
                "crest": "https://crests.football-data.org/57.png",
                "address": "75 Drayton Park London N5 1BU",
                "website": "http://www.arsenal.com",
                "founded": 1886,
                "clubColors": "Red / White",
                "venue": "Emirates Stadium",
                "lastUpdated": "2022-02-10T19:48:56Z"
            }
        },
        {
            "id": 270,
            "startDate": "2002-08-17",
            "endDate": "2003-05-11",
            "currentMatchday": null,
            "winner": {
                "id": 66,
                "name": "Manchester United FC",
                "shortName": "Man United",
                "tla": "MUN",
                "crest": "https://crests.football-data.org/66.png",
                "address": "Sir Matt Busby Way Manchester M16 0RA",
                "website": "http://www.manutd.com",
                "founded": 1878,
                "clubColors": "Red / White",
                "venue": "Old Trafford",
                "lastUpdated": "2022-02-10T19:27:46Z"
            }
        },
        {
            "id": 271,
            "startDate": "2001-08-18",
            "endDate": "2002-05-11",
            "currentMatchday": null,
            "winner": {
                "id": 57,
                "name": "Arsenal FC",
                "shortName": "Arsenal",
                "tla": "ARS",
                "crest": "https://crests.football-data.org/57.png",
                "address": "75 Drayton Park London N5 1BU",
                "website": "http://www.arsenal.com",
                "founded": 1886,
                "clubColors": "Red / White",
                "venue": "Emirates Stadium",
                "lastUpdated": "2022-02-10T19:48:56Z"
            }
        },
        {
            "id": 272,
            "startDate": "2000-08-19",
            "endDate": "2001-05-19",
            "currentMatchday": null,
            "winner": {
                "id": 66,
                "name": "Manchester United FC",
                "shortName": "Man United",
                "tla": "MUN",
                "crest": "https://crests.football-data.org/66.png",
                "address": "Sir Matt Busby Way Manchester M16 0RA",
                "website": "http://www.manutd.com",
                "founded": 1878,
                "clubColors": "Red / White",
                "venue": "Old Trafford",
                "lastUpdated": "2022-02-10T19:27:46Z"
            }
        },
        {
            "id": 273,
            "startDate": "1999-08-07",
            "endDate": "2000-05-14",
            "currentMatchday": null,
            "winner": {
                "id": 66,
                "name": "Manchester United FC",
                "shortName": "Man United",
                "tla": "MUN",
                "crest": "https://crests.football-data.org/66.png",
                "address": "Sir Matt Busby Way Manchester M16 0RA",
                "website": "http://www.manutd.com",
                "founded": 1878,
                "clubColors": "Red / White",
                "venue": "Old Trafford",
                "lastUpdated": "2022-02-10T19:27:46Z"
            }
        },
        {
            "id": 274,
            "startDate": "1998-08-15",
            "endDate": "1999-05-16",
            "currentMatchday": null,
            "winner": {
                "id": 66,
                "name": "Manchester United FC",
                "shortName": "Man United",
                "tla": "MUN",
                "crest": "https://crests.football-data.org/66.png",
                "address": "Sir Matt Busby Way Manchester M16 0RA",
                "website": "http://www.manutd.com",
                "founded": 1878,
                "clubColors": "Red / White",
                "venue": "Old Trafford",
                "lastUpdated": "2022-02-10T19:27:46Z"
            }
        },
        {
            "id": 275,
            "startDate": "1997-08-09",
            "endDate": "1998-05-10",
            "currentMatchday": null,
            "winner": {
                "id": 57,
                "name": "Arsenal FC",
                "shortName": "Arsenal",
                "tla": "ARS",
                "crest": "https://crests.football-data.org/57.png",
                "address": "75 Drayton Park London N5 1BU",
                "website": "http://www.arsenal.com",
                "founded": 1886,
                "clubColors": "Red / White",
                "venue": "Emirates Stadium",
                "lastUpdated": "2022-02-10T19:48:56Z"
            }
        },
        {
            "id": 276,
            "startDate": "1996-08-17",
            "endDate": "1997-05-11",
            "currentMatchday": null,
            "winner": {
                "id": 66,
                "name": "Manchester United FC",
                "shortName": "Man United",
                "tla": "MUN",
                "crest": "https://crests.football-data.org/66.png",
                "address": "Sir Matt Busby Way Manchester M16 0RA",
                "website": "http://www.manutd.com",
                "founded": 1878,
                "clubColors": "Red / White",
                "venue": "Old Trafford",
                "lastUpdated": "2022-02-10T19:27:46Z"
            }
        },
        {
            "id": 277,
            "startDate": "1995-08-19",
            "endDate": "1996-05-04",
            "currentMatchday": 38,
            "winner": {
                "id": 66,
                "name": "Manchester United FC",
                "shortName": "Man United",
                "tla": "MUN",
                "crest": "https://crests.football-data.org/66.png",
                "address": "Sir Matt Busby Way Manchester M16 0RA",
                "website": "http://www.manutd.com",
                "founded": 1878,
                "clubColors": "Red / White",
                "venue": "Old Trafford",
                "lastUpdated": "2022-02-10T19:27:46Z"
            }
        },
        {
            "id": 254,
            "startDate": "1994-08-20",
            "endDate": "1995-05-14",
            "currentMatchday": 42,
            "winner": {
                "id": 59,
                "name": "Blackburn Rovers FC",
                "shortName": "Blackburn",
                "tla": "BLA",
                "crest": "https://crests.football-data.org/59.png",
                "address": "Ewood Park Blackburn BB2 4JF",
                "website": "http://www.rovers.co.uk",
                "founded": 1874,
                "clubColors": "Blue / White",
                "venue": "Ewood Park",
                "lastUpdated": "2022-02-19T08:50:27Z"
            }
        },
        {
            "id": 255,
            "startDate": "1993-08-14",
            "endDate": "1994-05-08",
            "currentMatchday": 42,
            "winner": {
                "id": 66,
                "name": "Manchester United FC",
                "shortName": "Man United",
                "tla": "MUN",
                "crest": "https://crests.football-data.org/66.png",
                "address": "Sir Matt Busby Way Manchester M16 0RA",
                "website": "http://www.manutd.com",
                "founded": 1878,
                "clubColors": "Red / White",
                "venue": "Old Trafford",
                "lastUpdated": "2022-02-10T19:27:46Z"
            }
        },
        {
            "id": 818,
            "startDate": "1992-08-13",
            "endDate": "1993-05-09",
            "currentMatchday": 42,
            "winner": {
                "id": 66,
                "name": "Manchester United FC",
                "shortName": "Man United",
                "tla": "MUN",
                "crest": "https://crests.football-data.org/66.png",
                "address": "Sir Matt Busby Way Manchester M16 0RA",
                "website": "http://www.manutd.com",
                "founded": 1878,
                "clubColors": "Red / White",
                "venue": "Old Trafford",
                "lastUpdated": "2022-02-10T19:27:46Z"
            }
        },
        {
            "id": 819,
            "startDate": "1991-08-15",
            "endDate": "1992-04-30",
            "currentMatchday": 42,
            "winner": {
                "id": 341,
                "name": "Leeds United FC",
                "shortName": "Leeds United",
                "tla": "LEE",
                "crest": "https://crests.football-data.org/341.png",
                "address": "Elland Road Leeds LS11 0ES",
                "website": "http://www.leedsunited.com",
                "founded": 1904,
                "clubColors": "White / Blue",
                "venue": "Elland Road",
                "lastUpdated": "2022-02-10T19:27:14Z"
            }
        },
        {
            "id": 820,
            "startDate": "1990-08-23",
            "endDate": "1991-05-18",
            "currentMatchday": 38,
            "winner": {
                "id": 57,
                "name": "Arsenal FC",
                "shortName": "Arsenal",
                "tla": "ARS",
                "crest": "https://crests.football-data.org/57.png",
                "address": "75 Drayton Park London N5 1BU",
                "website": "http://www.arsenal.com",
                "founded": 1886,
                "clubColors": "Red / White",
                "venue": "Emirates Stadium",
                "lastUpdated": "2022-02-10T19:48:56Z"
            }
        }
    ],
    "lastUpdated": "2024-09-13T16:51:24Z"
}
*/

class BotolaCompetition {
  final Area area;
  final int id;
  final String name;
  final String code;
  final String type;
  final String emblem;
  final CurrentSeason currentSeason;
  final List<Seasons> seasons;
  final DateTime lastUpdated;

  BotolaCompetition({
    required this.area,
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.emblem,
    required this.currentSeason,
    required this.seasons,
    required this.lastUpdated,
  });

  BotolaCompetition copyWith({
    Area? area,
    int? id,
    String? name,
    String? code,
    String? type,
    String? emblem,
    CurrentSeason? currentSeason,
    List<Seasons>? seasons,
    DateTime? lastUpdated,
  }) {
    return BotolaCompetition(
      area: area ?? this.area,
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      type: type ?? this.type,
      emblem: emblem ?? this.emblem,
      currentSeason: currentSeason ?? this.currentSeason,
      seasons: seasons ?? this.seasons,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  TheCompetition toTheCompetition() {
    return TheCompetition(
      id: id,
      area: area,
      name: name,
      code: code,
      type: type,
      emblem: emblem,
      plan: 'free',
      currentSeason: currentSeason,
      numberOfAvailableSeasons: 0,
      lastUpdated: lastUpdated,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      BotolaCompetitionEnum.area.name: area.toJson(),
      BotolaCompetitionEnum.id.name: id,
      BotolaCompetitionEnum.name.name: name,
      BotolaCompetitionEnum.code.name: code,
      BotolaCompetitionEnum.type.name: type,
      BotolaCompetitionEnum.emblem.name: emblem,
      BotolaCompetitionEnum.currentSeason.name: currentSeason.toJson(),
      BotolaCompetitionEnum.seasons.name: seasons.map<Map<String, dynamic>>((Seasons data) => data.toJson()).toList(),
      BotolaCompetitionEnum.lastUpdated.name: lastUpdated,
    };
  }

  factory BotolaCompetition.fromJson(Map<String, Object?> json) {
    return BotolaCompetition(
      area: Area.fromJson(json[BotolaCompetitionEnum.area.name] as Map<String, Object?>),
      id: int.parse('${json[BotolaCompetitionEnum.id.name]}'),
      name: json[BotolaCompetitionEnum.name.name] as String,
      code: json[BotolaCompetitionEnum.code.name] as String,
      type: json[BotolaCompetitionEnum.type.name] as String,
      emblem: json[BotolaCompetitionEnum.emblem.name] as String,
      currentSeason: CurrentSeason.fromJson(json[BotolaCompetitionEnum.currentSeason.name] as Map<String, Object?>),
      seasons: (json[BotolaCompetitionEnum.seasons.name] as List<dynamic>).map<Seasons>((dynamic data) => Seasons.fromJson(data as Map<String, Object?>)).toList(),
      lastUpdated: DateTime.parse('${json[BotolaCompetitionEnum.lastUpdated.name]}').add(DateTime.now().timeZoneOffset),
    );
  }

  String get anthem {
    switch (code) {
      case 'CL':
        return 'bg_audio.mp3';
      case 'WC':
        return 'wc_qatar.mp3';
      default:
        return '';
    }
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is BotolaCompetition &&
        other.runtimeType == runtimeType &&
        other.area == area && //
        other.id == id && //
        other.name == name && //
        other.code == code && //
        other.type == type && //
        other.emblem == emblem && //
        other.currentSeason == currentSeason && //
        other.seasons == seasons && //
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      area,
      id,
      name,
      code,
      type,
      emblem,
      currentSeason,
      seasons,
      lastUpdated,
    );
  }
}

enum BotolaCompetitionEnum {
  area,
  id,
  name,
  code,
  type,
  emblem,
  currentSeason,
  seasons,
  lastUpdated,
  none,
}

extension BotolaCompetitionSort on List<BotolaCompetition> {
  List<BotolaCompetition> sorty(String caseField, {bool desc = false}) {
    return this
      ..sort((BotolaCompetition a, BotolaCompetition b) {
        int fact = (desc ? -1 : 1);

        if (caseField == BotolaCompetitionEnum.id.name) {
          // unsortable

          int akey = a.id;
          int bkey = b.id;

          return fact * (bkey - akey);
        }

        if (caseField == BotolaCompetitionEnum.name.name) {
          // unsortable

          String akey = a.name;
          String bkey = b.name;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == BotolaCompetitionEnum.code.name) {
          // unsortable

          String akey = a.code;
          String bkey = b.code;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == BotolaCompetitionEnum.type.name) {
          // unsortable

          String akey = a.type;
          String bkey = b.type;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == BotolaCompetitionEnum.emblem.name) {
          // unsortable

          String akey = a.emblem;
          String bkey = b.emblem;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == BotolaCompetitionEnum.lastUpdated.name) {
          // unsortable

          DateTime akey = a.lastUpdated;
          DateTime bkey = b.lastUpdated;

          return fact * bkey.compareTo(akey);
        }

        return 0;
      });
  }
}

class Seasons {
  final int id;

  final DateTime startDate;

  final DateTime endDate;

  final int? currentMatchday;

  final Winner? winner;
  Seasons({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.currentMatchday,
    required this.winner,
  });

  Seasons copyWith({
    int? id,
    DateTime? startDate,
    DateTime? endDate,
    int? currentMatchday,
    Winner? winner,
  }) {
    return Seasons(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currentMatchday: currentMatchday ?? this.currentMatchday,
      winner: winner ?? this.winner,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      SeasonsEnum.id.name: id,
      SeasonsEnum.startDate.name: startDate,
      SeasonsEnum.endDate.name: endDate,
      SeasonsEnum.currentMatchday.name: currentMatchday,
      SeasonsEnum.winner.name: winner?.toJson(),
    };
  }

  factory Seasons.fromJson(Map<String, Object?> json) {
    Map<String, Object?>? jsonWinner = json[SeasonsEnum.winner.name] as Map<String, Object?>?;
    return Seasons(
      id: int.parse('${json[SeasonsEnum.id.name]}'),
      startDate: DateTime.parse('${json[SeasonsEnum.startDate.name]}'),
      endDate: DateTime.parse('${json[SeasonsEnum.endDate.name]}'),
      currentMatchday: int.tryParse('${json[SeasonsEnum.currentMatchday.name]}'),
      winner: jsonWinner == null ? null : Winner.fromJson(jsonWinner),
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is Seasons &&
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

enum SeasonsEnum {
  id,
  startDate,
  endDate,
  currentMatchday,
  winner,
  none,
}

extension SeasonsSort on List<Seasons> {
  List<Seasons> sorty(String caseField, {bool desc = false}) {
    return this
      ..sort((Seasons a, Seasons b) {
        int fact = (desc ? -1 : 1);

        if (caseField == SeasonsEnum.id.name) {
          // unsortable

          int akey = a.id;
          int bkey = b.id;

          return fact * (bkey - akey);
        }

        if (caseField == SeasonsEnum.startDate.name) {
          // unsortable

          DateTime akey = a.startDate;
          DateTime bkey = b.startDate;

          return fact * bkey.compareTo(akey);
        }

        if (caseField == SeasonsEnum.endDate.name) {
          // unsortable

          DateTime akey = a.endDate;
          DateTime bkey = b.endDate;

          return fact * bkey.compareTo(akey);
        }

        if (caseField == SeasonsEnum.currentMatchday.name) {
          // unsortable

          int? akey = a.currentMatchday;
          int? bkey = b.currentMatchday;
          if (akey == null || bkey == null) return 0;
          return fact * (bkey - akey);
        }

        return 0;
      });
  }
}

class CurrentSeason {
  final int id;

  final DateTime startDate;

  final DateTime endDate;

  final int currentMatchday;

  final Winner? winner;
  CurrentSeason({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.currentMatchday,
    required this.winner,
  });

  CurrentSeason copyWith({
    int? id,
    DateTime? startDate,
    DateTime? endDate,
    int? currentMatchday,
    Winner? winner,
  }) {
    return CurrentSeason(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currentMatchday: currentMatchday ?? this.currentMatchday,
      winner: winner ?? this.winner,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      CurrentSeasonEnum.id.name: id,
      CurrentSeasonEnum.startDate.name: startDate,
      CurrentSeasonEnum.endDate.name: endDate,
      CurrentSeasonEnum.currentMatchday.name: currentMatchday,
      CurrentSeasonEnum.winner.name: winner,
    };
  }

  factory CurrentSeason.fromJson(Map<String, Object?> json) {
    dynamic jsonWinner = json[SeasonsEnum.winner.name];
    return CurrentSeason(
      id: int.parse('${json[CurrentSeasonEnum.id.name]}'),
      startDate: DateTime.parse('${json[CurrentSeasonEnum.startDate.name]}'),
      endDate: DateTime.parse('${json[CurrentSeasonEnum.endDate.name]}'),
      currentMatchday: int.tryParse('${json[CurrentSeasonEnum.currentMatchday.name]}') ?? 0,
      winner: jsonWinner == null
          ? null
          : jsonWinner is Map<String, Object?>
              ? Winner.fromJson(jsonWinner)
              : Winner.fromJson(jsonDecode(jsonWinner)),
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentSeason &&
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

enum CurrentSeasonEnum {
  id,
  startDate,
  endDate,
  currentMatchday,
  winner,
  none,
}

extension CurrentSeasonSort on List<CurrentSeason> {
  List<CurrentSeason> sorty(String caseField, {bool desc = false}) {
    return this
      ..sort((CurrentSeason a, CurrentSeason b) {
        int fact = (desc ? -1 : 1);

        if (caseField == CurrentSeasonEnum.id.name) {
          // unsortable

          int akey = a.id;
          int bkey = b.id;

          return fact * (bkey - akey);
        }

        if (caseField == CurrentSeasonEnum.startDate.name) {
          // unsortable

          DateTime akey = a.startDate;
          DateTime bkey = b.startDate;

          return fact * bkey.compareTo(akey);
        }

        if (caseField == CurrentSeasonEnum.endDate.name) {
          // unsortable

          DateTime akey = a.endDate;
          DateTime bkey = b.endDate;

          return fact * bkey.compareTo(akey);
        }

        if (caseField == CurrentSeasonEnum.currentMatchday.name) {
          // unsortable

          int akey = a.currentMatchday;
          int bkey = b.currentMatchday;

          return fact * (bkey - akey);
        }

        if (caseField == CurrentSeasonEnum.winner.name) {
          // unsortable
        }
        return 0;
      });
  }
}
