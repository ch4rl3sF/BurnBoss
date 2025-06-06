import 'package:burnboss/Create%20pages/WorkoutEditor.dart';
import 'package:burnboss/models/workout.dart';
import 'package:burnboss/services/database.dart';
import 'package:burnboss/theme/theme_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EditWorkoutPage extends StatefulWidget {
  const EditWorkoutPage({super.key});

  @override
  State<EditWorkoutPage> createState() => _EditWorkoutPageState();
}

class _EditWorkoutPageState extends State<EditWorkoutPage> {
  late Future<List<Workout>> futureWorkouts;

  @override
  void initState() {
    super.initState();
    futureWorkouts =
        DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .getAllWorkouts();
  }

  Future<void> _refreshWorkoutsList() async {
    setState(() {
      futureWorkouts =
          DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .getAllWorkouts();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access the current theme
    ThemeData theme = Theme.of(context);

    // Determine if the theme is light
    bool isLightTheme = theme.brightness == Brightness.light;
    // Set the color based on the theme
    Color cardColor = isLightTheme ? Colors.white : Colors.grey[800]!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: Color(0xff292929),
        toolbarHeight: 125,
        title: const Text(
          'Edit Workouts',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            fontFamily: 'Bebas',
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshWorkoutsList,
        child: FutureBuilder<List<Workout>>(
            future: futureWorkouts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SpinKitDualRing(
                    color: COLOR_PRIMARY,
                    size: 50.0,
                  ),
                ); // or a loading indicator
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 120,
                      ),
                      Icon(
                        Icons.not_interested_rounded,
                        size: 60,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'No workouts available',
                        style: TextStyle(fontFamily: 'Bebas', fontSize: 30),
                      ),
                    ],
                  ),
                );
              } else {
                // Use a ListView.builder to create cards for each workout
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Workout workout = snapshot.data![index];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Card(
                            color: cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              title: Text(
                                workout.workoutName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Bebas',
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WorkoutEditorPage(
                                                    workout:
                                                        snapshot.data![index],
                                                  )));
                                    },
                                    icon: const Icon(
                                      Icons.edit_rounded,
                                      size: 30,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: const Text(
                                                    'Delete workout?'),
                                                content: Text(
                                                    'Are you sure you want to delete ${workout.workoutName}'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () async {
                                                        await DatabaseService(
                                                                uid: FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                            .deleteWorkout(
                                                                workout
                                                                    .workoutID);
                                                        await _refreshWorkoutsList();
                                                        Navigator.pop(
                                                            context, 'Delete');
                                                      },
                                                      child:
                                                          const Text('Delete')),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, 'Cancel');
                                                      },
                                                      child:
                                                          const Text('Cancel'))
                                                ],
                                              ));
                                    },
                                    icon: const Icon(
                                      Icons.delete_rounded,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}
