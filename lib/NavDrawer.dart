import 'package:burnboss/Calendar.dart';
import 'package:burnboss/Editor.dart';
import 'package:burnboss/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavDrawerWidget extends StatelessWidget {
  const NavDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: Color(0xff121212),
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            // decoration: BoxDecoration(color: Color(0xff292929)),
            accountName: Text(
              'ch4rl3sF',
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: Text(
              'charlesfellows16@gmail.com',
              style: TextStyle(color: Colors.white),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://sm.askmen.com/t/askmen_in/article/f/facebook-p/facebook-profile-picture-affects-chances-of-gettin_fr3n.1200.jpg"),
            ),
          ),
          buildMenuItem(
              label: 'Home',
              featureIcon: Icons.home_filled,
              action: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Home()));
              }),
          buildMenuItem(
              label: 'Player',
              featureIcon: Icons.play_arrow_outlined,
              action: () {
                print("Player menu button pushed");
              }),
          buildMenuItem(
              label: 'Editor',
              featureIcon: Icons.edit_outlined,
              action: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const EditorPage()));
              }),
          buildMenuItem(
              label: 'Calendar',
              featureIcon: Icons.calendar_month_outlined,
              action: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const CalendarPage()));
              }),
          const Divider(
            thickness: 1,
            color: Colors.grey,
            indent: 20,
            endIndent: 20,
          ),
          buildMenuItem(
              label: 'Settings',
              featureIcon: Icons.settings_outlined,
              action: () {
                print("Settings menu button pushed");
              }),
          SizedBox(
            height: 20,
          ),
          InkWell(
            borderRadius: BorderRadius.circular(500),
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xff1DE6C9),
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

  Widget buildMenuItem({
    required String label,
    required IconData featureIcon,
    required GestureTapCallback action,
  }) {
    return ListTile(
      leading: Icon(featureIcon, color: Colors.white, size: 30,),
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      onTap: action,
    );
  }
}
