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
      body: FutureBuilder<dynamic>(
        future: DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getAllWorkouts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // or a loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No workouts available.');
          } else {
            // Extract workout names
            List workoutNames = snapshot.data!.map((workout) => workout[workout.id]).toList();

            // Use a ListView.builder to create cards for each workout name
            return ListView.builder(
              itemCount: workoutNames.length,
              itemBuilder: (context, index) {
                String workoutName = workoutNames[index];

                // Create a card for each workout name
                return Card(
                  child: ListTile(
                    title: Text(workoutName),
                    // Add other details as needed
                  ),
                );
              },
            );
          }
        },
      ),
      drawer: const NavDrawerWidget(),
    );
  }
}
