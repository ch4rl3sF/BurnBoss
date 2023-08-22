import 'dart:async';

import 'package:burnboss/models/user.dart';
import 'package:burnboss/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewWorkoutPage extends StatefulWidget {
  @override
  State<NewWorkoutPage> createState() => _NewWorkoutPageState();
}

class _NewWorkoutPageState extends State<NewWorkoutPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final workoutNameController = TextEditingController();
  final groupNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String workoutName = '';
  String groupName = '';

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
              controller: workoutNameController,
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
                          final workoutName = workoutNameController.text;
                          await DatabaseService(
                                  uid: FirebaseAuth.instance.currentUser!.uid)
                              .createWorkout(workoutName,
                                  groupName); //calls the create document from database to create the workout with the workout name
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
                children: const [
                  Text('Muscles Targeted: '),
                  Text('Number of steps: '),
                  Text('Equipment used: '),
                  Text('Days set: '),
                ]),
            Column(
              children: [
                if (showGroupTextField == true) ...[
                  Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                        child: Container(
                          color: Colors.black12,
                          height: 2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 200,
                              child: TextField(
                                decoration:
                                    InputDecoration(hintText: 'Add Group name'),
                                controller: groupNameController,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    groupName = groupNameController.text;
                                    showGroupTextField = false;
                                  });
                                  print('showGroupTextField changed to $showGroupTextField');
                                },
                                icon: Icon(Icons.check))
                          ],
                        ),
                      ),

                    ],
                  )
                ],
                buildGroup(height: 100),
              ],

            )
          ],
        ),
      ),
    );
  }

  Widget buildGroup({
    // required ControllerCallback groupNameController,
    required double height,
  }) {
    return ElevatedButton(
        onPressed: () {
          setState((){
            showGroupTextField = true;
          });
          print('showGroupTextField changed to $showGroupTextField');
        },
        child: const Text('Add Group'));
  }
}

// children: [
//   Padding(
//     padding:
//         EdgeInsets.symmetric(vertical: 10, horizontal: 25),
//     child: Container(
//       color: Colors.black12,
//       height: 2,
//     ),
//   ),
//   Row(
//     children: [
//       SizedBox(
//         width: 200,
//         child: TextField(
//           decoration:
//               InputDecoration(hintText: 'Add Group name'),
//           controller: groupNameController,
//         ),
//       ),
//       IconButton(
//           onPressed: () {
//             setState(() {
//               groupName = groupNameController.text;
//             });
//           },
//           icon: Icon(Icons.check))
//     ],
//   ),
// ], THIS WORKS IN COLUMN IN BODY
