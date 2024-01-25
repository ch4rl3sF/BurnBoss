import 'package:burnboss/services/auth.dart';
import 'package:burnboss/services/database.dart';
import 'package:burnboss/theme/theme_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:burnboss/screens/NavDrawer.dart';

class SettingsPage extends StatefulWidget {
  final ThemeManager themeManager;

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
        centerTitle: true,
        // backgroundColor: Color(0xff292929),
        toolbarHeight: 125,
        title: const Text(
          'Select',
          style: TextStyle(
            fontSize: 55,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            fontFamily: 'Bebas',
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            padding: EdgeInsets.fromLTRB(20.0, 0, 0, 0),
            icon: Icon(Icons.menu_rounded, size: 30),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Text(
            'Theme:',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sunny),
            SizedBox(
              width: 20,
            ),
            Switch(
              value: widget.themeManager.themeModeIsDark,
              onChanged: (bool switchIsOn) {
                setState(
                  () {
                    print(
                        'Switch changed to $switchIsOn'); //show that the switch is turned on
                    widget.themeManager.setThemeToDark(
                        switchIsOn); //when the switch is on, change the theme to dark
                    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                        .updateTheme(!switchIsOn);
                  },
                );
              },
            ),
            SizedBox(
              width: 20,
            ),
            Icon(Icons.nightlight)
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
          child: const Divider(
            thickness: 1,
            color: Colors.grey,
            indent: 20,
            endIndent: 20,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Text(
            'Account:',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              TextButton.icon(
                icon: Icon(Icons.person),
                label: Text('Sign Out'),
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.pushNamed(context, '/');
                },
              ),
            ],
          ),
        ),
      ]),
      drawer: NavDrawerWidget(currentRoute: '/Settings'),
    );
  }
}
