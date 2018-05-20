import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'image_view.dart';
import 'receipt_view.dart';

class Receipt extends StatefulWidget {
  final Map receipt;

  Receipt(this.receipt);

  @override
  _ReceiptState createState() => new _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  @override
  Widget build(BuildContext context) {
    String vendor = widget.receipt['vendor'];
    String id = widget.receipt['id'];
    double price = widget.receipt['price'];
    String datetime = formatDate(widget.receipt['time']);
    String lat = widget.receipt['lat'];
    String lon = widget.receipt['lon'];

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
                  new ImageView.singleImage(getMapUrl(lat, lon)),
                  new Container(
                    padding: new EdgeInsets.only(top: 8.0, right: 16.0, left: 16.0),
                    child: new Row(
                      children: <Widget>[
                        new Text(datetime,
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
                        new Text(
                          new NumberFormat.currency(
                            locale: 'en',
                            symbol: ''
                          ).format(price),
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
                          child: new Text(vendor),
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
                      onPressed: () => Navigator.of(context).push(
                        new PageRouteBuilder(
                          pageBuilder: (BuildContext context, Animation _, Animation __) => new ReceiptView(id),
                          transitionsBuilder: (BuildContext context, Animation<double> animation,
                            Animation _, Widget child) => new FadeTransition(
                                opacity: animation,
                                child: child
                            )
                        )
                      ),
                      padding: new EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 6.0),
                      child: new Column(
                        children: <Widget>[
                          new Icon(
                            Icons.image,
                            color: Theme.of(context).primaryColor,
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
                            color: Theme.of(context).primaryColor,
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
                            color: Theme.of(context).primaryColor,
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

String getMapUrl(String lat, String lon) {
  return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat, $lon&zoom=18&size=400x260&maptype=roadmap&markers=color:red|$lat,$lon&key=AIzaSyCFA9NO1gfGYOaZuGGzFiCtFLH7fTBj-PE';
}

String formatDate(double timestamp) {
  var datetime = DateTime.fromMillisecondsSinceEpoch(1000 * timestamp.toInt());
  return new DateFormat('E d. MMM,  hh:mm').format(datetime);
}