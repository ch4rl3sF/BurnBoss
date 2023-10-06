import 'package:flutter/material.dart';

class Activity {
  String activityName;
  int reps;

  Activity({required this.activityName, required this.reps});

  Map<String, dynamic> toMap() {
    return {
      'activityName': activityName,
      'reps': reps,
      // 'reps': reps,
    };
  }
  void updateReps(int newReps) {
    reps = newReps;
  }
}

class ActivityCard extends StatefulWidget {
  final Activity activity;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  ActivityCard({required this.activity, required this.onEdit, required this.onDelete});

  @override
  _ActivityCardState createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  @override
  Widget build(BuildContext context) {
    // Access the current theme
    ThemeData theme = Theme.of(context);

    // Determine if the theme is light
    bool isLightTheme = theme.brightness == Brightness.light;

    // Set the color based on the theme
    Color cardColor = isLightTheme ? Colors.white : Colors.grey[800]!;
    return Card(
      color: cardColor,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(widget.activity.activityName),
        subtitle: Text('Reps: ${widget.activity.reps}'), // Use widget.activity here
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: widget.onEdit, icon: Icon(Icons.edit)),
            IconButton(onPressed: widget.onDelete, icon: Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}