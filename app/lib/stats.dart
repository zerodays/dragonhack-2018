import 'package:flutter/material.dart';
import 'api.dart';
import 'chart.dart';

class Stats extends StatefulWidget {
  Stats({Key key}) : super(key: key);

  @override
  StatsState createState() => new StatsState();
}

class StatsState extends State<Stats> {
  List<Chart> charts;

  @override
  void initState() {
    charts = [];
    getCharts();
    super.initState();
  }

  getCharts() async {
    var c = await getStatics();
    setState(() {
      charts = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: new Container(
          child: new Text(
            'Swipe up for scan history',
            style: new TextStyle(color: Colors.grey[500]),
          ),
          padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: new PageView(
            reverse: true, scrollDirection: Axis.horizontal, children: charts));
  }
}
