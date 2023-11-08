import 'package:burnboss/models/workout.dart';
import 'package:burnboss/services/database.dart';
import 'package:burnboss/shared/workout_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:burnboss/screens/NavDrawer.dart';
import 'package:provider/provider.dart';

class SelectPage extends StatefulWidget {
  @override
  _SelectPageState createState() => _SelectPageState();
}


class _SelectPageState extends State<SelectPage> {
  @override
  Widget build(BuildContext context) {
    // Access the current theme
    ThemeData theme = Theme.of(context);

    // Determine if the theme is light
    bool isLightTheme = theme.brightness == Brightness.light;
    // Set the color based on the theme
    Color cardColor
    = isLightTheme ? Colors.white : Colors.grey[800]!;


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: Color(0xff292929),
        toolbarHeight: 125,
        title: const Text(
          'Select',
          style: TextStyle(
            fontSize: 55,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            fontFamily: 'Bebas',
          ),
        ),
      ),
      body: FutureBuilder<List<Workout>>(
          future: DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .getAllWorkouts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // or a loading indicator
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No workouts available.');
            } else {
              // Use a ListView.builder to create cards for each workout
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Workout workout = snapshot.data![index];

                  return Card(
                    color: cardColor,
                  child: ListTile(
                  title: Text(workout.workoutName),
                  onTap: () {
                  // Navigate to a new screen or show a dialog to display activities
                  // For example, you can use Navigator.push to navigate to a new screen
                  // and pass the activities data.
                  },
                  )
                  ,
                  );
                },
              );
            }
          }
      ),
      drawer: const NavDrawerWidget(),
    );
  }
}
