import 'package:reminder_timer/model/timer_entity.dart';

class ActiveTimer {
  final TimerEntity timerEntity;
  int willBeExecutedInMinutes;

  ActiveTimer(this.timerEntity, this.willBeExecutedInMinutes);

  @override
  String toString() {
    return 'ActiveTimer{timerEntity: $timerEntity, willBeExecutedInMinutes: $willBeExecutedInMinutes}';
  }
}