import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreboardService {
  static const _kKey = 'scores_v1';

  Future<List<Map<String, dynamic>>> getScores() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_kKey);
    if (raw == null) return [];
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    list.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    return list;
  }

  Future<void> addScore({required String player, required int score}) async {
    final p = await SharedPreferences.getInstance();
    final list = await getScores();
    list.add({'player': player, 'score': score, 'ts': DateTime.now().toIso8601String()});
    await p.setString(_kKey, jsonEncode(list));
  }

  Future<void> reset() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kKey);
  }
}
