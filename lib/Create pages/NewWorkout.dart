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

  final _formKey = GlobalKey<FormState>();

  String workoutName = '';

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
                    title: const Text('Update workout name?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        child: const Text('Save'),
                        onPressed: () async {
                          Navigator.pop(context, 'Save');
                          Workout WorkoutSample = Workout(
                            workoutName: workoutNameAdd.text,
                            activities: [
                              Activity(activityName: 'sample:plank', reps: 4),
                              Activity(activityName: 'sample:pushups', reps: 5)
                            ],
                          );
                          await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createWorkout(WorkoutSample);
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
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Muscles Targeted: '),
                  Text('Number of steps: '),
                  Text('Equipment used: '),
                  Text('Days set: '),
                ]),
            Column(
              children: [
                ElevatedButton(onPressed: () {}, child: Text("does nothing"))
              ]
            )
          ],
        ),
      ),
    );
  }
}
