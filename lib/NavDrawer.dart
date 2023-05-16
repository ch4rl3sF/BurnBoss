import 'package:burnboss/Editor.dart';
import 'package:burnboss/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavDrawerWidget extends StatelessWidget {
  const NavDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xff121212),
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color(0xff292929)),
            accountName: Text(
              'ch4rl3sF',
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: Text(
              'charlesfellows16@gmail.com',
              style: TextStyle(color: Colors.white),
            ),
          ),
          buildMenuItem(
            label: 'home',
            icon: Icons.home_outlined,
            onTap: Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem({
    required String label,
    required IconData icon,
    required onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {},
    );
  }
}
