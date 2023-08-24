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

  final _formKey = GlobalKey<FormState>();

  String workoutName = '';
  String groupName = '';

  bool showGroupTextField = false;

  List<groupAddDynamicWidget> groupList = [];

  List<String> Group = [];

  addGroup() {
    if (Group.length != 0) {
      Group = [];
      groupList = [];
    }
    setState(() {});
    if (groupList.length >= 10) {
      return;
    }
    groupList.add(new groupAddDynamicWidget());
  }

  submitGroupName() {
    Group = [];
    groupList.forEach((widget) => Group.add(Group.toString()));
    setState(() {});
    print(Group.length);
  }

  @override
  Widget build(BuildContext context) {
    Widget groupTextField = new Flexible(
      flex: 2,
      child: new ListView.builder(
        itemCount: groupList.length,
        itemBuilder: (_, index) => groupList[index],
      ),
    );

    Widget submitGroupButton = Container(
      child: ElevatedButton(
        onPressed: submitGroupName,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Submit Data'),
        ),
      ),
    );

    Widget result = Flexible(
      flex: 1,
      child: Container(
        child: ListView.builder(
          itemCount: Group.length,
          itemBuilder: (_, index) {
            return Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text('${index + 1} : ${Group[index]}'),
                  ),
                  Divider(),
                ],
              ),
            );
          },
        ),
      ),
    );

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
            Column(
              children: [
                SizedBox(
                  height: 500,
                  child: Column(
                    children: [
                      Group.length == 0 ? groupTextField : result,
                      Group.length == 0 ? submitGroupButton: new Container(),

                    ],
                  ),
                ),
                FloatingActionButton(
                  onPressed: addGroup,
                  child: new Icon(Icons.add),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
