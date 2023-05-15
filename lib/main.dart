import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: Home(),
    ));

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121212),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff292929),
        toolbarHeight: 100,
        title: const Text(
          'BurnBoss',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            fontFamily: 'Babas',
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            color: Color(0xffFF2c14),
            icon: Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(),
      body: const Center(
        child: Text('Workout now'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Text('Start workout'),
      ),
    );
  }
}
