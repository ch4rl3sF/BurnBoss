import 'package:flutter/material.dart';

var workoutName = 'New Workout';

class NewWorkoutPage extends StatefulWidget {
  const NewWorkoutPage({Key? key}) : super(key: key);

  @override
  State<NewWorkoutPage> createState() => _NewWorkoutPageState();
}

class _NewWorkoutPageState extends State<NewWorkoutPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          // backgroundColor: Color(0xff292929),
          toolbarHeight: 125,
          title: Text(
            workoutName,
            style: TextStyle(
              fontSize: 55,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              fontFamily: 'Bebas',
            ),
          ),
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
              children: [

              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildOverViewCard({
    required String label,
    required GestureTapCallback action,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey, width: 0.5),
      ),
      child: InkWell(
        onTap: action,
        child: Text('Add Group'),
      ),
    );
  }
}
