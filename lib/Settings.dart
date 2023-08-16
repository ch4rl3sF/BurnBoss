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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: [
          Switch(
              value: widget.themeManager.themeModeIsDark,
              onChanged: (bool switchIsOn) {
                setState(() {
                  print(
                      'Switch changed to $switchIsOn'); //show that the switch is turned on
                  widget.themeManager.setThemeToDark(
                      switchIsOn); //when the switch is on, change the theme to dark
                });
              })
        ],
      ),
      body: Container(
        child: Text('Settings'),
      ),
      drawer: NavDrawerWidget(),
    );
  }
}
