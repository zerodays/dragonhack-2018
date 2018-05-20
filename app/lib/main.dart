import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera_view.dart';
import 'stats.dart';
import 'history.dart';
import 'global.dart';

Future<Null> main() async {
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Receipts',
      theme: new ThemeData(
        primarySwatch: Colors.cyan,
        accentColor: Colors.tealAccent[400],
        fontFamily: 'OnePlusSlate',
      ),
      home: new MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Receipts'),
        centerTitle: true,
      ),
      body: new PageView(scrollDirection: Axis.vertical, children: [
        new Stats(key: statsKey),
        new History(key: historyKey),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: new Container(
        width: 160.0,
        padding: new EdgeInsets.only(bottom: 20.0),
        child: new RaisedButton(
          color: Theme.of(context).accentColor,
          onPressed: () => Navigator.of(context).push(
            new PageRouteBuilder(
              pageBuilder: (BuildContext context, Animation _, Animation __) => new CameraView(),
              transitionsBuilder: (BuildContext context, Animation<double> animation,
                Animation _, Widget child) => new FadeTransition(
                    opacity: animation,
                    child: child
                )
            ),
          ),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(24.0)),
          child: new Container(
            height: 46.0,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Icon(Icons.add, size: 28.0,),
                new Text('Scan new',
                  style: new TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          )
        ),
      ), // to-formatting nicer for build methods.
    );
  }
}
