import 'package:flutter/material.dart';

class Receipt extends StatefulWidget {
  @override
  _ReceiptState createState() => new _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.symmetric(vertical: 64.0, horizontal: 16.0),
      child: new Card(
        child: new Container(
          width: MediaQuery.of(context).size.width - 140.0,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Image.network(
                  'https://maps.googleapis.com/maps/api/staticmap?center=Ljubljana&zoom=18&size=400x260&maptype=roadmap&markers=color:red%7Clabel:C%46.056896,14.505871&key=AIzaSyCFA9NO1gfGYOaZuGGzFiCtFLH7fTBj-PE'),
              new Container(
                padding: new EdgeInsets.all(16.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text('asdf'),
                    new Text('asdf'),
                  ],
                ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new FlatButton(
                      onPressed: () => print('asdf'), // TODO: neki nared
                      padding: new EdgeInsets.fromLTRB(2.0, 4.0, 2.0, 6.0),
                      child: new Column(
                        children: <Widget>[
                          new Icon(Icons.image, color: Theme.of(context).primaryColorDark,),
                          new Text('View', style: new TextStyle(fontSize: 11.0, color: Theme.of(context).primaryColorDark))
                        ],
                      )
                  ),
                  new FlatButton(
                      onPressed: () => print('asdf'), // TODO: neki nared
                      padding: new EdgeInsets.fromLTRB(2.0, 4.0, 2.0, 6.0),
                      child: new Column(
                        children: <Widget>[
                          new Icon(Icons.map, color: Theme.of(context).primaryColorDark,),
                          new Text('Maps', style: new TextStyle(fontSize: 11.0, color: Theme.of(context).primaryColorDark))
                        ],
                      )
                  ),
                  new FlatButton(
                      onPressed: () => print('asdf'), // TODO: neki nared
                      padding: new EdgeInsets.fromLTRB(2.0, 4.0, 2.0, 6.0),
                      child: new Column(
                        children: <Widget>[
                          new Icon(Icons.delete, color: Theme.of(context).primaryColorDark,),
                          new Text('Delete', style: new TextStyle(fontSize: 11.0, color: Theme.of(context).primaryColorDark))
                        ],
                      )
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
