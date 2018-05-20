import 'package:flutter/material.dart';
import 'bar_chart.dart';
import 'package:intl/intl.dart';

class Details extends StatefulWidget {
  final Map<String, dynamic> data;

  Details(this.data);

  @override
  _DetailsState createState() => new _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    List<double> spentPerWeekday = widget.data['weekdays'].values.toList().cast<double>();

    List<Widget> expenseHistory = widget.data['vendors'].keys.toList().map(
      (String vendorname) => new Container(
        padding: new EdgeInsets.only(bottom: 14.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(vendorname, style: new TextStyle(fontSize: 16.0),),
            new Text(widget.data['vendors'][vendorname].toString() + ' €',
              style: new TextStyle(color: Colors.grey[600],
              fontSize: 15.0),
            )
          ],
        ),
      ),
    ).toList().cast<Widget>();

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.data['month'] + ' ' + widget.data['year'].toString()),
          centerTitle: true,
        ),
        body: new ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            new Container(
                height: MediaQuery.of(context).size.height - 150.0,
                color: Colors.transparent,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      'Average spent on each day of week:',
                      textAlign: TextAlign.center,
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    new Container(height: 32.0),
                    new Container(
                        padding: new EdgeInsets.fromLTRB(24.0, 0.0, 10.0, 0.0),
                        height: 240.0,
                        child: new BarChart(spentPerWeekday)
                      )
                  ],
                )),
            new Card(
              elevation: 4.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(0.0)),
              margin: new EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
              child: new Container(
                padding: new EdgeInsets.all(16.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text(
                          'TOTAL:',
                          style: new TextStyle(fontSize: 18.0),
                        ),
                        new Hero(
                            tag: 'tag',
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
                                        fontSize: 28.0,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  new Container(
                                    padding: new EdgeInsets.only(
                                        left: 8.0, bottom: 2.0),
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
                            ))
                      ],
                    ),
                    new Container(height: 8.0),
                    new Divider(),
                    new Container(height: 16.0),

                    new Column(
                      children: expenseHistory
                    )

                  ],
                ),
              ),
            )
          ],
        ));
  }
}
