import 'package:flutter/material.dart';
import 'image_view.dart';

class Receipt extends StatefulWidget {
  @override
  _ReceiptState createState() => new _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.symmetric(vertical: 44.0, horizontal: 6.0),
      child: new Card(
        child: new Container(
          width: MediaQuery.of(context).size.width - 96.0,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Column(
                children: <Widget>[
                  new ImageView.singleImage('https://maps.googleapis.com/maps/api/staticmap?center=Ljubljana&zoom=18&size=400x260&maptype=roadmap&markers=color:red%7Clabel:C%46.056896,14.505871&key=AIzaSyCFA9NO1gfGYOaZuGGzFiCtFLH7fTBj-PE'),
                  new Container(
                    padding: new EdgeInsets.only(top: 8.0, right: 16.0, left: 16.0),
                    child: new Row(
                      children: <Widget>[
                        new Text('Thu, 3. Mar 2017, 14:32',
                          style: new TextStyle(fontSize: 12.0, color: Colors.grey[600]),
                        ),
                      ],
                    )
                  )
                ],
              ),
              new Container(
                padding: new EdgeInsets.all(16.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        new Text('3.54 ',
                          style: new TextStyle(fontSize: 36.0),
                        ),
                        new Container(
                          padding: new EdgeInsets.only(left: 8.0, bottom: 2.0),
                          child: new Text('€',
                            style: new TextStyle(fontSize: 24.0, color: Colors.grey[500]),
                          ),
                        )
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          padding: new EdgeInsets.only(top: 12.0),
                          child: new Text('Mercator'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new FlatButton(
                      onPressed: () => print('asdf'), // TODO: neki nared
                      padding: new EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 6.0),
                      child: new Column(
                        children: <Widget>[
                          new Icon(
                            Icons.image,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          new Text('View',
                              style: new TextStyle(
                                  fontSize: 11.0,
                                  color: Theme.of(context).primaryColorDark))
                        ],
                      )),
                  new FlatButton(
                      onPressed: () => print('asdf'), // TODO: neki nared
                      padding: new EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 6.0),
                      child: new Column(
                        children: <Widget>[
                          new Icon(
                            Icons.map,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          new Text('Maps',
                              style: new TextStyle(
                                  fontSize: 11.0,
                                  color: Theme.of(context).primaryColorDark))
                        ],
                      )),
                  new FlatButton(
                      onPressed: () => print('asdf'), // TODO: neki nared
                      padding: new EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 6.0),
                      child: new Column(
                        children: <Widget>[
                          new Icon(
                            Icons.delete,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          new Text('Delete',
                              style: new TextStyle(
                                  fontSize: 11.0,
                                  color: Theme.of(context).primaryColorDark))
                        ],
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
