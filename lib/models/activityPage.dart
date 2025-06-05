import 'package:burnboss/models/stopwatch.dart';
import 'package:burnboss/models/timer_activity_player.dart';
import 'package:flutter/material.dart';
import 'activity.dart';

class ActivityPage extends StatefulWidget {
  final Activity activity;
  final ValueChanged<bool> onSetPageViewInteraction;

  const ActivityPage(
      {super.key, required this.activity, required this.onSetPageViewInteraction});

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentSet = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: _currentSet,
      length: widget.activity.rest > Duration.zero
          ? widget.activity.sets * 2 - 1
          : widget.activity.sets,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access the current theme
    ThemeData theme = Theme.of(context);

    // Determine if the theme is light
    bool isLightTheme = theme.brightness == Brightness.light;
    // Set the color based on the theme
    Color cardColor = isLightTheme ? Colors.white : Colors.grey[800]!;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  widget.activity.activityName,
                  style: const TextStyle(fontFamily: 'Bebas', fontSize: 50),
                ),
              ),
            ),
          ),
          if (widget.activity.activityType == 'Reps')
            Expanded(
              flex: 3,
              child: GestureDetector(
                onPanStart: (_) {
                  widget.onSetPageViewInteraction(true);
                },
                onPanEnd: (_) {
                  widget.onSetPageViewInteraction(false);
                },
                child: Card(
                  color: cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.grey, width: 0.5),
                  ),
                  child: SizedBox(
                    height: 250,
                    width: 300,
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            itemCount: widget.activity.rest > Duration.zero
                                ? widget.activity.sets * 2 - 1
                                : widget.activity.sets,
                            itemBuilder: (context, index) {
                              if (widget.activity.rest > Duration.zero) {
                                if (index % 2 == 0) {
                                  int setIndex = index ~/ 2;
                                  return setCard(widget.activity, setIndex);
                                } else {
                                  return restCard(widget.activity);
                                }
                              } else {
                                return setCard(widget.activity, index);
                              }
                            },
                            onPageChanged: (int set) {
                              setState(() {
                                _currentSet = set ~/ 2;
                                _tabController.animateTo(set);
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TabPageSelector(
                            controller: _tabController,
                            indicatorSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (widget.activity.activityType == 'Timer')
            ActivityTimer(
              key: GlobalKey<ActivityTimerState>(),
              initialTime: widget.activity.time,
            ),
          if (widget.activity.activityType == 'Stopwatch')
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: ActivityStopwatch(),
            ),
          const Expanded(
            flex: 2,
            child: SizedBox(),
          )
        ],
      ),
    );
  }

  Widget setCard(Activity activity, int setIndex) {
    ThemeData theme = Theme.of(context);
    bool isLightTheme = theme.brightness == Brightness.light;
    Color textColor = isLightTheme ? const Color(0xffF0A897) : const Color(0xff0D99A9);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Set ${setIndex + 1}',
            style: TextStyle(fontFamily: 'Bebas', fontSize: 30, color: textColor),
          ),
        ),
        Center(
          child: Column(
            children: [
              Text.rich(TextSpan(children: [
                const TextSpan(
                  text: 'Reps: ',
                  style: TextStyle(fontFamily: 'Bebas', fontSize: 35),
                ),
                TextSpan(
                  text: '${widget.activity.reps}',
                  style: const TextStyle(fontFamily: 'Bebas', fontSize: 45),
                )
              ])),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'At weight: ',
                      style: TextStyle(fontFamily: 'Bebas', fontSize: 35),
                    ),
                    TextSpan(
                      text: '${widget.activity.weights}',
                      style: const TextStyle(fontFamily: 'Bebas', fontSize: 45),
                    ),
                    const TextSpan(
                      text: ' Kg',
                      style: TextStyle(fontFamily: 'Bebas', fontSize: 35),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget restCard(Activity activity) {
    ThemeData theme = Theme.of(context);
    bool isLightTheme = theme.brightness == Brightness.light;
    Color textColor = isLightTheme ? const Color(0xffF0A897) : const Color(0xff0D99A9);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Rest:',
              style: TextStyle(fontFamily: 'Bebas', fontSize: 30, color: textColor),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ActivityTimer(
              key: GlobalKey<ActivityTimerState>(), initialTime: activity.rest)
        ],
      ),
    );
  }
}
