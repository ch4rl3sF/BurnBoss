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
import 'package:http/http.dart' as http;

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
  CustomUser? customUser;
  bool usernameUpdated = false;
  bool emailUpdated = false;
  bool profilePicUpdated = false;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _profilePic = img;
    });
  }

  void saveImage() async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).saveProfilePic(file: _profilePic!);
  }

  void _updateProfilePic(Uint8List newPic) {
    setState(() {
      _profilePic = newPic;
    });
  }

  void _updateUsername(String newUsername) {
    setState(() {
      customUser?.username = newUsername;
      usernameController.text = newUsername;
      CustomUser(uid: FirebaseAuth.instance.currentUser!.uid)
          .updateUsername(newUsername);
    });
  }

  void _updateEmail(String newEmail) {
    if (customUser != null) {
      customUser!.updateEmail(newEmail).then((_) {
        setState(() {
          customUser?.email = newEmail;
          emailController.text = newEmail;
          CustomUser(uid: FirebaseAuth.instance.currentUser!.uid)
              .updateEmail(newEmail);
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadProfilePic();
  }

  Future<void> _loadUserData() async {
    CustomUser? user =
        await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .getUserData();
    if (user != null) {
      setState(() {
        customUser = user;
        usernameController.text = user.username!;
        emailController.text = user.email!;
      });
    }
  }

  Future<void> _loadProfilePic() async {
    Uint8List? image = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getProfilePic();
    if (image != null) {
      setState(() {
        _profilePic = image;
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
                        backgroundImage: AssetImage(
                            'assets/images/defaultProfilePicture.png'),
                      ),
              ),
              title: Text(customUser?.username ?? 'Loading...'),
              subtitle: Text('${customUser?.email ?? 'Loading...'}'),
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
                              height: 250,
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      _profilePic != null
                                          ? CircleAvatar(
                                              radius: 44,
                                              backgroundImage:
                                                  MemoryImage(_profilePic!),
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
                                          onPressed: () async {
                                            Uint8List img = await pickImage(
                                                ImageSource.gallery);
                                            setState(() {
                                              _updateProfilePic(img);
                                              profilePicUpdated = true;
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
                                    onChanged: (username) {
                                      if (usernameController.text.isNotEmpty) {
                                        setState(() {
                                          usernameUpdated = true;
                                        });
                                      }
                                    },
                                  ),
                                  SizedBox(height: 15),
                                  TextFormField(
                                    controller: emailController,
                                    decoration: const InputDecoration(
                                      hintText: 'Email',
                                      contentPadding: EdgeInsets.all(10),
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (email) {
                                      if (emailController.text.isNotEmpty) {
                                        setState(() {
                                          emailUpdated = true;
                                        });
                                      }
                                    },
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
                                  if (usernameUpdated == true) {
                                    _updateUsername(usernameController.text);
                                  }
                                  if (emailUpdated == true) {
                                    _updateEmail(emailController.text);
                                  }
                                  if (profilePicUpdated == true) {
                                    saveImage();
                                    print('button working');
                                  }
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
            SizedBox(
              height: 25,
            ),
            TextButton.icon(
              icon: Icon(
                Icons.delete_rounded,
                color: isLightTheme ? COLOR_PRIMARY : DARK_COLOR_PRIMARY,
              ),
              label: Text(
                'Delete account',
                style: TextStyle(
                    color: isLightTheme ? COLOR_PRIMARY : DARK_COLOR_PRIMARY),
              ),
              onPressed: () async {
                await _auth.deleteAccount();
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
