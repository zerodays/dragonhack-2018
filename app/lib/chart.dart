import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class Chart extends StatefulWidget {
  @override
  _ChartState createState() => new _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return new Stack(
      alignment: Alignment.center,
      children: <Widget>[
        new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              height: 100.0,
              child: new Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                alignment: WrapAlignment.center,
                children: <Widget>[
                  new Chip(
                    backgroundColor: Colors.transparent,
                    avatar: new Icon(Icons.brightness_1, size: 18.0, color: Colors.cyan[100]),
                    label: new Text('Mercator'),
                  ),
                  new Chip(
                    backgroundColor: Colors.transparent,
                    avatar: new Icon(Icons.brightness_1, size: 18.0, color: Colors.cyan[300]),
                    label: new Text('InterSpar'),
                  ),
                  new Chip(
                    backgroundColor: Colors.transparent,
                    avatar: new Icon(Icons.brightness_1, size: 18.0, color: Colors.cyan[600]),
                    label: new Text('Lidl'),
                  ),
                  new Chip(
                    backgroundColor: Colors.transparent,
                    avatar: new Icon(Icons.brightness_1, size: 18.0, color: Colors.teal[200]),
                    label: new Text('Deichman'),
                  ),
                  new Chip(
                    backgroundColor: Colors.transparent,
                    avatar: new Icon(Icons.brightness_1, size: 18.0, color: Colors.tealAccent[100]),
                    label: new Text('Other'),
                  )
                ],
              ),
            ),
            new AnimatedCircularChart(
                key: _chartKey,
                size: const Size(300.0, 300.0),
                initialChartData: data,
                chartType: CircularChartType.Radial,
                edgeStyle: SegmentEdgeStyle.round,
                percentageValues: false),
            new Container(
              height: 100.0,
            ),
          ],
        ),
        new FlatButton(
          onPressed: () => print('asdf'), //TODO
//            splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: new Container(
            height: MediaQuery.of(context).size.height,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        new Text(
                          '3.54 ', // TODO: tole mora bit hero na novo stran
                          style: new TextStyle(
                              fontSize: 36.0, fontWeight: FontWeight.normal),
                        ),
                        new Container(
                          padding: new EdgeInsets.only(left: 8.0, bottom: 2.0),
                          child: new Text(
                            '€',
                            style: new TextStyle(
                                fontSize: 24.0,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.normal),
                          ),
                        )
                      ],
                    ),
                    new Text(
                      'Tap for more.',
                      style: new TextStyle(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.normal),
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

final GlobalKey<AnimatedCircularChartState> _chartKey =
    new GlobalKey<AnimatedCircularChartState>();
List<CircularStackEntry> data = <CircularStackEntry>[
  new CircularStackEntry(
    <CircularSegmentEntry>[
      new CircularSegmentEntry(500.0, Colors.cyan[100], rankKey: 'Q1'),
      new CircularSegmentEntry(1000.0, Colors.cyan[300], rankKey: 'Q2'),
      new CircularSegmentEntry(2000.0, Colors.cyan[600], rankKey: 'Q3'),
      new CircularSegmentEntry(1000.0, Colors.teal[200], rankKey: 'Q4'),
      new CircularSegmentEntry(1000.0, Colors.tealAccent[100], rankKey: 'Q4'),
    ],
    rankKey: 'Quarterly Profits',
  ),
];
