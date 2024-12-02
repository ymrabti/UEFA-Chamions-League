import "package:botola_max/lib.dart";

/*    
{
    "id": 16275,
    "name": "Djibril Sow",
    "firstName": "Djibril",
    "lastName": "Sow",
    "dateOfBirth": "1997-02-06",
    "nationality": "Switzerland",
    "section": "Central Midfield",
    "position": "Midfield",
    "shirtNumber": 20,
    "lastUpdated": "2024-08-12T11:57:15Z",
    "currentTeam": {
        "area": {
            "id": 2224,
            "name": "Spain",
            "code": "ESP",
            "flag": "https://crests.football-data.org/760.svg"
        },
        "id": 559,
        "name": "Sevilla FC",
        "shortName": "Sevilla FC",
        "tla": "SEV",
        "crest": "https://crests.football-data.org/559.png",
        "address": "Calle Sevilla Fútbol Club, s/n Sevilla 41005",
        "website": "http://www.sevillafc.es",
        "founded": 1905,
        "clubColors": "White / Red",
        "venue": "Estadio Ramón Sánchez Pizjuán",
        "runningCompetitions": [
            {
                "id": 2014,
                "name": "Primera Division",
                "code": "PD",
                "type": "LEAGUE",
                "emblem": "https://crests.football-data.org/laliga.png"
            }
        ],
        "contract": {
            "start": "2024-07",
            "until": "2028-06"
        }
    }
}
*/

class BotolaXPerson extends IGenericAppModel {
  final int id;

  final String name;

  final String firstName;

  final String lastName;

  final DateTime dateOfBirth;

  final String nationality;

  final String section;

  final String position;

  final int shirtNumber;

  final DateTime lastUpdated;

  final CurrentTeam currentTeam;
  BotolaXPerson({
    required this.id,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.nationality,
    required this.section,
    required this.position,
    required this.shirtNumber,
    required this.lastUpdated,
    required this.currentTeam,
  });

  BotolaXPerson copyWith({
    int? id,
    String? name,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? nationality,
    String? section,
    String? position,
    int? shirtNumber,
    DateTime? lastUpdated,
    CurrentTeam? currentTeam,
  }) {
    return BotolaXPerson(
      id: id ?? this.id,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      nationality: nationality ?? this.nationality,
      section: section ?? this.section,
      position: position ?? this.position,
      shirtNumber: shirtNumber ?? this.shirtNumber,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      currentTeam: currentTeam ?? this.currentTeam,
    );
  }

  @override
  Map<String, Object?> toJson() {
    return {
      BotolaXPersonEnum.id.name: id,
      BotolaXPersonEnum.name.name: name,
      BotolaXPersonEnum.firstName.name: firstName,
      BotolaXPersonEnum.lastName.name: lastName,
      BotolaXPersonEnum.dateOfBirth.name: dateOfBirth,
      BotolaXPersonEnum.nationality.name: nationality,
      BotolaXPersonEnum.section.name: section,
      BotolaXPersonEnum.position.name: position,
      BotolaXPersonEnum.shirtNumber.name: shirtNumber,
      BotolaXPersonEnum.lastUpdated.name: lastUpdated,
      BotolaXPersonEnum.currentTeam.name: currentTeam.toJson(),
    };
  }

