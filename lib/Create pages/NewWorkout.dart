import 'package:burnboss/models/groupAddDynamicWidget.dart';
import 'package:burnboss/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewWorkoutPage extends StatefulWidget {
  @override
  State<NewWorkoutPage> createState() => _NewWorkoutPageState();
}

class _NewWorkoutPageState extends State<NewWorkoutPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController workoutNameAdd = TextEditingController();
  TextEditingController groupNameAdd = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String workoutName = '';
  String groupName = '';

  bool showGroupTextField = false;

  List<String> groups = [];

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
                          final workoutName = workoutNameAdd.text;
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
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: groups
                          .map((group) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      color: Colors.black12,
                                      height: 2,
                                    ),
                                    Text(
                                      group,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ]))
                          .toList(),
                    ),
                  ),
                  showGroupTextField == true
                      ? Row(
                          children: [
                            Container(
                              width: 200,
                              child: TextFormField(
                                controller: groupNameAdd,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Group Name',
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  groupName = groupNameAdd.text;
                                  groups.add(groupName);
                                  showGroupTextField = false;
                                  groupNameAdd.clear();
                                });
                              },
                              icon: Icon(Icons.check),
                            )
                          ],
                        )
                      : Container(),
                  ElevatedButton(
                    child: Text('Add Group'),
                    onPressed: () {
                      setState(() {
                        showGroupTextField = true;
                        print('showGroupTextField set to $showGroupTextField');
                      });
                    },
                  ),
                  ElevatedButton(onPressed: () {setState(() {
                    groups.removeLast();
                  });}, child: Text('Remove group'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
