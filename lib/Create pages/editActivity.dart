import 'package:burnboss/models/activity.dart';
import 'package:burnboss/theme/theme_constants.dart';
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
  TextEditingController weightsController = TextEditingController();
  List<bool> isSelected = [];

  @override
  void initState() {
    super.initState();
    isSelected = [!widget.activity.weightsUsed, widget.activity.weightsUsed];
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activity.activityName),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Are weights used?',
                  style: TextStyle(fontFamily: 'Bebas', fontSize: 30),
                ),
                ToggleButtons(
                  isSelected: isSelected,
                  selectedColor: Colors.white,
                  color: Colors.black,
                  fillColor: COLOR_SECONDARY,
                  textStyle: TextStyle(fontFamily: 'Bebas'),
                  renderBorder: true,
                  borderColor: Colors.black,
                  borderWidth: 1.0,
                  borderRadius: BorderRadius.circular(5),
                  selectedBorderColor: Colors.black,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('No'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Yes'),
                    ),
                  ],
                  onPressed: (int newIndex) {
                    setState(() {
                      for (int index = 0; index < isSelected.length; index++) {
                        if (index == newIndex) {
                          setState(() {
                            widget.activity.weightsUsed = isSelected[index];
                          });
                        }
                        isSelected[index] = (index == newIndex);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          if (widget.activity.weightsUsed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                      flex: 7,
                      child: Text('Weight (in Kg):',
                          style: TextStyle(fontFamily: 'Bebas', fontSize: 30))),
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: weightsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        hintText: widget.activity.weights.toString(),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onSubmitted: (weights) {
                        try {
                          setState(() {
                            widget.activity.weights = int.parse(weights);
                          });
                        } catch (e) {
                          print('Error parsing weight integer');
                        }
                        
                      },
                    ),
                  )
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Row(
              children: [
                Expanded(
                    flex: 7,
                    child: Text('Reps:',
                        style: TextStyle(fontFamily: 'Bebas', fontSize: 30))),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: repsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: widget.activity.reps.toString()),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onSubmitted: (reps) {
                      try {
                        int parsedReps = int.parse(reps);
                        widget.onUpdateReps(
                            parsedReps); // Call the callback to update reps
                      } catch (e) {
                        // Handle the case where the input is not a valid integer
                        print('Invalid input: $reps');
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
