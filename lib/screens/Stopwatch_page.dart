import 'dart:async';
import 'package:burnboss/screens/NavDrawer.dart';
import 'package:burnboss/stopwatch_pages/Stopwatch.dart';
import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({Key? key}) : super(key: key);

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  //Initialise the function for the stopwatch
  final _stopwatch = StopwatchFunction();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch'),
        leading: Builder(
          builder: (context) => IconButton(
            padding: EdgeInsets.fromLTRB(20.0, 0, 0, 0),
            icon: Icon(Icons.menu_rounded, size: 30),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Display the result
            Text(_stopwatch._result, style: TextStyle(fontSize: 50.0),),
            SizedBox(height: 20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Start button
                ElevatedButton(onPressed: _start, child: Text('Start')),
                //Pause button
                ElevatedButton(onPressed: _pause, child: Text('Pause')),
                //Reset button
                ElevatedButton(onPressed: _reset, child: Text('Reset')),
              ],
            )
          ],
        ),
      ),
      drawer: NavDrawerWidget(),
    );
  }
}
