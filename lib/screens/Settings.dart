import 'dart:typed_data';
import 'package:burnboss/models/user.dart';
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

  SettingsPage(this.themeManager, {Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService _auth = AuthService();
  Uint8List? _profilePic;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? username;
  String? email;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _profilePic = img;
    });
  }

  void _updateProfilePic(Uint8List newPic) {
    setState(() {
      _profilePic = newPic;
    });
  }

  void _updateUsername(String newUsername) {
    setState(() {
      username = newUsername;
    });
  }

  void _updateEmail(String newEmail) {
    setState(() {
      email = newEmail;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    CustomUser? user = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserData();
    if (user != null) {
      setState(() {
        username = user.username;
        email = user.email;
        usernameController.text = user.username!;
        emailController.text = user.email!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isLightTheme = theme.brightness == Brightness.light;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 125,
        title: const Text(
          'Settings',
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
        SizedBox(height: 10),
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
            SizedBox(width: 20),
            Switch(
              value: widget.themeManager.themeModeIsDark,
              activeColor: DARK_COLOR_PRIMARY,
              onChanged: (bool switchIsOn) {
                setState(
                      () {
                    print('Switch changed to $switchIsOn');
                    widget.themeManager.setThemeToDark(switchIsOn);
                    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                        .updateTheme(!switchIsOn);
                  },
                );
              },
            ),
            SizedBox(width: 20),
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
        Column(
          children: [
            ListTile(
              leading: SizedBox(
                height: 88,
                width: 88,
                child: _profilePic != null
                    ? CircleAvatar(
                  radius: 44,
                  backgroundImage: MemoryImage(_profilePic!),
                )
                    : const CircleAvatar(
                  radius: 44,
                  backgroundImage: AssetImage('assets/images/defaultProfilePicture.png'),
                ),
              ),
              title: Text(username ?? 'Loading...'),
              subtitle: Text('Email: ${email ?? 'Loading...'}'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return AlertDialog(
                            title: Text('Edit details'),
                            content: SizedBox(
                              height: 200,
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
                                        backgroundImage: AssetImage('assets/images/defaultProfilePicture.png'),
                                      ),
                                      Positioned(
                                        bottom: -5,
                                        left: 45,
                                        child: IconButton(
                                          onPressed: () async {
                                            Uint8List img = await pickImage(ImageSource.gallery);
                                            setState(() {
                                              _updateProfilePic(img);
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.add_a_photo,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 25),
                                  TextFormField(
                                    controller: usernameController,
                                    decoration: const InputDecoration(
                                      hintText: 'Username',
                                      contentPadding: EdgeInsets.all(10),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: emailController,
                                    decoration: const InputDecoration(
                                      hintText: 'Email',
                                      contentPadding: EdgeInsets.all(10),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Save'),
                                onPressed: () {
                                  _updateUsername(usernameController.text);
                                  _updateEmail(emailController.text);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            TextButton.icon(
              icon: Icon(
                Icons.person,
                color: isLightTheme ? COLOR_PRIMARY : DARK_COLOR_PRIMARY,
              ),
              label: Text(
                'Sign Out',
                style: TextStyle(
                    color: isLightTheme ? COLOR_PRIMARY : DARK_COLOR_PRIMARY),
              ),
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ]),
      drawer: NavDrawerWidget(currentRoute: '/Settings'),
    );
  }
}
