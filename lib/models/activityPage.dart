import 'package:burnboss/models/stopwatch.dart';
import 'package:burnboss/models/timer_activity_player.dart';
import 'package:flutter/material.dart';
import 'activity.dart';

class ActivityPage extends StatefulWidget {
  final Activity activity;
  final ValueChanged<bool> onSetPageViewInteraction;

  ActivityPage(
      {required this.activity, required this.onSetPageViewInteraction});

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
      length: widget.activity.sets,
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
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              widget.activity.activityName,
              style: TextStyle(fontFamily: 'Bebas', fontSize: 50),
            ),
          ),
          if (widget.activity.activityType == 'Reps')
            GestureDetector(
              onPanStart: (_) {
                widget.onSetPageViewInteraction(true);
              },
              onPanEnd: (_) {
                widget.onSetPageViewInteraction(false);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.grey, width: 0.5),
                ),
                child: SizedBox(
                  height: 250,
                  width: 300,
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          itemCount: widget.activity.sets,
                          itemBuilder: (context, setIndex) {
                            return setCard(widget.activity, setIndex);
                          },
                          onPageChanged: (int set) {
                            setState(() {
                              _currentSet = set;
                              _tabController.animateTo(set);
                            });
                          },
                        ),
                      ),
                      TabPageSelector(
                        controller: _tabController,
                      ),
                    ],
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
        ],
      ),
    );
  }

  Widget setCard(Activity activity, int setIndex) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Set ${setIndex + 1}: ${activity.reps} Reps',
            style: TextStyle(fontFamily: 'Bebas', fontSize: 40),
          ),
        ],
      ),
    );
  }
}