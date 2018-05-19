import 'package:flutter/material.dart';
import 'package:zoomable_image/zoomable_image.dart';
import 'api.dart';

class ReceiptView extends StatelessWidget {
  final String imageId;

  ReceiptView(this.imageId);

  @override
  Widget build(BuildContext context) {
    return new ZoomableImage(
      new NetworkImage(serverIp + '/' + imageId + '.jpg'),
      backgroundColor: Colors.black,
      placeholder: new Container(),
    );
  }
}