import 'package:burnboss/models/user.dart';
import 'package:burnboss/theme/theme_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:burnboss/services/auth.dart';

import '../services/database.dart';
import 'dart:typed_data';

class NavDrawerWidget extends StatefulWidget {
  final String currentRoute;

  const NavDrawerWidget({Key? key, required this.currentRoute})
      : super(key: key);

  @override
  State<NavDrawerWidget> createState() => _NavDrawerWidgetState();
}

class _NavDrawerWidgetState extends State<NavDrawerWidget> {
  CustomUser? customUser;
  Uint8List? _profilePic;

  @override
  void initState() {
    super.initState();
    loadUserData();
    _loadProfilePic();
  }

  Future<void> loadUserData() async {
    CustomUser? user =
        await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .getUserData();
    if (user != null) {
      setState(() {
        customUser = user;
      });
    }
  }

  Future<void> _loadProfilePic() async {
    Uint8List? image =
        await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .getProfilePic();
    if (image != null) {
      setState(() {
        _profilePic = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the current theme
    ThemeData theme = Theme.of(context);

    // Determine if the theme is light
    bool isLightTheme = theme.brightness == Brightness.light;

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                color: isLightTheme ? COLOR_SECONDARY : DARK_COLOR_PRIMARY),
            accountName: Text(customUser?.username ?? 'Loading...'),
            accountEmail: Text(
              customUser?.email ?? 'Loading',
              style:
                  TextStyle(color: isLightTheme ? Colors.white : Colors.black),
            ),
            currentAccountPicture: _profilePic != null
                ? CircleAvatar(
                    radius: 44,
                    backgroundImage: MemoryImage(_profilePic!),
                  )
                : const CircleAvatar(
                    radius: 44,
                    backgroundImage:
                        AssetImage('assets/images/defaultProfilePicture.png'),
                  ),
          ),
          buildNavBarItem(
              label: 'Home',
              featureIcon: Icons.home_filled,
              isSelected: widget.currentRoute == '/',
              action: () {
                Navigator.pushNamed(context, '/');
              }),
          buildNavBarItem(
              label: 'Creator',
              featureIcon: Icons.add,
              isSelected: widget.currentRoute == '/Creator',
              action: () {
                Navigator.pushNamed(context, '/Creator');
              }),
          buildNavBarItem(
              label: 'Select',
              featureIcon: Icons.play_arrow_outlined,
              isSelected: widget.currentRoute == '/Select',
              action: () {
                Navigator.pushNamed(context, '/Select');
              }),
          buildNavBarItem(
              label: 'Calendar',
              featureIcon: Icons.calendar_month_outlined,
              isSelected: widget.currentRoute == '/Calendar',
              action: () {
                Navigator.pushNamed(context, '/Calendar');
              }),
          buildNavBarItem(
              label: 'Stopwatch',
              featureIcon: Icons.alarm,
              isSelected: widget.currentRoute == '/Stopwatch',
              action: () {
                Navigator.pushNamed(context, '/Stopwatch');
              }),
          const Divider(
            thickness: 1,
            color: Colors.grey,
            indent: 20,
            endIndent: 20,
          ),
          buildNavBarItem(
              label: 'Settings',
              featureIcon: Icons.settings_outlined,
              isSelected: widget.currentRoute == '/Settings',
              action: () {
                Navigator.pushNamed(context, '/Settings');
              }),
          SizedBox(
            height: 20,
          ),
          InkWell(
            borderRadius: BorderRadius.circular(500),
            onTap: () {
              Navigator.of(context).pop();
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor:
                  isLightTheme ? COLOR_SECONDARY : DARK_COLOR_PRIMARY,
              child: CircleAvatar(
                radius: 19,
                backgroundColor: Color(0xff292929),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildNavBarItem({
    required String label,
    required IconData featureIcon,
    required GestureTapCallback action,
    bool isSelected = false,
  }) {
    return ListTile(
      leading: Icon(
        featureIcon,
        size: 30,
        color: isSelected ? Colors.grey : null,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          color: isSelected ? Colors.grey : null,
        ),
      ),
      onTap: isSelected ? null : action,
    );
  }
}
