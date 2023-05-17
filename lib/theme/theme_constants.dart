import 'package:flutter/material.dart';

const COLOR_PRIMARY = Colors.deepOrangeAccent;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: COLOR_PRIMARY,
  useMaterial3: true,

);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
);
