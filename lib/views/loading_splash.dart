import 'dart:async';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:botola_max/lib.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

Future<int> _delayed(int input) {
  return Future.delayed(Duration(milliseconds: 500), () => input);
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double progress = 0;
  bool initializing = true;

  @override
  void initState() {
    nextScreen().then((_) => null);
    super.initState();
  }

  Future<void> forEachList<T>(
    Iterable<T> elements,
    FutureOr<void> Function(T item) action,
    int percent,
  ) async {
    await Future.forEach(elements, (item) async {
      await action(item);
      _progressPlus(totale: elements.length, percent: percent);
    });
  }

  Future<void> listLabels(FutureOr<bool> Function() e) async => await e();
// //

  Future<void> callApi() async {
    ElBotolaChampionsList? competitions = await AppLogic.getCompetitions();
    if (competitions == null) return;
    _progressPlus(totale: 1, percent: kDebugMode ? 5 : 25);
    BotolaHappening? today = await AppLogic.getTodayMatches(competitions.competitions.map((e) => e.id));
    if (today == null) return;
    _progressPlus(totale: 1, percent: kDebugMode ? 5 : 25);
    List<String> emblems = competitions.competitions.map((e) => e.emblem).toList();
    List<String> areas = competitions.competitions.map((e) => e.area.flag).whereNotNull().toList();
    List<String> tcrests = [
      ...today.matches.map((e) => [e.homeTeam.crest, e.awayTeam.crest]).expand((_) => _)
    ];
    List<String> imageUrls = [...emblems, ...tcrests, ...areas];
    FallBackMap fallBackAndMap = await SharedPrefsDatabase.updateLocalCrests(imageUrls);
    _progressPlus(totale: 1, percent: kDebugMode ? 5 : 25);
    Map<String, String> allFileCrests = fallBackAndMap.map;
    Map<String, DataCompetition> compts = await SharedPrefsDatabase.getAvailableCompetitions(fallBackAndMap.availableIds);
    _progressPlus(totale: 1, percent: kDebugMode ? 5 : 25);
    await forEachList(List.generate(10, (i) => i), (e) async => await _delayed(e), kDebugMode ? 80 : 0);
    logg('✔ ✔ ✔ ✔');
    if (!mounted) return;
    context.read<AppState>().setData = compts;
    context.read<AppState>().setMapCrests = allFileCrests;
    Future.delayed(d, () => Get.offAll(() => HomeScreen(competitions, today)));
  }

  void _progressPlus({required int totale, required int percent}) {
    progress += (1 / totale) * percent;
    setState(() {});
  }

  Future<void> nextScreen() async {
    initializing = false;
    progress = 0;
    setState(() {});

    await callApi();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: ScaffoldBuilder(
          backgroundColor: Color(0xff18282f),
          body: Stack(
            children: [
              Center(
                child: Container(
                  width: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/logo-animated.gif'),
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Loading"),
                      SizedBox(height: 12),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.5,
                        child: LinearProgressIndicator(value: progress / 100),
                      ),
                      SizedBox(height: 8),
                      initializing
                          ? Text('...')
                          : AnimatedFlipCounter(
                              value: progress,
                              fractionDigits: 0,
                              suffix: " %",
                              textStyle: TextStyle(fontSize: 14),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const Duration d = Duration(milliseconds: 300);

class DataRuntimeFunction<T> {
  Duration runtime;
  T data;
  DataRuntimeFunction({
    required this.runtime,
    required this.data,
  });
}

Future<DataRuntimeFunction> measureFunctionRuntime<T>(FutureOr<T> Function() function) async {
  final stopwatch = Stopwatch()..start();
  T data = await function();
  stopwatch.stop();
  logg((stopwatch.elapsed.inMilliseconds / 1000).toStringAsFixed(2).padLeft(5, '0'));
  return DataRuntimeFunction(runtime: stopwatch.elapsed, data: data);
}

class ProgressData {
  String title;
  Future<bool> Function() dataCall;
  ProgressData(this.dataCall, this.title);
}
