import 'package:burnboss/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class editActivity extends StatefulWidget {
  final Activity activity;
  final Function(int) onUpdateReps; // Add callback function

  editActivity({Key? key, required this.activity, required this.onUpdateReps})
      : super(key: key);


  @override
  State<editActivity> createState() => _editActivityState();
}

class _editActivityState extends State<editActivity> {
  TextEditingController repsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activity.activityName),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: TextField(
              controller: repsController,
              decoration: InputDecoration(
                labelText: 'Number of Reps: ${widget.activity.reps}',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number, //VALIDATION - shows only numpad
              inputFormatters: [FilteringTextInputFormatter.digitsOnly], //VALIDATION - allows only integers to be entered
              onSubmitted: (reps) {
                try {
                  int parsedReps = int.parse(reps);
                  widget.onUpdateReps(parsedReps); // Call the callback to update reps
                } catch (e) {
                  // Handle the case where the input is not a valid integer
                  print('Invalid input: $reps');
                }
              },
            ),
          )
        ],
      )
    );
  }
}
