import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageView extends StatelessWidget {
  final List<String> imageNames;
  final int fadeDuration;
  final Color backgroundColor;

  ImageView(this.imageNames):
        fadeDuration = 200,
        backgroundColor = Colors.red;

  ImageView.singleImage(String singleImageName, {
    this.backgroundColor  // default color if left null
  }):
        imageNames = [singleImageName],
        fadeDuration = 100;

  @override
  Widget build(BuildContext context) {
    if (imageNames.length == 0) {  // should not actually happen
      return new AspectRatio(
          aspectRatio: 400 / 260,
          child: new Center(
            child: new Text('No image to show.'),
          )
      );
    }

    if (imageNames.length == 1) {  // if there is only one image
      return new AspectRatio(
          aspectRatio: 400 / 260,
          child: new Container(
            child: new FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: imageNames[0],
              fadeInDuration: new Duration(milliseconds: fadeDuration),  // shorter fade in duration
              fadeOutDuration: const Duration(milliseconds: 0),  // transparent image fadeOut is boring
            ),
            color: backgroundColor,
          )
      );
    }

    // Create tab controller if multiple images have to be displayed.
    final TabController controller = DefaultTabController.of(context);

    return new DefaultTabController(
        length: imageNames.length,
        child: new Stack(
          alignment: const Alignment(0.5, 1.0),
          children: <Widget>[
            new AspectRatio(
              aspectRatio: 400 / 260,
              child: new TabBarView(
                  children: imageNames.map((String imageName) {
                    return new Container(
                      color: backgroundColor,
                      child: new FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: imageName,
                        fadeInDuration: new Duration(milliseconds: fadeDuration),  // shorter fade in duration
                        fadeOutDuration: const Duration(milliseconds: 0),  // transparent image fadeOut is boring
                      ),
                    );
                  }).toList()
              ),
            ),
            new Align(
                alignment: Alignment.bottomCenter,
                child: new Padding(
                  padding: new EdgeInsets.only(bottom: 4.0),
                  child: new TabPageSelector(controller: controller,
                      indicatorSize: 8.0,
                      selectedColor: Colors.white),
                )
            ),
          ],
        )
    );
  }
}
