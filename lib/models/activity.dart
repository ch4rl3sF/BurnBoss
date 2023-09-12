import 'package:flutter/material.dart';

class Activity {
  String activityName;
  // int reps;

  Activity({required this.activityName, /*required this.reps*/});

  Map<String, dynamic> toMap() {
    return {
      'activityName': activityName,
      // 'reps': reps,
    };
  }
}

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final Function() onEdit;
  final Function() onDelete;

  ActivityCard({
    required this.activity,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(activity.activityName),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: onEdit, icon: Icon(Icons.edit)),
            IconButton(onPressed: onDelete, icon: Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
