import 'dart:convert';

import 'package:http/http.dart' as http;

// const String domain = 'cookbooknoip.zapto.org';
const String ip = '100.81.200.212';
const String port = '3000';
const String rootUrl = 'http://$ip:$port/';

void callApi(String path, Function success, Function failed, [Map body]) {
  Function genericResponse = (http.Response response) {
    Map pack = jsonDecode(response.body);
    if (pack['success'])
      success(pack['value']);
    else {
      print('requestAccount call failed');
      failed(pack['value']); //value would be string in failed cases
    }
  };

  if (body == null) {
    http.get(rootUrl + path).then(genericResponse);
  } else {
    String jsonString = jsonEncode(body);
    http.post(rootUrl + path, body: jsonString).then(genericResponse);
  }
}

void callRequestAccount(
    {Function(Map responseMap) success, Function(String error) failed}) {
  callApi('requestAccount', success, failed);
}

void callChangeName(String id, String token, String name,
    {Function(Map responseMap) success, Function(String error) failed}) {
  return callApi(
      'changeName', success, failed, {'id': id, 'token': token, 'name': name});
}
