import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

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
