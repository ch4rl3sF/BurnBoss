import 'dart:typed_data';

import 'package:burnboss/services/auth.dart';
import 'package:burnboss/services/database.dart';
import 'package:burnboss/services/imagePicker.dart';
import 'package:burnboss/theme/theme_constants.dart';
import 'package:burnboss/theme/theme_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:burnboss/screens/NavDrawer.dart';
import 'package:image_picker/image_picker.dart';

class SettingsPage extends StatefulWidget {
  final ThemeManager themeManager;

  const SettingsPage(this.themeManager, {super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService _auth = AuthService();
  Uint8List? _profilePic;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _profilePic = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access the current theme
    ThemeData theme = Theme.of(context);

    // Determine if the theme is light
    bool isLightTheme = theme.brightness == Brightness.light;
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
            padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
            icon: const Icon(Icons.menu_rounded, size: 30),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          height: 10,
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Text(
            'Theme:',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sunny),
            const SizedBox(
              width: 20,
            ),
            Switch(
              value: widget.themeManager.themeModeIsDark,
              activeColor: DARK_COLOR_PRIMARY,
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
            const SizedBox(
              width: 20,
            ),
            const Icon(Icons.nightlight)
          ],
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
          child: Divider(
            thickness: 1,
            color: Colors.grey,
            indent: 20,
            endIndent: 20,
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Text(
            'Account:',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Stack(
                  children: [
                    _profilePic != null
                        ? CircleAvatar(
                            radius: 44,
                            backgroundImage: MemoryImage(_profilePic!),
                          )
                        : const CircleAvatar(
                            radius: 44,
                            backgroundImage: AssetImage(
                                'assets/images/defaultProfilePicture.png'),
                          ),
                    Positioned(
                      bottom: -5,
                      left: 45,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  icon: Icon(
                    Icons.person,
                    color: isLightTheme ? COLOR_PRIMARY : DARK_COLOR_PRIMARY,
                  ),
                  label: Text(
                    'Sign Out',
                    style: TextStyle(
                        color:
                            isLightTheme ? COLOR_PRIMARY : DARK_COLOR_PRIMARY),
                  ),
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.pushReplacementNamed(context, '/');
                  },
                ),
              ],
            ),
          ),
        ),
      ]),
      drawer: const NavDrawerWidget(currentRoute: '/Settings'),
    );
  }
}
