import 'package:flutter/material.dart';
import 'package:burnboss/services/auth.dart';

class NavDrawerWidget extends StatelessWidget {
  const NavDrawerWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var email = AuthService().user;
    return Drawer(
      // backgroundColor: Color(0xff121212),
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            // decoration: BoxDecoration(color: Color(0xff292929)),
            accountName: Text(
              'ch4rl3sF',
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: Text(
              email.toString(),
              style: TextStyle(color: Colors.white),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/defaultProfilePicture.png'),
            ),
          ),
          buildNavBarItem(
              label: 'Home',
              featureIcon: Icons.home_filled,
              action: () {
                Navigator.pushNamed(context, '/');
              }),
          buildNavBarItem(
              label: 'Select',
              featureIcon: Icons.play_arrow_outlined,
              action: () {
                Navigator.pushNamed(context, '/Select');
              }),
          buildNavBarItem(
              label: 'Creator',
              featureIcon: Icons.add,
              action: () {
                Navigator.pushNamed(context, '/Creator');
              }),
          buildNavBarItem(
              label: 'Calendar',
              featureIcon: Icons.calendar_month_outlined,
              action: () {
                Navigator.pushNamed(context, '/Calendar');
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

  Widget buildNavBarItem({
    required String label,
    required IconData featureIcon,
    required GestureTapCallback action,
  }) {
    return ListTile(
      leading: Icon(
        featureIcon,
        size: 30,
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
      onTap: action,
    );
  }
}