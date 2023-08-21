import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewWorkoutPage extends StatefulWidget {
  const NewWorkoutPage({Key? key}) : super(key: key);

  @override
  State<NewWorkoutPage> createState() => _NewWorkoutPageState();
}

class _NewWorkoutPageState extends State<NewWorkoutPage> {
  final controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String workoutName = '';

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
              controller: controller,
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
                        onPressed: () {
                          Navigator.pop(context, 'Save');
                          final workoutName = controller.text;
                          createWorkout(workoutName: workoutName);
                        },
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.save),
            )
          ],
          // style: TextStyle(
          //   fontSize: 55,
          //   fontWeight: FontWeight.bold,
          //   letterSpacing: 2.0,
          //   fontFamily: 'Bebas',
          // ),
          bottom: TabBar(
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
            ListView(
              children: [],
            )
          ],
        ),
      ),
    );
  }

  Future createWorkout({required String workoutName}) async {
    //reference to document
    final WorkoutName =
        FirebaseFirestore.instance.collection('workouts').doc(workoutName);

    final json = {
      'workout name': workoutName,
    };

    await WorkoutName.set(json);
  }

  Widget buildOverViewCard({
    required String label,
    required GestureTapCallback action,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: Colors.grey, width: 0.5),
      ),
      child: InkWell(
        onTap: action,
        child: Text(label),
      ),
    );
  }
}