  factory BotolaXPerson.fromJson(Map<String, Object?> json) {
    return BotolaXPerson(
      id: int.parse('${json[BotolaXPersonEnum.id.name]}'),
      name: json[BotolaXPersonEnum.name.name] as String,
      firstName: json[BotolaXPersonEnum.firstName.name] as String,
      lastName: json[BotolaXPersonEnum.lastName.name] as String,
      dateOfBirth: DateTime.parse('${json[BotolaXPersonEnum.dateOfBirth.name]}'),
      nationality: json[BotolaXPersonEnum.nationality.name] as String,
      section: json[BotolaXPersonEnum.section.name] as String,
      position: json[BotolaXPersonEnum.position.name] as String,
      shirtNumber: int.parse('${json[BotolaXPersonEnum.shirtNumber.name]}'),
      lastUpdated: DateTime.parse('${json[BotolaXPersonEnum.lastUpdated.name]}').add(DateTime.now().timeZoneOffset),
      currentTeam: CurrentTeam.fromJson(json[BotolaXPersonEnum.currentTeam.name] as Map<String, Object?>),
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is BotolaXPerson &&
        other.runtimeType == runtimeType &&
        other.id == id && //
        other.name == name && //
        other.firstName == firstName && //
        other.lastName == lastName && //
        other.dateOfBirth == dateOfBirth && //
        other.nationality == nationality && //
        other.section == section && //
        other.position == position && //
        other.shirtNumber == shirtNumber && //
        other.lastUpdated == lastUpdated && //
        other.currentTeam == currentTeam;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      name,
      firstName,
      lastName,
      dateOfBirth,
      nationality,
      section,
      position,
      shirtNumber,
      lastUpdated,
      currentTeam,
    );
  }
}

enum BotolaXPersonEnum {
  id,
  name,
  firstName,
  lastName,
  dateOfBirth,
  nationality,
  section,
  position,
  shirtNumber,
  lastUpdated,
  currentTeam,
  none,
}

extension BotolaXPersonSort on List<BotolaXPerson> {
  List<BotolaXPerson> sorty(String caseField, {bool desc = false}) {
    return this
      ..sort((a, b) {
        int fact = (desc ? -1 : 1);

        if (caseField == BotolaXPersonEnum.id.name) {
          // unsortable

          int akey = a.id;
          int bkey = b.id;

          return fact * (bkey - akey);
        }

        if (caseField == BotolaXPersonEnum.name.name) {
          // unsortable

          String akey = a.name;
          String bkey = b.name;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == BotolaXPersonEnum.firstName.name) {
          // unsortable

          String akey = a.firstName;
          String bkey = b.firstName;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == BotolaXPersonEnum.lastName.name) {
          // unsortable

          String akey = a.lastName;
          String bkey = b.lastName;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == BotolaXPersonEnum.dateOfBirth.name) {
          // unsortable

          DateTime akey = a.dateOfBirth;
          DateTime bkey = b.dateOfBirth;

          return fact * bkey.compareTo(akey);
        }

        if (caseField == BotolaXPersonEnum.nationality.name) {
          // unsortable

          String akey = a.nationality;
          String bkey = b.nationality;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == BotolaXPersonEnum.section.name) {
          // unsortable

          String akey = a.section;
          String bkey = b.section;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == BotolaXPersonEnum.position.name) {
          // unsortable

          String akey = a.position;
          String bkey = b.position;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == BotolaXPersonEnum.shirtNumber.name) {
          // unsortable

          int akey = a.shirtNumber;
          int bkey = b.shirtNumber;

          return fact * (bkey - akey);
        }

        if (caseField == BotolaXPersonEnum.lastUpdated.name) {
          // unsortable

          DateTime akey = a.lastUpdated;
          DateTime bkey = b.lastUpdated;

          return fact * bkey.compareTo(akey);
        }

        return 0;
      });
  }
}

class CurrentTeam {
  final Area area;

  final int id;

  final String name;

  final String shortName;

  final String tla;

  final String crest;

  final String address;

  final String website;

  final int founded;

  final String clubColors;

  final String? venue;

  final List<RunningCompetitions> runningCompetitions;

  final Contract contract;
  CurrentTeam({
    required this.area,
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
    required this.runningCompetitions,
    required this.contract,
  });

  CurrentTeam copyWith({
    Area? area,
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
    List<RunningCompetitions>? runningCompetitions,
    Contract? contract,
  }) {
    return CurrentTeam(
      area: area ?? this.area,
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
      runningCompetitions: runningCompetitions ?? this.runningCompetitions,
      contract: contract ?? this.contract,
    );
  }

