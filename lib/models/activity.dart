import 'package:flutter/material.dart';

class Activity {
  late String activityID;
  String activityName;
  int reps;
  int sets;
  Duration rest;
  double weights;
  Duration time;
  String activityType;
  bool stopwatchUsed;

  Activity({
    required this.activityID,
    required this.activityName,
    this.reps = 0,
    this.sets = 1,
    this.rest = const Duration(),
    this.weights = 0,
    this.time = const Duration(),
    this.activityType = 'Reps',
    this.stopwatchUsed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'activityID': activityID,
      'activityName': activityName,
      'reps': reps,
      'sets': sets,
      'rest': rest,
      'weights': weights,
      'time': time,
      'activityType': activityType,
      'stopwatchUsed': stopwatchUsed
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
        activityID: map['activityID'],
        activityName: map['activityName'],
        reps: map['reps'],
        sets: map['sets'],
        rest: Duration(milliseconds: map['rest']),
        weights: map['weights'],
        time: Duration(milliseconds: map['time']),
        activityType: map['activityType'],
        stopwatchUsed: map['stopwatchUsed']);
  }

  void updateReps(int newReps) {
    reps = newReps;
  }

  void updateSets(int newSets) {
    sets = newSets;
  }

  void updateRest(Duration newRest) {
    rest = newRest;
  }

  void updateWeight(double newWeight) {
    weights = newWeight;
  }

  void updateTime(Duration newTime) {
    time = newTime;
  }

  void updateActivityType(String newActivityType) {
    activityType = newActivityType;
  }

  void updateStopwatchBool(bool newStopwatchUsed) {
    stopwatchUsed = newStopwatchUsed;
  }
}

class ActivityCard extends StatefulWidget {
  final Activity activity;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ActivityCard(
      {required this.activity,
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
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(widget.activity.activityName),
        subtitle: Text(widget.activity.activityType == 'Reps'
            ? 'Sets: ${widget.activity.sets} | Reps: ${widget.activity.reps} | ${widget.activity.weights}Kg'
            : 'Activity type: ${widget.activity.activityType}'),
        // Use widget.activity here
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: widget.onEdit, icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: widget.onDelete, icon: const Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
