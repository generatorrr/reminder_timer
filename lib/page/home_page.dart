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
    selectedIndex = 1;
  }

  MyHomePage.goToPage(this.selectedIndex) {
    timer ??= TimerEntity(name: '', description: '', interval: 0);
    selectedIndex ??= 1;
  }

  MyHomePage.allArgsConstructor(this.timer, this.selectedIndex) {
    timer ??= TimerEntity(name: '', description: '', interval: 0);
    selectedIndex ??= 1;
  }
  @override
  State<MyHomePage> createState() => _MyHomePageState(selectedIndex!, timer!);
}

class _MyHomePageState extends State<MyHomePage> {

  int selectedIndex = 1;
  TimerEntity timer;


  _MyHomePageState(this.selectedIndex, this.timer);

  @override
  Widget build(BuildContext context) {
    Widget page = getPage(timer);

    return LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            body: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.savings_sharp),
                        label: Text('Saved'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.timer),
                        label: Text('Active Timers'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {

                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: page,
                  ),
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
        page = TimerCreationPage(timer);
        break;
      case 1:
        page = FavouritesPage();
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