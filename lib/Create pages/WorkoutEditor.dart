import 'package:burnboss/models/activity.dart';
import 'package:burnboss/models/workout.dart';
import 'package:burnboss/services/database.dart';
import 'package:burnboss/theme/theme_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'editActivity.dart';

class WorkoutEditorPage extends StatefulWidget {
  final Workout workout;

  const WorkoutEditorPage({super.key, required this.workout});

  @override
  State<WorkoutEditorPage> createState() => _WorkoutEditorPageState();
}

class _WorkoutEditorPageState extends State<WorkoutEditorPage> {
  //set the default value - no changes will be made when the page is loaded
  bool changesMade = false;
  bool addingActivity = false;
  bool editingTitle = false;

  List activityIDsDeleted = [];

  TextEditingController activityNameController = TextEditingController();
  TextEditingController workoutNameAdd = TextEditingController();

  late int numberOfActivities;

  @override
  void initState() {
    setState(() {
      numberOfActivities = widget.workout.activities.length;
    });
    super.initState();
  }

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
            .editActivities(widget.workout, activityIDsDeleted);

        // Clear the list once the items are saved
        activityIDsDeleted.clear();

        //Show the SnackBar
        var savingSnackBar = SnackBar(
          content: const Center(
              child: Text(
                'Saving...',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Bebas',
                    color: Colors.white),
              )),
          duration: const Duration(milliseconds: 2000),
          width: 180.0,
          padding: const EdgeInsets.symmetric(
            horizontal:
            8.0, // Inner padding for SnackBar content.
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.black12,
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(savingSnackBar);
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                        decoration: const InputDecoration(
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
                        icon: const Icon(Icons.done)),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            editingTitle = !editingTitle;
                          });
                        },
                        icon: const Icon(Icons.close)),
                  ],
                )
              : Text(
                  widget.workout.workoutName,
                  style: const TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    fontFamily: 'Bebas',
                  ),
                ),
          leading: IconButton(
            onPressed: () async {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Warning!'),
                  content: Text(changesMade
                      ? 'Would you like to exit without saving?'
                      : 'Would you like to exit editing page?'),
                  actions: [
                    if (changesMade)
                      TextButton(
                        onPressed: () async {
                          Navigator.pushNamed(context, '/Creator');
                          saveChanges();
                          var savingSnackBar = SnackBar(
                            content: const Center(
                                child: Text(
                              'Saving...',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Bebas',
                                  color: Colors.white),
                            )),
                            duration: const Duration(milliseconds: 2000),
                            width: 180.0,
                            padding: const EdgeInsets.symmetric(
                              horizontal:
                                  8.0, // Inner padding for SnackBar content.
                            ),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: Colors.black12,
                          );
                          ScaffoldMessenger.of(context)
                              .showSnackBar(savingSnackBar);
                        },
                        child: const Text('Save'),
                      ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/Creator');
                      },
                      child: const Text('Exit'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Return'),
                      child: const Text('Return'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.arrow_back),
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
                  icon: const Icon(Icons.edit_rounded),
                  color: Colors.black,
                ),
              )
          ]),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
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
                        decoration: const InputDecoration(
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
                            if (newActivityName.isNotEmpty) {
                              Activity newActivity = Activity(
                                  activityID: '',
                                  activityName: newActivityName,
                              );

                              widget.workout.activities.add(newActivity);
                              activityNameController.clear();
                            }
                          });
                        },
                        icon: const Icon(Icons.add_rounded),
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
                        icon: const Icon(Icons.close),
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
            Expanded(
              child: ListView.builder(
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
                        subtitle: Text(widget.workout.activities[index].activityType == 'Reps' ? 'Sets: ${widget.workout.activities[index].sets} | Reps: ${widget.workout.activities[index].reps} | ${widget.workout.activities[index].weights}Kg'  : 'Activity type: ${widget.workout.activities[index].activityType}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_rounded),
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
                                      onUpdateSets: (int newSets) {
                                        setState(() {
                                          widget.workout.activities[index].updateSets(newSets);
                                          changesMade = true;
                                        });
                                      },
                                      onUpdateRest: (Duration newRest) {
                                        setState(() {
                                          widget.workout.activities[index].updateRest(newRest);
                                          changesMade = true;
                                        });
                                      },
                                      onUpdateWeight: (double newWeight) {
                                        // Update the weight of the original instance in the ActivityList
                                        setState(() {
                                          widget.workout.activities[index]
                                              .updateWeight(newWeight);
                                          changesMade = true;
                                        });
                                      },
                                      onUpdateTime: (Duration newTime) {
                                        setState(() {
                                          widget.workout.activities[index]
                                              .updateTime(newTime);
                                          changesMade = true;
                                        });
                                      },
                                      onUpdateActivityName:
                                          (String newActivityType) {
                                        setState(() {
                                          widget.workout.activities[index]
                                              .updateActivityType(
                                                  newActivityType);
                                          changesMade = true;
                                        });
                                      },
                                      onUpdateStopwatchUsed:
                                          (bool newStopwatchUsed) {
                                        setState(() {
                                          widget.workout.activities[index]
                                              .updateStopwatchBool(
                                                  newStopwatchUsed);
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            if (numberOfActivities > 1)
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    widget.workout.activities.removeAt(index);
                                    changesMade = true;
                                    activityIDsDeleted.add(activity.activityID);
                                    numberOfActivities = numberOfActivities - 1;
                                  });
                                },
                                icon: const Icon(Icons.delete_rounded),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
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
                      child: const Icon(
                        Icons.add_rounded,
                        size: 30,
                      ),
                    ),
                  if (changesMade)
                    ElevatedButton(
                      onPressed: () {
                        saveChanges();
                      },
                      child: const Text(
                        'Save changes',
                        style: TextStyle(fontFamily: 'Bebas', fontSize: 20),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
