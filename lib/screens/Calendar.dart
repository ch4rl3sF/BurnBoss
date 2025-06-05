import 'package:burnboss/screens/NavDrawer.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        leading: Builder(
          builder: (context) => IconButton(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
            icon: const Icon(Icons.menu_rounded, size: 30),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: const Text('Calendar'),
      drawer: const NavDrawerWidget(currentRoute: '/Calendar',),
    );
  }
}
