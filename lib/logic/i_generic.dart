import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:botola_max/lib.dart';

enum IGenricEnry {
  datetime,
  value,
}

class IGenericAppMap<T extends IGenericAppModel> {
  final DateTime dateTime;
  final T? value;
  IGenericAppMap({
    required this.dateTime,
    this.value,
  });
  static IGenericAppMap<T> fromJson<T extends IGenericAppModel>(Map<String, Object?> map) {
    IGenericAppMap<T> iGenericAppMap = IGenericAppMap<T>(
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        map[IGenricEnry.datetime.name] as int,
      ),
      value: IGenericAppModel.fromJson<T>(
        map[IGenricEnry.value.name] as Map<String, Object?>,
      ) as T?,
    );
    return iGenericAppMap;
  }
}

abstract class IGenericAppModel {
  Future<void> save(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String textSaved = PowerJSON(
      <String, Object?>{
        IGenricEnry.datetime.name: DateTime.now().millisecondsSinceEpoch,
        IGenricEnry.value.name: toJson(),
      },
    ).toText();
    await prefs.setString(name, textSaved);
  }

  Map<String, Object?> toJson();

  static IGenericAppModel? fromJson<T extends IGenericAppModel>(Map<String, Object?> json) {
    if (T == ElBotolaChampionsList) return ElBotolaChampionsList.fromJson(json);
    if (T == MapCompetitions) return MapCompetitions.fromJson(json);
    if (T == MatchDetailsModel) return MatchDetailsModel.fromJson(json);
    if (T == MatchHead2HeadModel) return MatchHead2HeadModel.fromJson(json);
    if (T == DataCompetition) return DataCompetition.fromJson(json);
    if (T == BotolaHappening) return BotolaHappening.fromJson(json);
    if (T == Settings) return Settings.fromJson(json);
    if (T == Teams) return Teams.fromJson(json);
    if (T == BotolaXPerson) return BotolaXPerson.fromJson(json);
    return null;
  }

  static Future<IGenericAppMap<T>?> load<T extends IGenericAppModel>(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? string = prefs.getString(name);
    if (string == null) return null;
    logg(string.toString(), name: 'IGERNERIC LOAD');
    Map<String, Object?> json = jsonDecode(string);
    return IGenericAppMap.fromJson<T>(json);
  }

  static Future<void> clear<T extends IGenericAppModel>(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool string = await prefs.remove(name);
    if (string) return;
  }

  static Future<Set<String>> keys() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getKeys();
  }

  static Future<void> clearAll() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }
}
