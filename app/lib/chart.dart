import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'details.dart';
import 'package:intl/intl.dart';

class Chart extends StatefulWidget {
  Map<String, dynamic> data;

  Chart(this.data);

  @override
  _ChartState createState() => new _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> vendors = widget.data['vendors'];
    List<String> vendornames = vendors.keys.toList();
    List vendorvalues = vendors.values.toList();

    List<CircularStackEntry> plotData = <CircularStackEntry>[
    new CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(vendorvalues[0], Colors.cyan[100]),
        new CircularSegmentEntry(vendorvalues[1], Colors.cyan[300]),
        new CircularSegmentEntry(vendorvalues[2], Colors.cyan[600]),
        new CircularSegmentEntry(vendorvalues[3], Colors.teal[200]),
        new CircularSegmentEntry(vendorvalues[4], Colors.tealAccent[100]),
      ],
    )];

    return new Stack(
      alignment: Alignment.center,
      children: <Widget>[
        new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              height: 109.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(widget.data['month'], style: TextStyle(fontSize: 22.0)),
                      new Container(width: 8.0),
                      new Text(widget.data['year'].toString(),
                          style: TextStyle(
                              fontSize: 22.0, color: Colors.grey[400])),
                    ],
                  ),
                  new Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    alignment: WrapAlignment.center,
                    children: [
                      new Chip(
                        backgroundColor: Colors.transparent,
                        avatar: new Icon(Icons.brightness_1,
                            size: 18.0, color: Colors.cyan[100]),
                        label: new Text(vendornames[0]),
                      ),
                      new Chip(
                        backgroundColor: Colors.transparent,
                        avatar: new Icon(Icons.brightness_1,
                            size: 18.0, color: Colors.cyan[300]),
                        label: new Text(vendornames[1]),
                      ),
                      new Chip(
                        backgroundColor: Colors.transparent,
                        avatar: new Icon(Icons.brightness_1,
                            size: 18.0, color: Colors.cyan[600]),
                        label: new Text(vendornames[2]),
                      ),
                      new Chip(
                        backgroundColor: Colors.transparent,
                        avatar: new Icon(Icons.brightness_1,
                            size: 18.0, color: Colors.teal[200]),
                        label: new Text(vendornames[3]),
                      ),
                      new Chip(
                        backgroundColor: Colors.transparent,
                        avatar: new Icon(Icons.brightness_1,
                            size: 18.0, color: Colors.tealAccent[100]),
                        label: new Text(vendornames[4]),
                      )
                    ],
                  )
                ],
              ),
            ),
            new AnimatedCircularChart(
                size: const Size(300.0, 300.0),
                initialChartData: plotData,
                chartType: CircularChartType.Radial,
                edgeStyle: SegmentEdgeStyle.round,
                percentageValues: false),
            new Container(
              height: 60.0,
            ),
          ],
        ),
        new FlatButton(
          onPressed: () => Navigator.of(context).push(
                new MaterialPageRoute(builder: (context) => new Details()),
              ), //TODO
//            splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: new Container(
            height: MediaQuery.of(context).size.height,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    new Container(height: 40.0),
                    new Hero(
                        tag: 'tag:',
                        //TODO: tale tag mora bit za usak mesec drgacn
                        child: new Material(
                          color: Colors.transparent,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              new Text(

                                new NumberFormat.currency(
                                  locale: 'en',
                                  symbol: ''
                                ).format(widget.data['total']),

                                // TODO: tole mora bit hero na novo stran
                                style: new TextStyle(
                                    fontSize: 46.0,
                                    fontWeight: FontWeight.normal),
                              ),
                              new Container(
                                padding:
                                    new EdgeInsets.only(left: 8.0, bottom: 2.0),
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
                        )),
                    new Text(
                      'Tap for more',
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
