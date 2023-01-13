import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:reminder_timer/model/ActiveTimer.dart';
import 'package:reminder_timer/page/home_page.dart';

import '../main.dart';

class FavouritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    appState.updateDbAndNotifyListeners();
    var savedTimers = appState.savedList;

    if (savedTimers.isEmpty) {
      return Center(
        child: Text('No reminders yet.'),
      );
    }

    return Center(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('You have '
                '${savedTimers.length} favorites:'),
          ),
          for (var timer in savedTimers)
            Container(
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(width: 1, color: Colors.black.withOpacity(0.2)),
              )),
              child: Row(
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MyHomePage.allArgsConstructor(timer, 0))),
                    icon: Icon(Icons.edit),
                    label: Text(''),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () => {
                      appState
                          .addActiveTimer(ActiveTimer(timer, timer.interval)),
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage.goToPage(2)))
                    },
                    icon: Icon(Icons.start),
                    label: Text(''),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Wrap(
                      children: [
                        Text(
                          timer.name,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
