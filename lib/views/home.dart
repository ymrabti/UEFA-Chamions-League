import 'package:flutter/material.dart';
import 'package:uefa_champions_league/lib.dart';
import 'package:uefa_champions_league/models/all_competitions.dart';

class ChampionshipModel extends ChampionshipModelParent {
  MatchesAndStandings matchesStandings;
  ChampionshipModel({
    required super.assetAnthem,
    required super.assetLogo,
    required super.pathId,
    required super.title,
    required super.color,
    required super.colorText,
    required this.matchesStandings,
  });
}

class ChampionshipModelParent {
  String title;
  String assetAnthem;
  String assetLogo;
  String pathId;
  Color color;
  Color colorText;
  ChampionshipModelParent({
    required this.assetAnthem,
    required this.assetLogo,
    required this.pathId,
    required this.title,
    required this.color,
    required this.colorText,
  });
}

class HomeScreen extends StatelessWidget {
  const HomeScreen(this.competitions, {super.key});
  final ElBotolaChampionsList competitions;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('El Botola Max'),
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: competitions.competitions
            .map(
              (e) => Card(
                // color: e.color,
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Image.network(e.emblem),
                      Text(
                        e.name,
                        // style: TextStyle(color: e.colorText),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  List<ChampionshipModelParent> get gcompetitions {
    return [
      ChampionshipModelParent(
        title: 'Champions League',
        assetAnthem: 'assets/anthems/',
        assetLogo: 'assets/logos/',
        color: primaryColor,
        pathId: 'CL',
        colorText: Colors.white,
      ),
      ChampionshipModelParent(
        title: 'Premier League',
        assetAnthem: 'assets/anthems/',
        assetLogo: 'assets/logos/',
        color: Colors.purple,
        pathId: 'PL',
        colorText: Colors.white,
      ),
      ChampionshipModelParent(
        title: 'LaLiga',
        assetAnthem: 'assets/anthems/',
        assetLogo: 'assets/logos/',
        color: Colors.pink,
        pathId: 'PD',
        colorText: Colors.white,
      ),
      ChampionshipModelParent(
        title: 'BUNDESLIGA',
        assetAnthem: 'assets/anthems/',
        assetLogo: 'assets/logos/',
        color: Colors.red,
        pathId: 'BL',
        colorText: Colors.white,
      ),
      ChampionshipModelParent(
        title: 'Ligue 1',
        assetAnthem: 'assets/anthems/',
        assetLogo: 'assets/logos/',
        color: Colors.amber,
        pathId: '',
        colorText: Colors.black45,
      ),
      ChampionshipModelParent(
        title: 'SERIE A',
        assetAnthem: 'assets/anthems/',
        assetLogo: 'assets/logos/',
        color: Colors.green,
        pathId: '',
        colorText: Colors.black45,
      ),
    ];
  }
}
