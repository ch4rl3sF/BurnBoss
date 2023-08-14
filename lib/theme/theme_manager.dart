import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier{

  ThemeMode _themeMode = ThemeMode.light; //set the themeMode to light as default

  get themeMode => _themeMode;

  setThemeToDark(bool isDark){
    print("Theme mode toggled to ${isDark? "dark":"light"}"); //shows if the theme mode is dark or light
    _themeMode = isDark?ThemeMode.dark:ThemeMode.light; //if the themeMode is changed to dark through the switch,
                                                        // make the themeMode dark, else make it light
    notifyListeners();
  }

  get themeModeIsDark => _themeMode == ThemeMode.dark;
}