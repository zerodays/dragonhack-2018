import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'receipt.dart';

const String serverIp = 'http://46.101.179.230:8080';

String totalPrice = '0.00';

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
  Map data = await getRequest(new Uri.https(serverIp, 'history/'));
  
  totalPrice = data['total'];

  return data['receipts'].cast<Map<String, dynamic>>();
}

