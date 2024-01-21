import 'package:burnboss/models/activity.dart';
import 'package:burnboss/theme/theme_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class editActivity extends StatefulWidget {
  final Activity activity;
  final Function(int) onUpdateReps; // Add callback function
  final Function(int) onUpdateWeight;
  final Function(Duration) onUpdateTime;
  final Function(String) onUpdateActivityName;
  final Function(bool) onUpdateStopwatchUsed;

  editActivity({
    Key? key,
    required this.activity,
    required this.onUpdateReps,
    required this.onUpdateWeight,
    required this.onUpdateTime,
    required this.onUpdateActivityName,
    required this.onUpdateStopwatchUsed,
  }) : super(key: key);

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
  List<String> activityOptions = ['Reps', 'Timer', 'Stopwatch'];
  String? activityOptionSelected = '';

  @override
  void initState() {
    super.initState();
    isSelected = [!widget.activity.weightsUsed, widget.activity.weightsUsed];
    activityOptionSelected = widget.activity.activityType;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.activity.activityName),
      ),
      body: Column(
        children: [
          //Activity Type
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Activity Type:',
                  style: TextStyle(fontFamily: 'Bebas', fontSize: 30),
                ),
                DropdownButton<String>(
                  value: activityOptionSelected,
                  items: activityOptions
                      .map((activityOption) => DropdownMenuItem(
                          value: activityOption,
                          child: Text(activityOption,
                              style: TextStyle(
                                  fontFamily: 'Bebas', fontSize: 20))))
                      .toList(),
                  // onChanged: (activityOption) =>
                  //     setState(() => activityOptionSelected = activityOption),
                  onChanged: (activityOption) {
                    setState(() {
                      activityOptionSelected = activityOption;
                      widget.onUpdateActivityName(activityOption!);
                    });
                  },
                ),
              ],
            ),
          ),
          if (activityOptionSelected == 'Reps')
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
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
                              for (int index = 0;
                                  index < isSelected.length;
                                  index++) {
                                if (index == newIndex) {
                                  setState(() {
                                    widget.activity.weightsUsed = (newIndex ==
                                        1); // Set weightsUsed based on the selected index
                                    isSelected = List.generate(
                                        isSelected.length,
                                        (index) =>
                                            index ==
                                            newIndex); // Update isSelected
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 7,
                              child: Text('Weight (in Kg):',
                                  style: TextStyle(
                                      fontFamily: 'Bebas', fontSize: 30))),
                          Expanded(
                            flex: 3,
                            child: TextField(
                              controller: weightsController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: widget.activity.weights.toString(),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onSubmitted: (weights) {
                                try {
                                  setState(() {
                                    int parsedWeight = int.parse(weights);
                                    widget.onUpdateWeight(parsedWeight);
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 7,
                            child: Text('Reps:',
                                style: TextStyle(
                                    fontFamily: 'Bebas', fontSize: 30))),
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
                ],
              ),
            ),

          if (activityOptionSelected == 'Timer')
            //Time text
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Time:',
                    style: TextStyle(fontSize: 30, fontFamily: 'Bebas'),
                  )),
            ),

          if (activityOptionSelected == 'Timer')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: SizedBox(
                height: 140,
                width: 300,
                child: CupertinoTimerPicker(
                  initialTimerDuration: widget.activity.time,
                  onTimerDurationChanged: (value) {
                    setState(() {
                      Duration TimePickerTime = value;
                      widget.onUpdateTime(TimePickerTime);
                    });
                  },
                ),
              ),
            ),

          if (activityOptionSelected == 'Stopwatch')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: Column(
                children: [
                  Text('Using a stopwatch?', style: TextStyle(fontFamily: 'Bebas', fontSize: 30),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Off', style: TextStyle(fontFamily: 'Bebas', fontSize: 20),),
                      Switch(
                        value: widget.activity.stopwatchUsed,
                        activeColor: COLOR_SECONDARY,
                        onChanged: (bool stopwatchIsUsed) {
                          setState(() {
                            widget.onUpdateStopwatchUsed(stopwatchIsUsed);
                          });
                        },
                      ),
                      Text('On', style: TextStyle(fontFamily: 'Bebas', fontSize: 20),)
                    ],
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
