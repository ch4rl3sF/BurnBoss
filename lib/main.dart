import 'package:burnboss/Editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'NavDrawer.dart';

void main() {
  runApp(BurnBoss());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
  ));
}

enum DrawerSelection { home, player, editor, calendar }

class BurnBoss extends StatelessWidget {
  DrawerSelection _drawerSelection = DrawerSelection.home;

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BurnBoss',
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121212),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff292929),
        toolbarHeight: 150,
        title: const Text(
          'BurnBoss',
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
            color: Color(0xffFF2c14),
            icon: Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: NavDrawerWidget(),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 70.0),
          child: SizedBox(
            height: 315,
            width: 300,
            child: GridView.count(
              mainAxisSpacing: 30,
              crossAxisSpacing: 30,
              crossAxisCount: 2,
              primary: false,
              children: [
                buildCard(
                    pageIcon: Icons.mouse_outlined,
                    label: 'Select',
                    action: () {
                      print('Player button pressed');
                    }),
                buildCard(
                    pageIcon: Icons.edit,
                    label: 'Editor',
                    action: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => EditorPage()));
                    }),
                buildCard(
                    pageIcon: Icons.calendar_month,
                    label: 'Calendar',
                    action: () {
                      print('Calendar button pressed');
                    }),
                buildCard(
                    pageIcon: Icons.accessible_forward,
                    label: 'Go!',
                    action: () {
                      print('Go button pressed');
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard({
    required IconData pageIcon,
    required String label,
    required GestureTapCallback action,
  }) {
    return Card(
      color: Color(0xff292929),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey, width: 0.5)
      ),
      child: InkWell(
        onTap: action,
        child: SizedBox(
          width: 200,
          height: 125,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  pageIcon,
                  size: 40,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  label,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
