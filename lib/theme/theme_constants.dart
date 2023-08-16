import 'package:flutter/material.dart';

const COLOR_PRIMARY = Color(0xffFF2c14);
const COLOR_SECONDARY = Color(0xffFF2c14);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: COLOR_PRIMARY,
  useMaterial3: true,
  appBarTheme: const AppBarTheme(color: COLOR_SECONDARY),
  cardTheme: CardTheme(color: COLOR_SECONDARY),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.blue,
  useMaterial3: true,
);