  Map<String, Object?> toJson() {
    return {
      CurrentTeamEnum.area.name: area.toJson(),
      CurrentTeamEnum.id.name: id,
      CurrentTeamEnum.name.name: name,
      CurrentTeamEnum.shortName.name: shortName,
      CurrentTeamEnum.tla.name: tla,
      CurrentTeamEnum.crest.name: crest,
      CurrentTeamEnum.address.name: address,
      CurrentTeamEnum.website.name: website,
      CurrentTeamEnum.founded.name: founded,
      CurrentTeamEnum.clubColors.name: clubColors,
      CurrentTeamEnum.venue.name: venue,
      CurrentTeamEnum.runningCompetitions.name: runningCompetitions.map<Map<String, dynamic>>((data) => data.toJson()).toList(),
      CurrentTeamEnum.contract.name: contract.toJson(),
    };
  }

  factory CurrentTeam.fromJson(Map<String, Object?> json) {
    return CurrentTeam(
      area: Area.fromJson(json[CurrentTeamEnum.area.name] as Map<String, Object?>),
      id: int.parse('${json[CurrentTeamEnum.id.name]}'),
      name: json[CurrentTeamEnum.name.name] as String,
      shortName: json[CurrentTeamEnum.shortName.name] as String,
      tla: json[CurrentTeamEnum.tla.name] as String,
      crest: json[CurrentTeamEnum.crest.name] as String,
      address: '${json[CurrentTeamEnum.address.name]}',
      website: json[CurrentTeamEnum.website.name] as String,
      founded: int.parse('${json[CurrentTeamEnum.founded.name]}'),
      clubColors: json[CurrentTeamEnum.clubColors.name] as String,
      venue: json[CurrentTeamEnum.venue.name] as String?,
      runningCompetitions: (json[CurrentTeamEnum.runningCompetitions.name] as List).map<RunningCompetitions>((data) => RunningCompetitions.fromJson(data as Map<String, Object?>)).toList(),
      contract: Contract.fromJson(json[CurrentTeamEnum.contract.name] as Map<String, Object?>),
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentTeam &&
        other.runtimeType == runtimeType &&
        other.area == area && //
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
        other.runningCompetitions == runningCompetitions && //
        other.contract == contract;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      area,
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
      runningCompetitions,
      contract,
    );
  }
}

enum CurrentTeamEnum {
  area,
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
  runningCompetitions,
  contract,
  none,
}

extension CurrentTeamSort on List<CurrentTeam> {
  List<CurrentTeam> sorty(String caseField, {bool desc = false}) {
    return this
      ..sort((a, b) {
        int fact = (desc ? -1 : 1);

        if (caseField == CurrentTeamEnum.id.name) {
          // unsortable

          int akey = a.id;
          int bkey = b.id;

          return fact * (bkey - akey);
        }

        if (caseField == CurrentTeamEnum.name.name) {
          // unsortable

          String akey = a.name;
          String bkey = b.name;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == CurrentTeamEnum.shortName.name) {
          // unsortable

          String akey = a.shortName;
          String bkey = b.shortName;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == CurrentTeamEnum.tla.name) {
          // unsortable

          String akey = a.tla;
          String bkey = b.tla;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == CurrentTeamEnum.crest.name) {
          // unsortable

          String akey = a.crest;
          String bkey = b.crest;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == CurrentTeamEnum.address.name) {
          // unsortable

          String akey = a.address;
          String bkey = b.address;

          return fact * bkey.compareTo(akey);
        }

        if (caseField == CurrentTeamEnum.website.name) {
          // unsortable

          String akey = a.website;
          String bkey = b.website;

          return fact * (bkey.compareTo(akey));
        }

        if (caseField == CurrentTeamEnum.founded.name) {
          // unsortable

          int akey = a.founded;
          int bkey = b.founded;

          return fact * (bkey - akey);
        }

        if (caseField == CurrentTeamEnum.clubColors.name) {
          // unsortable

          String akey = a.clubColors;
          String bkey = b.clubColors;

          return fact * (bkey.compareTo(akey));
        }

        return 0;
      });
  }
}
