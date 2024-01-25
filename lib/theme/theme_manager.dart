import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/database.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeManager() {
    initializeTheme();
  }

  Future<void> initializeTheme() async {
    bool? isLightTheme = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getTheme();
    if (isLightTheme != null) {
      _themeMode = isLightTheme ? ThemeMode.light : ThemeMode.dark;
    }
  }

  get themeMode => _themeMode;

  setThemeToDark(bool isDark) {
    print("Theme mode toggled to ${isDark ? "dark" : "light"}");
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  get themeModeIsDark => _themeMode == ThemeMode.dark;
}
