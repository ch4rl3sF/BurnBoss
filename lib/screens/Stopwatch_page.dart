import 'package:burnboss/screens/NavDrawer.dart';
import 'package:flutter/material.dart';
import 'package:burnboss/models/stopwatch.dart';

class StopwatchPage extends StatefulWidget {
  final ActivityStopwatch _activityStopwatch = ActivityStopwatch();
  StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 125,
        title: const Text(
          'Stopwatch',
          style: TextStyle(
            fontSize: 55,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            fontFamily: 'Bebas',
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
            icon: const Icon(Icons.menu_rounded, size: 30),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Center(
        child: widget._activityStopwatch,
      ),
      drawer: const NavDrawerWidget(currentRoute: '/Stopwatch'),
    );
  }
}