import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class CircularInidicator extends StatefulWidget {
  final Function function;

  // calls function and waits for function to complete
  CircularInidicator(this.function);

  @override
  _IndicatorState createState() => new _IndicatorState();
}

class _IndicatorState extends State<CircularInidicator> {
  
  Future<Null> callFunction() async {
    try {
      await widget.function();
    } on SocketException catch (e) {
      print(e.toString());
    } on FormatException catch (e) {
      print(e.toString());
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    callFunction();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    print(Theme.of(context));
    return new Container(
      color: Colors.white,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            width: 200.0,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Image.asset('assets/cloud_load.gif'),
                new Text('Processing in the cloud ...', textAlign: TextAlign.center, style: new TextStyle(inherit: true, fontSize: 18.0, color: Colors.grey[800], fontWeight: FontWeight.normal))
              ],
            )
          )
        ],
      )
    );
  }
}
