import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'chart.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class Stats extends StatefulWidget {
  @override
  _StatsState createState() => new _StatsState();
}

class _StatsState extends State<Stats> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: new Container(
          child: new Text(
            'Swipe up for scan history.',
            style: new TextStyle(color: Colors.grey[500]),
          ),
          padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: new Chart()
    );
  }
}
