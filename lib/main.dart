import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'NavDrawer.dart';

void main() {
  runApp(BurnBoss());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
  ));
}

enum DrawerSelection {home, player, editor, calendar}

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
            padding: EdgeInsets.fromLTRB(20.0,0,0,0),
            color: Color(0xffFF2c14),
            icon: Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: NavDrawerWidget(),

      body: const Center(
        child: Text('Workout now'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Text('workout'),
        backgroundColor: Color(0xff1DE6C9),
      ),
    );
  }
}
