import 'package:burnboss/Calendar.dart';
import 'package:burnboss/Editor.dart';
import 'package:burnboss/theme/theme_constants.dart';
import 'package:burnboss/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'NavDrawer.dart';

void main() {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BurnBoss',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeManager.themeMode,
      home: Home(_themeManager),
    );
  }

  @override
  void dispose() {
    _themeManager.removeListener(themeChangeListener);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    themeIsDark = _themeManager.themeModeIsDark;
    _themeManager.addListener(themeChangeListener);
  }

  themeChangeListener() {
    if (mounted) {
      setState(() {
        print("themeListener called");
        themeIsDark = _themeManager.themeModeIsDark;
      });
    }
  }
}

class Home extends StatefulWidget {
  ThemeManager themeManager;

  Home(this.themeManager, {Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //
  // @override
  // void dispose() {
  //   widget.themeManager.removeListener(themeListener);
  //   super.dispose();
  // }
  //
  // @override
  // void initState() {
  //   _themeManager.addListener(themeListener);
  //   super.initState();
  // }
  //
  // themeListener() {
  //   if (mounted) {
  //     setState(() {
  //       print("themeListener called");
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff121212),
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: Color(0xff292929),
        toolbarHeight: 125,
        title: const Text(
          'BurnBoss',
          style: TextStyle(
            fontSize: 55,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            fontFamily: 'Bebas',
          ),
        ),
        actions: [
          Switch(
              value: widget.themeManager.themeModeIsDark,
              onChanged: (bool switchIsOn) {
                setState(() {
                  print('Switch changed to $switchIsOn');
                  widget.themeManager.setThemeToDark(switchIsOn);
                });
              })
        ],
        leading: Builder(
          builder: (context) => IconButton(
            padding: EdgeInsets.fromLTRB(20.0, 0, 0, 0),
            color: Color(0xffFF2c14),
            icon: Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: NavDrawerWidget(),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 70.0),
          child: Column(
            children: [
              SizedBox(
                height: 315,
                width: 300,
                child: GridView.count(
                  mainAxisSpacing: 30,
                  crossAxisSpacing: 30,
                  crossAxisCount: 2,
                  primary: false,
                  children: [
                    buildCard(
                        pageIcon: Icons.mouse_outlined,
                        label: 'Select',
                        action: () {
                          print('Player button pressed');
                        }),
                    buildCard(
                        pageIcon: Icons.edit,
                        label: 'Editor',
                        action: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => EditorPage()));
                        }),
                    buildCard(
                        pageIcon: Icons.calendar_month,
                        label: 'Calendar',
                        action: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const CalendarPage()));
                        }),
                    buildCard(
                        pageIcon: Icons.access_alarm,
                        label: 'Stopwatch',
                        action: () {
                          print('Stopwatch button pressed');
                        }),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              buildCard(
                  pageIcon: Icons.accessible_forward,
                  label: 'Go!',
                  action: () {
                    print('Go button pressed');
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard({
    required IconData pageIcon,
    required String label,
    required GestureTapCallback action,
  }) {
    return Card(
      // color: Color(0xff292929),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey, width: 0.5)),
      child: InkWell(
        onTap: action,
        child: SizedBox(
          width: 200,
          height: 125,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  pageIcon,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  label,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
