import 'package:flutter/material.dart';

import '../services/database.dart';

class  ThemeManager with ChangeNotifier {
  bool? themeValue = DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getTheme();

  ThemeMode _themeMode = themeValue ? ThemeMode.light : ThemeMode.dark; //set the themeMode to light as default

  get themeMode => _themeMode;

  setThemeToDark(bool isDark) {
    print(
        "Theme mode toggled to ${isDark ? "dark" : "light"}"); //shows if the theme mode is dark or light
    _themeMode = isDark
        ? ThemeMode.dark
        : ThemeMode
            .light; //if the themeMode is changed to dark through the switch,
    // make the themeMode dark, else make it light
    notifyListeners();
  }

  get themeModeIsDark => _themeMode == ThemeMode.dark;
}
