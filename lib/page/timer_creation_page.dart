import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../model/timer_entity.dart';
import '../widget/big_card_widget.dart';

class TimerCreationPage extends StatefulWidget {
  TimerEntity? timer;

  TimerCreationPage(this.timer) {
    timer ??= TimerEntity(name: '', description: '', interval: 0);
  }
  @override
  State<TimerCreationPage> createState() => _TimerCreationPageState(timer!);
}

class _TimerCreationPageState extends State<TimerCreationPage> {
  final TimerEntity timer;

  _TimerCreationPageState(this.timer);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(timer),
        ],
      ),
    );
  }
}