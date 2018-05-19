import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'receipt.dart';

const String serverIp = 'http://46.101.179.230:8080';

Future<Null> uploadImage(String fileName) async {
  File imageFile = new File(fileName);

  var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  var length = await imageFile.length();

  var uri = Uri.parse(serverIp + '/recognize');
  print('uri parsed');

  var request = new http.MultipartRequest('POST', uri);
  var multipartFile = new http.MultipartFile('file', stream, length,
    filename: basename(imageFile.path),
  );
  request.files.add(multipartFile);

  print('request prepared');

  var response = await request.send();
  print(response.statusCode);
  response.stream.transform(utf8.decoder).listen((value) {
    print(value);
  });
}

Future<List<Receipt>> getScannedReciepts() async {
  return [
    new Receipt(
      {'vendor': 'Mercator',
      'price': '34.00',
      'id': 'd21!@LQWe12qwlD12DLAsd',
      'time': '1526760985'
      }
    ),
    new Receipt(
      {'vendor': 'Interspar',
      'price': '2.99',
      'id': 'd21!23423e12qwlD12DLAsd',
      'time': '1526060985'
      }
    ),
    new Receipt(
      {'vendor': 'Hofer',
      'price': '12.45',
      'id': 'd21!@LQsdf12qwlD12DLAsd',
      'time': '1520760985'
      }
    )
  ];
}

