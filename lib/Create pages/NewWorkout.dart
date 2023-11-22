import 'package:burnboss/Create%20pages/editActivity.dart';
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
                                workoutName: workoutNameAdd.text,
                                activities: activities);
                            await DatabaseService(
                                    uid: FirebaseAuth.instance.currentUser!.uid)
                                .createWorkout(workout);
                          },
                        ),
                      ],
                    ),
                  );
                }
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
                Tab(text: 'Overview'),
                Tab(text: 'Total Stats'),
              ]),
        ),
        body: TabBarView(
          children: [
            Column(children: [
              SizedBox(
                height: 5,
              ),
              Expanded(
                child: ActivityList(activities: activities),
              ),
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Muscles Targeted: '),
              Text('Number of steps: ${activities.length}'),
              Text('Equipment used: '),
              Text('Days set: '),
            ]),
          ],
        ),
      ),
    );
  }
}

class ActivityList extends StatefulWidget {
  final List<Activity> activities;

  ActivityList({required this.activities});

  @override
  _ActivityListState createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  TextEditingController activityNameController = TextEditingController();

  addActivityItem(String activityName) {
    //ADD IN: record time when workout was created
    setState(() {
      int placeholderReps = 0;

      widget.activities
          .add(Activity(activityName: activityName, reps: placeholderReps));
    });
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
          padding: EdgeInsets.all(10.0),
          child: TextField(
            controller: activityNameController,
            decoration: InputDecoration(
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
          child: Text('Add activity'),
        ),
        SizedBox(
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
