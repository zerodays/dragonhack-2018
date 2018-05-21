import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'receipt.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'chart.dart';
import 'global.dart';

const String serverIp = 'http://46.101.179.230:8080';

var location = new Location();

Future<Null> uploadImage(String fileName) async {
  // find user location
  Map<String, double> loc;
  try {
    loc = await location.getLocation;
  } on PlatformException {
    print('get location failed');
    loc = null;
  }

  String lat, lon;
  if (loc == null) {
    lat =  46.050163.toString();
    lon = 14.468868.toString();
  } else {
    lat = loc["latitude"].toString() ?? 46.050163.toString();
    lon = loc["longitude"].toString() ?? 14.468868.toString();
  }

  File imageFile = new File(fileName);

  var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  var length = await imageFile.length();

  var uri = Uri.parse(serverIp + '/recognize?lat=$lat&lon=$lon');
  print('uri parsed');

  var request = new http.MultipartRequest('POST', uri);
  var multipartFile = new http.MultipartFile('file', stream, length,
    filename: basename(imageFile.path),
  );
  request.files.add(multipartFile);

  print('request prepared');

  var response = await request.send();

  response.stream.transform(utf8.decoder).listen((value) {
    print('Request completed');
  });

  reload();

  if (response.statusCode == 200) {
    showSnackbar('Receipt scanned!');
  } else {
    showSnackbar('Something went wrong...');
  }
}

getRequest(Uri uri, {decodeJson: true}) async {
  var httpClient = new HttpClient();
  var request = await httpClient.getUrl(uri);
  var response = await request.close();
  var responseBody = await response.transform(utf8.decoder).join();
  if (decodeJson)
    return json.decode(responseBody);
  else
    return responseBody;
}

Future<List<Receipt>> getScannedReciepts() async {
  Map data = await getRequest(Uri.parse(serverIp + '/history'));  
  
  List<Map> d = data['receipts'].cast<Map>();
  
  var dd = d.map(
    (Map map) => new Receipt(map)
  ).toList().reversed.toList();
  return dd;
}

Future<List<Chart>> getStatics() async {
  Map data = await getRequest(Uri.parse(serverIp + '/statistics'));

  List<Map<String, dynamic>> months = data['statistics'].cast<Map<String, dynamic>>();
  return months.map(
    (Map map) => new Chart(map)
  ).toList();
}

Future<void> deleteReceipt(String id) async {
  var uri = Uri.parse(serverIp + '/delete?id=$id');
  
  var httpClient = new HttpClient();
  var request = await httpClient.getUrl(uri);
  var response = await request.close();

  reload();
}