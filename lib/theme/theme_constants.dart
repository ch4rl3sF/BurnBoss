import 'package:flutter/material.dart';

const COLOR_PRIMARY = Color(0xffFF2c14);
const COLOR_SECONDARY = Color(0xffDD2C00);
const DARK_COLOR_PRIMARY = Color(0xff14e7ff);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: COLOR_PRIMARY,
  useMaterial3: true,
  appBarTheme: const AppBarTheme(color: COLOR_PRIMARY),
  cardTheme: CardTheme(color: COLOR_PRIMARY),
  iconTheme: IconThemeData(color: Colors.black),
  tabBarTheme:
      TabBarTheme(labelColor: Colors.black, unselectedLabelColor: Colors.white),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: COLOR_PRIMARY),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.black,
      side: BorderSide(width: 0.5, color: Colors.black12),
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xff1DE6C9),
  iconTheme: IconThemeData(color: Colors.white),
  useMaterial3: true,
  tabBarTheme:
      TabBarTheme(labelColor: Colors.black, unselectedLabelColor: Colors.white),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black, backgroundColor: DARK_COLOR_PRIMARY),
  ),
);
