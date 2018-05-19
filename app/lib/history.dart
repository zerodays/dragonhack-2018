import 'package:flutter/material.dart';
import 'receipt.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => new _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: new Container(
          child: new Text(
            'Pull down for stats.',
            style: new TextStyle(color: Colors.grey[500]),
          ),
          padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
        ),
        body: new Container(
            padding: new EdgeInsets.only(bottom: 70.0),
            child: new ListView(
              padding: new EdgeInsets.only(left: 16.0),
              // This next line does the trick.
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                new Receipt(),
                new Receipt(),
                new Receipt(),
                new Receipt(),
                new Receipt(),
                new Receipt(),
                new Receipt(),
                new Receipt(),
                new Receipt(),
              ],
            )));
  }
}
