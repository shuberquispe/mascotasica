import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  final SharedPreferences _prefs;
  static const String _themeKey = 'theme_mode';

  ThemeService(this._prefs);

  ThemeMode get themeMode {
    final themeValue = _prefs.getString(_themeKey);
    if (themeValue == 'dark') {
      return ThemeMode.dark;
    } else if (themeValue == 'light') {
      return ThemeMode.light;
    } else {
      return ThemeMode.system;
    }
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void setThemeMode(ThemeMode mode) {
    String themeValue;
    
    if (mode == ThemeMode.dark) {
      themeValue = 'dark';
    } else if (mode == ThemeMode.light) {
      themeValue = 'light';
    } else {
      themeValue = 'system';
    }
    
    _prefs.setString(_themeKey, themeValue);
    notifyListeners();
  }

  void toggleTheme() {
    if (themeMode == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.dark);
    }
  }
}
