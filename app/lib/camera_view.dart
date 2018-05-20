import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'circular_indicator.dart';
import 'api.dart';

List<CameraDescription> cameras;

class CameraView extends StatefulWidget {
  @override
  createState() => new _CameraViewState();
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CameraViewState extends State<CameraView> {
  CameraController controller;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    initCamera(cameras[0]);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          // crop camera previewr
          new OverflowBox(
              maxWidth: double.infinity,
              alignment: Alignment.center,
              child: new FractionallySizedBox(
                alignment: Alignment.center,
                child: cameraPreview(),
                heightFactor: 1.0,
              )),

          // take picture
          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: captureButton(context),
          )
        ],
      ),
    );
  }

  Future<Null> initCamera(CameraDescription camera) async {
    controller = new CameraController(camera, ResolutionPreset.high);

    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) print('Camera error.');
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) setState(() {});
  }

  Widget cameraPreview() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return new AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: new CameraPreview(controller),
      );
    }
  }

  Widget captureButton(BuildContext context) => new FlatButton(
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(35.0)),
      padding: new EdgeInsets.all(0.0),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: controller != null &&
              controller.value.isInitialized &&
              !controller.value.isRecordingVideo
          ? () => onTakePictureButtonPressed(context)
          : null,
      child: new Image.asset('assets/camera.png', height: 70.0, width: 70.0));
//  );

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  void onTakePictureButtonPressed(BuildContext context) {
    takePicture().then((String filePath) {
      if (mounted) {
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new CircularInidicator(() async {
                    await uploadImage(filePath);
                    Navigator.pop(context);
                  })),
        );
      }
    });
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      logError('', 'Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await new Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      logError(e.code, e.description);
      return null;
    }
    return filePath;
  }
}
