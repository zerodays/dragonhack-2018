import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera_view.dart';

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
        brightness: Brightness.dark,
        primaryColor: Colors.blue,
        accentColor: Colors.deepOrange,
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
        title: new Text('Reciept Scanner'),
      ),
      body: new ListView(
        children: alreadyScanned,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new CameraView()),
        ),
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
