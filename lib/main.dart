import 'package:burnboss/screens/Calendar.dart';
import 'package:burnboss/screens/Creator.dart';
import 'package:burnboss/screens/Select.dart';
import 'package:burnboss/screens/Settings.dart';
import 'package:burnboss/Wrapper.dart';
import 'package:burnboss/models/user.dart';
import 'package:burnboss/screens/Stopwatch_page.dart';
import 'package:burnboss/services/auth.dart';
import 'package:burnboss/theme/theme_constants.dart';
import 'package:burnboss/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const BurnBoss());
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: Colors.black,
  // ));
}

class BurnBoss extends StatefulWidget {
  const BurnBoss({super.key});

  @override
  State<StatefulWidget> createState() => _BurnBossState();
}

class _BurnBossState extends State<BurnBoss> {
  final ThemeManager _themeManager = ThemeManager();
  final AuthService authService = AuthService();
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
          '/': (context) => const Wrapper(),
          '/Calendar': (context) => const CalendarPage(),
          '/Creator': (context) => const CreatePage(),
          '/Select': (context) => const SelectPage(),
          '/Stopwatch': (context) => StopwatchPage(),
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
    initializeTheme();
    themeIsDark = _themeManager.themeModeIsDark;
    _themeManager.addListener(themeChangeListener);
  } //adds the listener for changing theme function

  Future<void> initializeTheme() async {
    await _themeManager.initializeTheme();
    setState(() {
      themeIsDark = _themeManager.themeModeIsDark;
    });
  }

  themeChangeListener() {
    if (mounted) {
      setState(() {
        print(
            "themeListener called"); //shows that the function behind the switch is called
        themeIsDark = _themeManager.themeModeIsDark; //changes the theme

      });
    }
  }
}
