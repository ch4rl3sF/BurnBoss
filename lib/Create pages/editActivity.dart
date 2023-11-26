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
  TextEditingController hoursController = TextEditingController();
  TextEditingController minutesController = TextEditingController();
  TextEditingController secondsController = TextEditingController();
  List<bool> isSelected = [];
  late int timerSeconds;

  @override
  void initState() {
    super.initState();
    isSelected = [!widget.activity.weightsUsed, widget.activity.weightsUsed];
    timerSeconds = 0;
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
                            widget.activity.weightsUsed = (newIndex ==
                                1); // Set weightsUsed based on the selected index
                            isSelected = List.generate(
                                isSelected.length,
                                (index) =>
                                    index == newIndex); // Update isSelected
                          });
                        }
                        isSelected[index] = (index == newIndex);
                        widget.activity.weights = 0;
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
                        border: OutlineInputBorder(),
                        hintText: widget.activity.reps.toString()),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Time:', style: TextStyle(fontSize: 30, fontFamily: 'Bebas'),),
                Container(
                  width: 200,
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: hoursController,
                          decoration: InputDecoration(
                            hintText: '00',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2)
                          ],
                          onSubmitted: (hours) {
                            try {
                              setState(() {
                                int parsedHours = int.parse(hours);
                                timerSeconds = timerSeconds + (parsedHours*3600);
                              });
                            } catch (e) {
                              print('invalid input: $hours, error $e');
                            }
                          },
                        ),
                      ),
                      Text(':', style: TextStyle(fontSize: 30),),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: minutesController,
                          decoration: InputDecoration(
                            hintText: '00',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2)
                          ],
                          onSubmitted: (mins) {
                            try {
                              setState(() {
                                int parsedMins = int.parse(mins);
                                timerSeconds = timerSeconds + (parsedMins*60);
                              });
                            } catch (e) {
                              print('invalid input: $mins');
                            }
                          },
                        ),
                      ),
                      Text(':', style: TextStyle(fontSize: 30),),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: secondsController,
                          decoration: InputDecoration(
                            hintText: '00',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),

                          ],
                          onSubmitted: (secs) {
                            try {
                              setState(() {
                                int parsedSecs = int.parse(secs);
                                timerSeconds = timerSeconds + parsedSecs;
                              });
                            } catch (e) {
                              print('invalid input: $secs');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
