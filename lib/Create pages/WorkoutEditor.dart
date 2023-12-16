import 'package:burnboss/models/activity.dart';
import 'package:burnboss/models/workout.dart';
import 'package:burnboss/services/database.dart';
import 'package:burnboss/theme/theme_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool addingActivity = false;
  bool editingTitle = false;

  List activityNamesDeleted = [];

  TextEditingController activityNameController = TextEditingController();
  TextEditingController workoutNameAdd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Access the current theme
    ThemeData theme = Theme.of(context);

    // Determine if the theme is light
    bool isLightTheme = theme.brightness == Brightness.light;

    // Set the color based on the theme
    Color cardColor = isLightTheme ? Colors.white : Colors.grey[800]!;

    Color IconButtonColor = isLightTheme ? COLOR_PRIMARY : DARK_COLOR_PRIMARY;
    Color IconButtonIconColor = isLightTheme ? Colors.white : Colors.black;
    void saveChanges() {
      print('Changes made');
      setState(() {
        changesMade = false;

        DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .editWorkoutName(
                widget.workout.workoutID, widget.workout.workoutName);
        DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .editActivities(widget.workout, activityNamesDeleted);

        //Clear the list once the items are saved
        activityNamesDeleted.clear();
      });
    }

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 125,
          title: editingTitle
              ? Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: TextField(
                        controller: workoutNameAdd,
                        decoration: InputDecoration(
                          labelText: 'Workout Name',
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            changesMade = true;
                            editingTitle = !editingTitle;
                            widget.workout.workoutName = workoutNameAdd.text;
                          });
                        },
                        icon: Icon(Icons.done)),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            editingTitle = !editingTitle;
                          });
                        },
                        icon: Icon(Icons.close)),
                  ],
                )
              : Text(
                  widget.workout.workoutName,
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    fontFamily: 'Bebas',
                  ),
                ),
          actions: [
            if (!editingTitle)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      editingTitle = !editingTitle;
                    });
                  },
                  icon: Icon(Icons.edit_rounded),
                  color: Colors.black,
                ),
              )
          ]),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 4,
            ),
            if (addingActivity)
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: activityNameController,
                        decoration: InputDecoration(
                          labelText: 'Activity Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      height: 55,
                      width: 55,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            addingActivity = !addingActivity;
                            String newActivityName =
                                activityNameController.text.trim();
                            int placeholderReps = 0;
                            if (newActivityName.isNotEmpty) {
                              widget.workout.activities.add(Activity(
                                  activityName: newActivityName,
                                  reps: placeholderReps));
                              activityNameController.clear();
                            }
                          });
                        },
                        icon: Icon(Icons.add_rounded),
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          backgroundColor: IconButtonColor,
                          foregroundColor: IconButtonIconColor,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      height: 55,
                      width: 55,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            addingActivity = !addingActivity;
                          });
                        },
                        icon: Icon(Icons.close),
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          backgroundColor: IconButtonColor,
                          foregroundColor: IconButtonIconColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.workout.activities.length,
              itemBuilder: (context, index) {
                Activity activity = widget.workout.activities[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    color: cardColor,
                    child: ListTile(
                      title: Text(activity.activityName),
                      subtitle: Text('Activity Type: ${activity.activityType}'),
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
                                    onUpdateWeight: (int newWeight) {
                                      // Update the weight of the original instance in the ActivityList
                                      setState(() {
                                        widget.workout.activities[index].updateWeight(newWeight);
                                        changesMade = true;
                                      });
                                    },
                                    onUpdateTime: (Duration newTime) {
                                      setState(() {
                                        widget.workout.activities[index].updateTime(newTime);
                                        changesMade = true;
                                      });
                                    },
                                    onUpdateActivityName: (String newActivityType) {
                                      setState(() {
                                        widget.workout.activities[index].updateActivityType(newActivityType);
                                        changesMade = true;
                                      });
                                    },
                                    onUpdateStopwatchUsed: (bool newStopwatchUsed) {
                                      setState(() {
                                        widget.workout.activities[index].updateStopwatchBool(newStopwatchUsed);
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
                                  activityNamesDeleted
                                      .add(activity.activityName);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!addingActivity)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changesMade = true;
                        addingActivity = true;
                      });
                    },
                    child: Icon(
                      Icons.add_rounded,
                      size: 30,
                    ),
                  ),
                if (changesMade)
                  ElevatedButton(
                    onPressed: () {
                      saveChanges();
                    },
                    child: Text(
                      'Save changes',
                      style: TextStyle(fontFamily: 'Bebas', fontSize: 20),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
