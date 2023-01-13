import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:reminder_timer/model/timer_entity.dart';

import '../page/home_page.dart';
import '../main.dart';

class BigCard extends StatefulWidget {
  TimerEntity? timer;

  BigCard(this.timer) {
    timer ??= TimerEntity(name: '', description: '', interval: 0);
  }

  @override
  State<BigCard> createState() => _BigCardState(timer!);
}

class _BigCardState extends State<BigCard> {
  final TimerEntity timer;

  _BigCardState(this.timer);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Set up your timer'),
          Card(
            color: Colors.cyan[100],
            child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter timer name',
                            label: Text('Name')),
                        initialValue: widget.timer?.name,
                        onChanged: (value) {
                          setState(() {
                            timer.name = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter timer description',
                            label: Text('Description')),
                        initialValue: widget.timer?.description,
                        onChanged: (value) {
                          setState(() {
                            timer.description = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter minutes interval',
                            label: Text('Timer Interval')),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        initialValue: widget.timer?.interval.toString(),
                        onChanged: (value) {
                          setState(() {
                            timer.interval = int.parse(value);
                          });
                        },
                      ),
                    ),
                  ],
                )),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  if(widget.timer?.id != null) {
                    appState.updateEntity(widget.timer);
                  } else {
                    appState.saveEntity(widget.timer);
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder:
                          (context) => MyHomePage())
                  );
                },
                icon: widget.timer?.id != null
                    ? Icon(Icons.update)
                    : Icon(Icons.save_rounded),
                label: Text(widget.timer?.id != null ? 'Update' : 'Save'),
              ),
              SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {
                  appState.deleteEntity(widget.timer);
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder:
                          (context) => MyHomePage())
                  );
                },
                icon: Icon(Icons.delete_forever_rounded),
                label: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
