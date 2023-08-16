import 'package:burnboss/Calendar.dart';
import 'package:burnboss/Creator.dart';
import 'package:burnboss/Home.dart';
import 'package:burnboss/Select.dart';
import 'package:burnboss/Settings.dart';
import 'package:burnboss/Wrapper.dart';
import 'package:burnboss/models/user.dart';
import 'package:burnboss/services/auth.dart';
import 'package:burnboss/theme/theme_constants.dart';
import 'package:burnboss/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(BurnBoss());
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: Colors.black,
  // ));
}

class BurnBoss extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BurnBossState();
}

class _BurnBossState extends State<BurnBoss> {
  final ThemeManager _themeManager = ThemeManager();
  late bool themeIsDark;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<customUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BurnBoss',
        theme: lightTheme,
        //sets the default light theme to the created lightTheme
        darkTheme: darkTheme,
        //does the same for darkTheme
        themeMode: _themeManager.themeMode,
        //sets default themeMode to the created themeMode
        initialRoute: '/',
        //sets the initial page to be this home page
        routes: {
          '/': (context) => Wrapper(),
          '/Calendar': (context) => CalendarPage(),
          '/Creator': (context) => CreatePage(),
          '/Select': (context) => SelectPage(),
          '/Settings': (context) => SettingsPage(_themeManager),
        }, //sets the routes to the different pages
      ),
    );
  }

  @override
  void dispose() {
    _themeManager.removeListener(themeChangeListener);
    super.dispose();
  } //removes the listener for changing theme once the function is done

  @override
  void initState() {
    super.initState();
    themeIsDark = _themeManager.themeModeIsDark;
    _themeManager.addListener(themeChangeListener);
  } //adds the listener for changing theme function

  themeChangeListener() {
    if (mounted) {
      setState(() {
        print(
            "themeListener called"); //shows that the function behind the switch is called
        themeIsDark = _themeManager.themeModeIsDark; //changes the theme to dark
      });
    }
  }
}
