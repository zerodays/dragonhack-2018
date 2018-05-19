import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera_view.dart';
import 'stats.dart';

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
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.cyan,
        accentColor: Colors.tealAccent[400]
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
    List<Widget> alreadyScanned = getAlreadyScanned();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Ime tripa na kerem sm'),
      ),
      drawer: new Drawer(
          child: new ListView(
        children: <Widget>[
          new DrawerHeader(
            child: new Text('Header'),
          ),
          new ListTile(
            title: new Text('First Menu Item'),
            onTap: () {},
          ),
          new ListTile(
            title: new Text('Second Menu Item'),
            onTap: () {},
          ),
          new Divider(),
          new ListTile(
            title: new Text('About'),
            onTap: () {},
          ),
        ],
      )),
      body: new PageView(scrollDirection: Axis.vertical, children: [
        new Stats(),
        new Container(color: Colors.blue),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: new Container(
        padding: new EdgeInsets.only(left: 132.0, right: 132.0, bottom: 22.0),
        child: new RaisedButton(
          color: Theme.of(context).accentColor,
          onPressed: () => Navigator.of(context).push(
            new MaterialPageRoute(builder: (context) => new CameraView()),
          ),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0)),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Icon(Icons.add),
              new Text('Scan new',
                style: new TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ), // to-formatting nicer for build methods.
    );
  }

  // TODO: download data, probably async?
  List<ListTile> getAlreadyScanned() {
    return [
      new ListTile(
        title: new Text('Mercator, 4.26€'),
      )
    ];
  }
}
