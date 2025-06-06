import 'package:burnboss/Create%20pages/editActivity.dart';
import 'package:burnboss/models/activity.dart';
import 'package:burnboss/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:burnboss/models/workout.dart';

class NewWorkoutPage extends StatefulWidget {
  const NewWorkoutPage({super.key});

  @override
  State<NewWorkoutPage> createState() => _NewWorkoutPageState();
}

class _NewWorkoutPageState extends State<NewWorkoutPage> {
  TextEditingController workoutNameAdd = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String workoutName = '';
  List<Activity> activities = [];
  String error = '';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          // backgroundColor: Color(0xff292929),
          toolbarHeight: 125,
          title: Form(
            key: _formKey,
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Workout name',
              ),
              controller: workoutNameAdd,
              validator: (val) => val!.isEmpty ? 'Enter a workout name' : null,
              onChanged: (val) {
                setState(() {
                  workoutName = val;
                });
              },
            ),
          ),
          leading: IconButton(
            onPressed: () async {
              if (workoutName == '' || activities.isEmpty) {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Warning!'),
                    content: const Text(
                        'Your workout either has no name or no activities!'),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/Creator'),
                        child: const Text('Abandon'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Return'),
                        child: const Text('Return'),
                      ),
                    ],
                  ),
                );
              } else {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Warning!'),
                    content:
                        const Text('Would you like to exit without saving?'),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            Navigator.pushNamed(context, '/Creator');
                            Workout workout = Workout(
                                workoutID: '',
                                workoutName: workoutNameAdd.text,
                                activities: activities);
                            await DatabaseService(
                                    uid: FirebaseAuth.instance.currentUser!.uid)
                                .createWorkout(workout);
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
                          child: const Text('Save')),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/Creator');
                          print('exit button pressed');
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
              }
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
              onPressed: () {
                if (workoutName == '' || activities.isEmpty) {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Error!'),
                      content: const Text(
                          'Error creating workout. Make sure the workout has a name, and that you have activities!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Return'),
                          child: const Text('Return'),
                        ),
                      ],
                    ),
                  );
                } else {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Save workout?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          child: const Text('Save'),
                          onPressed: () async {
                            Navigator.pushNamed(context, '/Creator');
                            Workout workout = Workout(
                                workoutID: '',
                                workoutName: workoutNameAdd.text,
                                activities: activities);
                            await DatabaseService(
                                    uid: FirebaseAuth.instance.currentUser!.uid)
                                .createWorkout(workout);
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
                        ),
                      ],
                    ),
                  );
                }
              },
              icon: const Icon(Icons.save),
            )
          ],
          bottom: const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.white),
              tabs: [
                Tab(text: 'Overview'),
                Tab(text: 'Total Stats'),
              ]),
        ),
        body: TabBarView(
          children: [
            Column(children: [
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: ActivityList(activities: activities),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Muscles Targeted: ',
                      style: TextStyle(fontFamily: 'Bebas', fontSize: 30),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text('Number of steps: ${activities.length}',
                        style:
                            const TextStyle(fontFamily: 'Bebas', fontSize: 30)),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Equipment used: ',
                        style: TextStyle(fontFamily: 'Bebas', fontSize: 30)),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Days set: ',
                        style: TextStyle(fontFamily: 'Bebas', fontSize: 30)),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityList extends StatefulWidget {
  final List<Activity> activities;

  const ActivityList({super.key, required this.activities});

  @override
  _ActivityListState createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  TextEditingController activityNameController = TextEditingController();

  addActivityItem(String activityName) {
    //ADD IN: record time when workout was created
    setState(() {
      widget.activities
          .add(Activity(activityID: '', activityName: activityName));
    });

    editActivityItem(widget.activities.length - 1);
  }

  void editActivityItem(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => editActivity(
          activity: widget.activities[index],
          onUpdateReps: (int newReps) {
            // Update the reps of the original instance in the ActivityList
            setState(() {
              widget.activities[index].updateReps(newReps);
            });
          },
          onUpdateSets: (int newSets) {
            setState(() {
              widget.activities[index].updateSets(newSets);
            });
          },
          onUpdateRest: (Duration newRest) {
            setState(() {
              widget.activities[index].updateRest(newRest);
            });
          },
          onUpdateWeight: (double newWeight) {
            // Update the weight of the original instance in the ActivityList
            setState(() {
              widget.activities[index].updateWeight(newWeight);
            });
          },
          onUpdateTime: (Duration newTime) {
            setState(() {
              widget.activities[index].updateTime(newTime);
            });
          },
          onUpdateActivityName: (String newActivityType) {
            setState(() {
              widget.activities[index].updateActivityType(newActivityType);
            });
          },
          onUpdateStopwatchUsed: (bool newStopwatchUsed) {
            setState(() {
              widget.activities[index].updateStopwatchBool(newStopwatchUsed);
            });
          },
        ),
      ),
    );
    print(widget.activities);
  }

  //function to delete any of the activities from their index
  void deleteActivityItem(int index) {
    setState(() {
      widget.activities.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: activityNameController,
            decoration: const InputDecoration(
              labelText: 'Activity Name',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            String newActivityName = activityNameController.text.trim();
            if (newActivityName.isNotEmpty) {
              addActivityItem(newActivityName);
              activityNameController.clear();
            }
          },
          child: const Text('Add activity'),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
            child: ListView.builder(
                itemCount: widget.activities.length,
                itemBuilder: (context, index) {
                  Activity activity = widget.activities[index];
                  return ActivityCard(
                      key: ValueKey(activity.activityName),
                      activity: activity,
                      onEdit: () {
                        editActivityItem(index);
                      },
                      onDelete: () {
                        deleteActivityItem(index);
                      });
                }))
      ],
    );
  }
}
