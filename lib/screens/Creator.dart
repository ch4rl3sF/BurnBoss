import 'package:burnboss/Create%20pages/EditWorkout.dart';
import 'package:burnboss/Create%20pages/NewWorkout.dart';
import 'package:burnboss/screens/NavDrawer.dart';
import 'package:flutter/material.dart';


class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: Color(0xff292929),
        toolbarHeight: 125,
        title: const Text(
          'Create',
          style: TextStyle(
            fontSize: 55,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            fontFamily: 'Bebas',
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
            icon: const Icon(
              Icons.menu_rounded,
              size: 30,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            buildCreateCard(
              pageIcon: Icons.add,
              label: 'New Workout',
              action: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NewWorkoutPage()),
                );
              },
            ),
            const SizedBox(
              height: 30,
            ),
            buildCreateCard(
              pageIcon: Icons.edit,
              label: 'Edit Workout',
              action: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditWorkoutPage()),
                );
              },
            ),
          ],
        ),
      ),
      drawer: const NavDrawerWidget(currentRoute: '/Creator'),
    );
  }

  Widget buildCreateCard({
    required IconData pageIcon,
    required String label,
    required GestureTapCallback action,
  }) {
    return Card(
      // color: Color(0xff292929),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.grey, width: 0.5)),
      child: InkWell(
        onTap: action,
        child: SizedBox(
          width: 150,
          height: 125,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  pageIcon,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
