import 'package:burnboss/Create%20pages/newActivity.dart';
import 'package:burnboss/models/activity.dart';
import 'package:burnboss/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:burnboss/models/workout.dart';

class NewWorkoutPage extends StatefulWidget {
  @override
  State<NewWorkoutPage> createState() => _NewWorkoutPageState();
}

class _NewWorkoutPageState extends State<NewWorkoutPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController workoutNameAdd = TextEditingController();
  TextEditingController activitiyNameAdd = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String workoutName = '';
  List<Activity> activities = [];

  bool showGroupTextField = false;

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
              decoration: InputDecoration(
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
          actions: [
            IconButton(
              onPressed: () {
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
                          Navigator.pop(context, 'Save');
                          Workout workout = Workout(
                            workoutName: workoutNameAdd.text,
                            activities: [
                              Activity(activityName: 'pushups'),
                              Activity(activityName: 'plank'),
                            ]
                          );
                          await DatabaseService(
                                  uid: FirebaseAuth.instance.currentUser!.uid)
                              .createWorkout(workout);
                        },
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.save),
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
                Tab(text: 'Total Stats'),
                Tab(text: 'Overview'),
              ]),
        ),
        body: TabBarView(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Muscles Targeted: '),
              Text('Number of steps: '),
              Text('Equipment used: '),
              Text('Days set: '),
            ]),
            Column(children: [
              SizedBox(
                height: 5,
              ),
              Expanded(
                child: ActivityList(),
              ),
            ])
          ],
        ),
      ),
    );
  }
}

class ActivityList extends StatefulWidget {
  @override
  _ActivityListState createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  List<Activity> activities = _NewWorkoutPageState().activities;
  TextEditingController activityNameController = TextEditingController();

  void addActivity(String activityName) {
    setState(() {
      activities.add(Activity(activityName: activityName));
    });
  }

  void editActivity(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => newActivity()),
    );
    print(activities);
  }

  void deleteActivity(int index) {
    setState(() {
      activities.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            controller: activityNameController,
            decoration: InputDecoration(labelText: 'Activity Name', focusColor: Colors.black12),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            String newActivityName = activityNameController.text.trim();
            if (newActivityName.isNotEmpty) {
              addActivity(newActivityName);
              activityNameController.clear();
            }
          },
          child: Text('Add activity'),
        ),
        Expanded(
            child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  return ActivityCard(
                      activity: activities[index],
                      onEdit: () {
                        editActivity(index);
                      },
                      onDelete: () {
                        deleteActivity(index);
                      });
                }))
      ],
    );
  }
}
