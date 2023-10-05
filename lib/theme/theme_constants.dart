import 'package:flutter/material.dart';

const COLOR_PRIMARY = Color(0xffFF2c14);
const COLOR_SECONDARY = Color(0xffFF2c14);
const DARK_COLOR_PRIMARY = Color(0xff1DE6C9);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: COLOR_PRIMARY,
  useMaterial3: true,
  appBarTheme: const AppBarTheme(color: COLOR_SECONDARY),
  cardTheme: CardTheme(color: COLOR_SECONDARY),
  iconTheme: IconThemeData(color: Colors.black),
  tabBarTheme:
      TabBarTheme(labelColor: Colors.black, unselectedLabelColor: Colors.white),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        primary: COLOR_PRIMARY, onPrimary: Colors.white),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      primary: Colors.black,
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
);
