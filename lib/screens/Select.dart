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
        leading: Builder(
          builder: (context) =>
              IconButton(
                padding: EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                icon: Icon(Icons.menu_rounded, size: 30),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),
      body: FutureBuilder(
        future: DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .getWorkout(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Or some loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return snapshot
                .data as Widget; // Assuming your getWorkout() returns a Widget
          }
        },
      ),
      drawer: const NavDrawerWidget(),
    );
  }
}
