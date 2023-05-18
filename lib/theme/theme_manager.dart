import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier{

  ThemeMode _themeMode = ThemeMode.light;

  get themeMode => _themeMode;

  setThemeToDark(bool isDark){
    print("Theme mode toggled to ${isDark? "dark":"light"}");
    _themeMode = isDark?ThemeMode.dark:ThemeMode.light;
    notifyListeners();
  }

  get themeModeIsDark => _themeMode == ThemeMode.dark;
}