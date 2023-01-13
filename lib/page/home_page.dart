import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reminder_timer/page/active_timers_page.dart';
import 'package:reminder_timer/page/timer_creation_page.dart';

import 'favourites_page.dart';
import '../model/timer_entity.dart';

class MyHomePage extends StatefulWidget {
  TimerEntity? timer;
  int? selectedIndex;

  MyHomePage() {
    timer = TimerEntity(name: '', description: '', interval: 0);
    selectedIndex = 0;
  }

  MyHomePage.goToPage(this.selectedIndex) {
    timer ??= TimerEntity(name: '', description: '', interval: 0);
    selectedIndex ??= 0;
  }

  MyHomePage.allArgsConstructor(this.timer, this.selectedIndex) {
    timer ??= TimerEntity(name: '', description: '', interval: 0);
    selectedIndex ??= 0;
  }
  @override
  State<MyHomePage> createState() => _MyHomePageState(selectedIndex!, timer!);
}

class _MyHomePageState extends State<MyHomePage> {

  int selectedIndex = 0;
  TimerEntity timer;


  _MyHomePageState(this.selectedIndex, this.timer);

  @override
  Widget build(BuildContext context) {
    Widget page = getPage(timer);

    return LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: page,
                  ),
                ),
                BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.savings_sharp),
                      label: 'Saved',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.add_alarm_outlined),
                      label: 'Create',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.timer),
                      label: 'Active Timers',
                    ),
                  ],
                  unselectedItemColor: Colors.grey,
                  selectedItemColor: Colors.indigoAccent,
                  currentIndex: selectedIndex,
                  onTap: (value) {

                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  Widget getPage(TimerEntity timer) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = FavouritesPage();
        break;
      case 1:
        page = TimerCreationPage(timer);
        break;
      case 2:
        page = ActiveTimersPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return page;
  }
}