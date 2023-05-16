import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavigationDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xff121212),
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
                color: Color(0xff292929),
                border: Border(
                    bottom: BorderSide(width: 2, color: Color(0xff7f160a)))),
            child: Center(
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50.0,
                  fontFamily: 'Bebas',
                ),
              ),
            ),
          ),
          buildMenuItem(
            text: 'Home',
            icon: Icons.home_outlined,
            // selectedIcon: Icons.home_filled,
          ),
          const Divider(
            color: Color(0xff006d4f),
            indent: 40.0,
            endIndent: 40.0,
          ),
          buildMenuItem(
            text: 'Player',
            icon: Icons.play_arrow_outlined,
            // selectedIcon: Icons.play_arrow,
          ),
          const Divider(
            color: Color(0xff006d4f),
            indent: 40.0,
            endIndent: 40.0,
          ),
          buildMenuItem(
            text: 'Creator',
            icon: Icons.create_outlined,
            // selectedIcon: Icons.create,
          ),
          const Divider(
            color: Color(0xff006d4f),
            indent: 40.0,
            endIndent: 40.0,
          ),
          buildMenuItem(
            text: 'Calendar',
            icon: Icons.calendar_month_outlined,
            // selectedIcon: Icons.calendar_month,
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
  }) {
    final color = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(text, style: TextStyle(color: Colors.white)),
      onTap: () {},
    );
  }
}
