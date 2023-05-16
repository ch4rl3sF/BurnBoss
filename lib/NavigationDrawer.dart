import 'package:burnboss/Editor.dart';
import 'package:burnboss/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xff121212),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(
          top: 24 + MediaQuery.of(context).padding.top,
          bottom: 24,
        ),
        decoration: const BoxDecoration(
            color: Color(0xff292929),
            border:
                Border(bottom: BorderSide(width: 2, color: Color(0xff7f160a)))),
        child: const Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                  'https://sm.askmen.com/t/askmen_in/article/f/facebook-p/facebook-profile-picture-affects-chances-of-gettin_fr3n.1200.jpg'),
            ),
            SizedBox(height: 12),
            Text('Username'),
          ],
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(15.0),
        child: Wrap(runSpacing: 14, children: [
          ListTile(
            leading: const Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
            title: const Text(
              'Home',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Home(),
            )),
          ),
          ListTile(
            leading: const Icon(
              Icons.play_arrow_outlined,
              color: Colors.white,
            ),
            title: const Text('Player', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
              leading: const Icon(
                Icons.create_outlined,
                color: Colors.white,
              ),
              title:
                  const Text('Editor', style: TextStyle(color: Colors.white)),
              onTap: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => EditorPage(),
                  ))),
          ListTile(
            leading: const Icon(
              Icons.calendar_month_outlined,
              color: Colors.white,
            ),
            title:
                const Text('Calendar', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          const Divider(
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Color(0xff006D3F),
          ),
          ListTile(
            leading: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
            ),
            title:
                const Text('Settings', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
        ]),
      );
}
