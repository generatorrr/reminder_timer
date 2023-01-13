import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder_timer/model/timer_entity.dart';

import '../animation/custom_timer_painter.dart';
import 'dart:isolate';

const String portName = "MyAppPort";
void showNotification(int alarmId) async {
  SendPort? sendPort = IsolateNameServer.lookupPortByName(portName);
  if(sendPort != null) {
    sendPort.send(alarmId);
  }
}

class CountDownTimer extends StatefulWidget {

  TimerEntity timerEntity;

  CountDownTimer(this.timerEntity);

  @override
  _CountDownTimerState createState() => _CountDownTimerState(timerEntity);
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  TimerEntity timerEntity;
  late AnimationController controller;

  _CountDownTimerState(this.timerEntity);

  String get timerString {
    Duration duration = controller.duration! * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: timerEntity.interval),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white10,
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.amber,
                    height:
                        controller.value * MediaQuery.of(context).size.height,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: CustomPaint(
                                      painter: CustomTimerPainter(
                                    animation: controller,
                                    backgroundColor: Colors.white,
                                    color: themeData.indicatorColor,
                                  )),
                                ),
                                Align(
                                  alignment: FractionalOffset.center,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          timerEntity.name,
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          timerString,
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      AnimatedBuilder(
                          animation: controller,
                          builder: (context, child) {
                            return FloatingActionButton.extended(
                                onPressed: () {
                                  if (controller.isAnimating) {
                                    AndroidAlarmManager.cancel(timerEntity.id!);
                                    controller.reset();
                                  } else {
                                    AndroidAlarmManager.periodic(
                                        Duration(minutes: timerEntity.interval),
                                        timerEntity.id!,
                                        showNotification,
                                        allowWhileIdle: true, wakeup: true);
                                    reverseTimerRecursively();
                                  }
                                },
                                icon: Icon(controller.isAnimating
                                    ? Icons.stop
                                    : Icons.play_arrow),
                                label: Text(
                                    controller.isAnimating ? "Stop" : "Play"));
                          }),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  Future<void> reverseTimerRecursively() async {
    controller
        .reverse(from: controller.value == 0.0 ? 1.0 : controller.value)
        .then((void value) async {
      reverseTimerRecursively();
    });
  }
}
