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
}

// class ActivityCard extends StatelessWidget {
//   final Activity activity;
//   final Function() onEdit;
//   final Function() onDelete;
//
//   ActivityCard({
//     required this.activity,
//     required this.onEdit,
//     required this.onDelete,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.white,
//       margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       child: ListTile(
//         title: Text(activity.activityName),
//         subtitle: Text('Reps: ${activity.reps}'),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(onPressed: onEdit, icon: Icon(Icons.edit)),
//             IconButton(onPressed: onDelete, icon: Icon(Icons.delete)),
//           ],
//         ),
//       ),
//     );
//   }
// }
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
    return Card(
      color: Colors.white,
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