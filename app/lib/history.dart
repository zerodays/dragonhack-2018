import 'dart:async';
import 'package:flutter/material.dart';
import 'receipt.dart';
import 'api.dart';

class History extends StatefulWidget {
  History({Key key}): super(key: key);

  @override
  HistoryState createState() => new HistoryState();
}

class HistoryState extends State<History> {
  List<Receipt> receipts;

  @override
  void initState() {
    receipts = [];
    getReceipts();
    super.initState();
  }

  Future<Null> getReceipts() async {
    var rec = await getScannedReciepts();
    if (mounted) setState(() {
      receipts = rec;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: new Container(
          child: new Text(
            'Pull down for stats',
            style: new TextStyle(color: Colors.grey[500]),
          ),
          padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
        ),
        body: new Container(
            padding: new EdgeInsets.only(bottom: 70.0),
            child: new ListView(
              padding: new EdgeInsets.only(left: 16.0, right: 16.0),
              // This next line does the trick.
              scrollDirection: Axis.horizontal,
              children: receipts,
              shrinkWrap: true,
              reverse: true,
            )));
  }
}
