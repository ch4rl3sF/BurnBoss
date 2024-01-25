import 'package:burnboss/models/user.dart';
import 'package:burnboss/theme/theme_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:burnboss/services/auth.dart';

class NavDrawerWidget extends StatelessWidget {
  final String currentRoute;
  const NavDrawerWidget({Key? key, required this.currentRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the current theme
    ThemeData theme = Theme.of(context);

    // Determine if the theme is light
    bool isLightTheme = theme.brightness == Brightness.light;

    var email = FirebaseAuth.instance.currentUser!.email.toString();

    //function to trim the email to before the @ symbol to use as the username
    Future<String> _getUsername() async {
      var email = FirebaseAuth.instance.currentUser!.email.toString();
      var username = email.split('@')[0];
      return username;
    }

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                color: isLightTheme ? COLOR_SECONDARY : DARK_COLOR_PRIMARY),
            accountName: FutureBuilder<String>(
              future: _getUsername(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data == null) {
                  return Text('Guest');
                } else {
                  return Text(
                    snapshot.data ?? 'No Username',
                    style: TextStyle(
                      color: isLightTheme ? Colors.white : Colors.black,
                    ),
                  );
                }
              },
            ),
            accountEmail: Text(
              email,
              style:
                  TextStyle(color: isLightTheme ? Colors.white : Colors.black),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  AssetImage('assets/images/defaultProfilePicture.png'),
            ),
          ),
          buildNavBarItem(
              label: 'Home',
              featureIcon: Icons.home_filled,
              isSelected: currentRoute == '/',
              action: () {
                Navigator.pushNamed(context, '/');
              }),
          buildNavBarItem(
              label: 'Creator',
              featureIcon: Icons.add,
              isSelected: currentRoute == '/Creator',
              action: () {
                Navigator.pushNamed(context, '/Creator');
              }),
          buildNavBarItem(
              label: 'Select',
              featureIcon: Icons.play_arrow_outlined,
              isSelected: currentRoute == '/Select',
              action: () {
                Navigator.pushNamed(context, '/Select');
              }),
          buildNavBarItem(
              label: 'Calendar',
              featureIcon: Icons.calendar_month_outlined,
              isSelected: currentRoute == '/Calendar',
              action: () {
                Navigator.pushNamed(context, '/Calendar');
              }),
          buildNavBarItem(
              label: 'Stopwatch',
              featureIcon: Icons.alarm,
              isSelected: currentRoute == '/Stopwatch',
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
              isSelected: currentRoute == '/Settings',
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
        color: isSelected? Colors.grey : null,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          color: isSelected? Colors.grey : null,
        ),
      ),
      onTap: isSelected ? null : action,
    );
  }
}
