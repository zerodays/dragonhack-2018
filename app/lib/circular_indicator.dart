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
    } on SocketException {
      print('Error internet disconnected');
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
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }
}
