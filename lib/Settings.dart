import 'package:burnboss/services/auth.dart';
import 'package:burnboss/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'NavDrawer.dart';

class SettingsPage extends StatefulWidget {
  ThemeManager themeManager;

  SettingsPage(this.themeManager, {Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: Builder(
          builder: (context) => IconButton(
            padding: EdgeInsets.fromLTRB(20.0, 0, 0, 0),
            icon: Icon(Icons.menu_rounded, size: 30),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Column(children: [
        Switch(
            value: widget.themeManager.themeModeIsDark,
            onChanged: (bool switchIsOn) {
              setState(() {
                print(
                    'Switch changed to $switchIsOn'); //show that the switch is turned on
                widget.themeManager.setThemeToDark(
                    switchIsOn); //when the switch is on, change the theme to dark
              });
            }),
        TextButton.icon(
          icon: Icon(Icons.person),
          label: Text('Sign Out'),
          onPressed: () async {
            await _auth.signOut();
            Navigator.pushNamed(context, '/');
          },
        ),
      ]),
      drawer: NavDrawerWidget(),
    );
  }
}
