import 'package:burnboss/models/activity.dart';
import 'package:burnboss/theme/theme_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class editActivity extends StatefulWidget {
  final Activity activity;
  final Function(int) onUpdateReps; // Add callback function
  final Function(int) onUpdateSets;
  final Function(Duration) onUpdateRest;
  final Function(double) onUpdateWeight;
  final Function(Duration) onUpdateTime;
  final Function(String) onUpdateActivityName;
  final Function(bool) onUpdateStopwatchUsed;

  editActivity({
    Key? key,
    required this.activity,
    required this.onUpdateReps,
    required this.onUpdateSets,
    required this.onUpdateRest,
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
  TextEditingController setsController = TextEditingController();
  TextEditingController weightsController = TextEditingController();

  // TextEditingController timeHoursController = TextEditingController();
  // TextEditingController timeMinutesController = TextEditingController();
  // TextEditingController timeSecondsController = TextEditingController();
  List<bool> activitySelected = [];
  List<String> activityOptions = ['Reps', 'Timer', 'Stopwatch'];
  String? activityOptionSelected = '';
  bool light = true;

  @override
  void initState() {
    super.initState();
    activitySelected = [true, false, false];
    activityOptionSelected = widget.activity.activityType;
    weightsController.text = widget.activity.weights.toString();
    repsController.text = widget.activity.reps.toString();
    setsController.text = widget.activity.sets.toString();
  }

  Widget build(BuildContext context) {
    // Access the current theme
    ThemeData theme = Theme.of(context);

    // Determine if the theme is light
    bool isLightTheme = theme.brightness == Brightness.light;

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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                  color: isLightTheme ? Colors.white : Color(0xFF0E0F0F),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 60,
                              width: 70,
                              child: TextFormField(
                                controller: setsController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                onFieldSubmitted: (sets) {
                                  try {
                                    int parsedSets = int.parse(sets);
                                    widget.onUpdateSets(parsedSets);
                                    print('$setsController');
                                  } catch (e) {
                                    print('Error parsing int $sets');
                                  }
                                },
                              ),
                            ),
                            const Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Sets'),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              width: 70,
                              child: TextField(
                                controller: repsController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                onSubmitted: (reps) {
                                  try {
                                    int parsedReps = int.parse(reps);
                                    widget.onUpdateReps(parsedReps);
                                  } catch (e) {
                                    print('Invalid input: $reps');
                                  }
                                },
                              ),
                            ),
                            const Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Reps'),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              width: 70,
                              child: TextFormField(
                                controller: weightsController,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d{0,2}')),
                                ],
                                onFieldSubmitted: (weights) {
                                  try {
                                    setState(() {
                                      double parsedWeight =
                                          double.parse(weights);
                                      widget.onUpdateWeight(parsedWeight);
                                    });
                                  } catch (e) {
                                    print('Error parsing weight double');
                                  }
                                },
                              ),
                            ),
                            const Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Kg'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          height: 15,
                        ),
                        if (setsController.text.isNotEmpty ||
                            int.tryParse(setsController.text) != 0 ||
                            widget.activity.sets != 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Rest between sets?'),
                              SizedBox(
                                width: 20,
                              ),
                              Switch(
                                value: light,
                                onChanged: (bool value) {
                                  setState(() {
                                    light = value;
                                  });
                                },
                              ),

                            ],
                          ),
                        Visibility(
                          visible: light,
                          // Show the timer picker only when the switch is on
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            child: SizedBox(
                              height: 140,
                              width: 300,
                              child: CupertinoTimerPicker(
                                initialTimerDuration: widget.activity.rest,
                                onTimerDurationChanged: (value) {
                                  setState(() {
                                    Duration TimePickerTime = value;
                                    widget.onUpdateRest(TimePickerTime);
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        // Visibility(
                        //   visible: activityOptionSelected == 'Reps' &&
                        //       (setsController.text.isEmpty ||
                        //           int.tryParse(setsController.text) == 0 ||
                        //           widget.activity.sets == 0),
                        //   child: Padding(
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 30, vertical: 15),
                        //     child: Column(
                        //       children: [
                        //         Text(
                        //           'Rest between sets?',
                        //           style: TextStyle(
                        //               fontFamily: 'Bebas', fontSize: 30),
                        //         ),
                        //         Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceEvenly,
                        //           children: [
                        //             Text(
                        //               'Off',
                        //               style: TextStyle(
                        //                   fontFamily: 'Bebas', fontSize: 20),
                        //             ),
                        //             Switch(
                        //               value: light,
                        //               activeColor: isLightTheme
                        //                   ? COLOR_SECONDARY
                        //                   : DARK_COLOR_PRIMARY,
                        //               onChanged: (bool value) {
                        //                 setState(() {
                        //                   if (setsController.text.isEmpty ||
                        //                       int.tryParse(
                        //                               setsController.text) ==
                        //                           0 ||
                        //                       widget.activity.sets == 0) {
                        //                     light = false;
                        //                   } else {
                        //                     light = value;
                        //                   }
                        //                 });
                        //               },
                        //             ),
                        //             Text(
                        //               'On',
                        //               style: TextStyle(
                        //                   fontFamily: 'Bebas', fontSize: 20),
                        //             )
                        //           ],
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // Visibility(
                        //   visible: light && widget.activity.sets != 0,
                        //   // Show the timer picker only when the switch is on and sets is not 0
                        //   child: Padding(
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 30, vertical: 15),
                        //     child: SizedBox(
                        //       height: 140,
                        //       width: 300,
                        //       child: CupertinoTimerPicker(
                        //         initialTimerDuration: widget.activity.rest,
                        //         onTimerDurationChanged: (value) {
                        //           setState(() {
                        //             Duration TimePickerTime = value;
                        //             widget.onUpdateRest(TimePickerTime);
                        //           });
                        //         },
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  )),
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
                  Text(
                    'Using a stopwatch?',
                    style: TextStyle(fontFamily: 'Bebas', fontSize: 30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Off',
                        style: TextStyle(fontFamily: 'Bebas', fontSize: 20),
                      ),
                      Switch(
                        value: widget.activity.stopwatchUsed,
                        activeColor:
                            isLightTheme ? COLOR_SECONDARY : DARK_COLOR_PRIMARY,
                        onChanged: (bool stopwatchIsUsed) {
                          setState(() {
                            widget.onUpdateStopwatchUsed(stopwatchIsUsed);
                          });
                        },
                      ),
                      Text(
                        'On',
                        style: TextStyle(fontFamily: 'Bebas', fontSize: 20),
                      )
                    ],
                  )
                ],
              ),
            ),

          //NEW DESIGN
        ],
      ),
    );
  }
}
