import 'package:flutter/material.dart';
import 'NavDrawer.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Text('Calendar'),
      drawer: NavDrawerWidget(),
    );
  }
}
