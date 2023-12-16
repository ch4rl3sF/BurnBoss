import 'package:flutter/material.dart';

class Activity {
  String activityName;
  int reps;
  bool weightsUsed;
  int weights;
  Duration time;
  String activityType;
  bool stopwatchUsed;

  Activity({required this.activityName,
    this.reps = 0,
    this.weightsUsed = false,
    this.weights = 0,
    this.time = const Duration(),
    this.activityType = 'Reps',
    this.stopwatchUsed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'activityName': activityName,
      'reps': reps,
      'weights': weights,
      'weightsUsed': weightsUsed,
      'time': time,
      'activityType': activityType,
      'stopwatchUsed': stopwatchUsed
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      activityName: map['activityName'],
      reps: map['reps'],
      weightsUsed: map['weightsUsed'],
      weights: map['weights'],
      time: Duration(milliseconds: map['time']),
      activityType: map['activityType'],
      stopwatchUsed: map['stopwatchUsed']
    );
  }

  void updateReps(int newReps) {
    reps = newReps;
  }

  void updateWeight(int newWeight) {
    weights = newWeight;
  }

  void updateTime(Duration newTime) {
    time = newTime;
  }

  void updateActivityType(String newActivityType) {
    activityType = newActivityType;
  }

  void updateStopwatchBool(bool newStopwatchUsed){
    stopwatchUsed = newStopwatchUsed;
  }
}

class ActivityCard extends StatefulWidget {
  final Activity activity;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  ActivityCard({required this.activity,
    required this.onEdit,
    required this.onDelete,
    required ValueKey<String> key});

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
      key: ValueKey(widget.activity.activityName),
      color: cardColor,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(widget.activity.activityName),
        subtitle: Text('Activity Type: ${widget.activity.activityType}'),
        // Use widget.activity here
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
