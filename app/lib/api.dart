import 'dart:async';
import 'dart:convert';
import 'dart:io';

const baseUrl = 'www.google.com';

getRequest(Uri uri, {decodeJson: true}) async {
  var httpClient = new HttpClient();
  var request = await httpClient.getUrl(uri);
  var response = await request.close();
  var responseBody = await response.transform(utf8.decoder).join();
  if (decodeJson) return json.decode(responseBody);
  else return responseBody;
}

Future<dynamic> uploadImage(String imagePath) async {
  Map data = await getRequest(new Uri.https(
    baseUrl, 'upload'
  ));
  return data;
}

