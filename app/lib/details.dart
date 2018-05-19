import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => new _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('May 2018'),
          centerTitle: true,
        ),
        body: new ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            new Container(
              height: MediaQuery.of(context).size.height - 150.0,
              color: Colors.transparent,
            ),
            new Card(
              elevation: 4.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(0.0)),
              margin: new EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
              child: new Container(
                padding: new EdgeInsets.all(16.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text('TOTAL:', style: new TextStyle(fontSize: 18.0),),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        new Text(
                          '3.54 ', // TODO: tole mora bit hero na novo stran
                          style: new TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.normal),
                        ),
                        new Container(
                          padding: new EdgeInsets.only(left: 8.0, bottom: 2.0),
                          child: new Text(
                            '€',
                            style: new TextStyle(
                                fontSize: 20.0,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.normal),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
