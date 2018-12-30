import 'dart:convert';

import 'package:http/http.dart' as http;

// const String domain = 'cookbooknoip.zapto.org';
const String ip = '100.81.200.212';
const String port = '3000';
const String rootUrl = 'http://$ip:$port/';

void callApi(String path, Function success, Function failed, [Map body]) {
  Function genericResponse = (http.Response response) {
    print(response.body);
    Map pack = jsonDecode(response.body);
    if (pack['success']) {
      print('$path call success');
      print(pack['value']);
      success(pack['value']);
    } else {
      print('$path call failed');
      failed(pack['value']); //value would be string in failed cases
    }
  };

  if (body == null) {
    print('call api $path without body\n $body');
    http.get(rootUrl + path).then(genericResponse);
  } else {
    print('call api $path with body\n $body');
    http.post(rootUrl + path, body: body).then(genericResponse);
  }
}

void callRequestAccount(
    {Function(Map responseMap) success, Function(String error) failed}) {
  callApi('requestAccount', success, failed);
}

void callChangeName(String id, String token, String name,
    {Function(Map responseMap) success, Function(String error) failed}) {
  callApi('changeName', success, failed, {
    'id': id,
    'token': token,
    'name': name,
  });
}

void callPostRecipe(
    String id, String token, String title, String image, int difficulty,
    {Function(Map responseMap) success, Function(String error) failed}) {
  callApi('postRecipe', success, failed, {
    'id': id,
    'token': token,
    'title': title,
    'image': image,
    'difficulty': difficulty.toString(),
  });
}
