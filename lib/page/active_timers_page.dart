import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../widget/count_down_timer_widget.dart';

class ActiveTimersPage extends StatefulWidget {
  @override
  State<ActiveTimersPage> createState() => _ActiveTimersPageState();
}

class _ActiveTimersPageState extends State<ActiveTimersPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var activeTimers = appState.activeTimers;

    if (activeTimers.isEmpty) {
      return Center(
        child: Text('No active timers yet.'),
      );
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (ctx, constraints) {
          return SafeArea(
            child: Wrap(
              runSpacing: 5,
              children: <Widget>[
                for (var timer in activeTimers)
                  SizedBox(
                    height: (constraints.maxHeight / activeTimers.length) * 0.9,
                    width: (constraints.maxWidth / activeTimers.length) * 0.9,
                    child: CountDownTimer(timer.timerEntity),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
