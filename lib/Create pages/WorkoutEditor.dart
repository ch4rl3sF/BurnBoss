import 'package:burnboss/Create%20pages/NewWorkout.dart';
import 'package:burnboss/models/activity.dart';
import 'package:burnboss/models/workout.dart';
import 'package:burnboss/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'editActivity.dart';

class WorkoutEditorPage extends StatefulWidget {
  final Workout workout;

  WorkoutEditorPage({Key? key, required this.workout}) : super(key: key);

  @override
  State<WorkoutEditorPage> createState() => _WorkoutEditorPageState();
}

class _WorkoutEditorPageState extends State<WorkoutEditorPage> {
  //set the default value - no changes will be made when the page is loaded
  bool changesMade = false;

  @override
  Widget build(BuildContext context) {
    // Access the current theme
    ThemeData theme = Theme.of(context);

    // Determine if the theme is light
    bool isLightTheme = theme.brightness == Brightness.light;

    // Set the color based on the theme
    Color cardColor = isLightTheme ? Colors.white : Colors.grey[800]!;

    void saveChanges() {
      print('Changes made');
      setState(() {
        changesMade = false;
        DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .createWorkout(widget.workout);
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 125,
        title: Text(
          widget.workout.workoutName,
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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: cardColor,
                    child: ListTile(
                      title: Text(activity.activityName),
                      subtitle: Text('Reps: ${activity.reps}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit_rounded),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => editActivity(
                                    activity: widget.workout.activities[index],
                                    onUpdateReps: (int newReps) {
                                      // Update the reps of the original instance in the ActivityList
                                      setState(() {
                                        widget.workout.activities[index]
                                            .updateReps(newReps);
                                        changesMade = true;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.workout.activities.removeAt(index);
                                  changesMade = true;
                                });
                              },
                              icon: Icon(Icons.delete_rounded))
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            if (changesMade)
              ElevatedButton(
                onPressed: () {
                  saveChanges();
                },
                child: Text('Save changes'),
              )
          ],
        ),
      ),
    );
  }
}
