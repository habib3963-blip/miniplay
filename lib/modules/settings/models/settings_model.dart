import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends ChangeNotifier {
  static const _kDark = 'darkMode';
  static const _kSound = 'soundOn';

  bool darkMode;
  bool soundOn;

  SettingsModel({required this.darkMode, required this.soundOn});

  static Future<SettingsModel> load() async {
    final p = await SharedPreferences.getInstance();
    return SettingsModel(
      darkMode: p.getBool(_kDark) ?? false,
      soundOn: p.getBool(_kSound) ?? true,
    );
    // call notifyListeners() not required here (initial)
  }

  Future<void> setDarkMode(bool v) async {
    darkMode = v;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kDark, v);
  }

  Future<void> setSoundOn(bool v) async {
    soundOn = v;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kSound, v);
  }
}
