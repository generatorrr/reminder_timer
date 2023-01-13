import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:reminder_timer/model/ActiveTimer.dart';
import 'package:reminder_timer/model/timer_entity.dart';
import 'package:reminder_timer/service/database_service.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'page/home_page.dart';
import 'service/notification_service.dart';
import 'dart:isolate';
import 'dart:ui';

final dbService = DataBaseService();
const String portName = "MyAppPort";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await AndroidAlarmManager.initialize();
  await dbService.initializeDB();
  ReceivePort receivePort = ReceivePort();
  IsolateNameServer.registerPortWithName(receivePort.sendPort, portName);
  receivePort.listen((alarmId) async {
    TimerEntity timerEntity = await dbService.getById(alarmId);
    await NotificationService().showNotification(
        timerEntity.id!, timerEntity.name, timerEntity.description);
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Reminder Timer',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var savedList = <TimerEntity>[];
  var activeTimers = <ActiveTimer>[];
  
  void addActiveTimer(ActiveTimer activeTimer) {
    activeTimers.add(activeTimer);
    notifyListeners();
  }

  void removeActiveTimer(ActiveTimer activeTimer) {
    activeTimers.remove(activeTimer);
    notifyListeners();
  }

  void saveEntity(TimerEntity? entity) {
    dbService.create(entity).then((value) => updateDbAndNotifyListeners());
  }

  void updateEntity(TimerEntity? entity) {
    dbService.update(entity!).then((value) => updateDbAndNotifyListeners());
  }

  void deleteEntity(TimerEntity? entity) {
    dbService
        .delete(entity?.id)
        .then((value) => {savedList.remove(entity), notifyListeners()});
  }

  void updateDbAndNotifyListeners() {
    dbService
        .findAll()
        .then((timers) => {savedList = timers, notifyListeners()});
  }
}
