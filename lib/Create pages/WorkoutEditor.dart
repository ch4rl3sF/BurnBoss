import 'package:flutter/material.dart';

import '../models/activity.dart';
import '../models/workout.dart';

class WorkoutEditorPage extends StatefulWidget {
  final Workout workout;
  WorkoutEditorPage({Key? key, required this.workout}) : super(key: key);

  @override
  State<WorkoutEditorPage> createState() => _WorkoutEditorPageState();
}

class _WorkoutEditorPageState extends State<WorkoutEditorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 125,
        title: Text(widget.workout.workoutName,
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              fontFamily: 'Bebas',
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.workout.activities.length,
              itemBuilder: (context, index) {
                Activity activity = widget.workout.activities[index];
                return Padding(padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    title: Text(activity.activityName),
                  ),
                ),);
              },
            )
          ],
        ),
      ),
    );
  }
}
