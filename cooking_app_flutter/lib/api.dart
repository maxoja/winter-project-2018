import 'dart:convert';

import 'package:http/http.dart' as http;

import 'widgets/reaction_bar.dart';

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
    String id, String token, String title, String image, String description, List<String> tags, int difficulty,
    {Function(Map responseMap) success, Function(String error) failed}) {
  callApi('postRecipe', success, failed, {
    'id': id,
    'token': token,
    'title': title,
    'image': image,
    'description': description,
    'difficulty': difficulty.toString(),
    'tags': tags.map((ing)=>'"'+ing+'"').toList().toString(),
  });
}

void callGetProfile(String uid, {Function(Map responseMap) success, Function(String error) failed}){
  callApi('getProfile', success, failed,{'id':uid});
}

void callRandomRecipes(String id, {Function(Map responseMap) success, Function(String error) failed}){
  callApi('randomRecipes', success, failed, {
    'id':id
  });
}

//return String
void callCurrentReaction(String uid, String token, String rid, {Function(Map responseMap) success, Function(String error) failed}){
  callApi('currentReaction', success, failed, {
    'uid': uid,
    'token': token,
    'rid': rid,
  });
}

void callSetReaction(String uid, String token, Reaction reaction, String rid, {Function(Map responseMap) success, Function(String error) failed}){
  callApi('setReaction', success, failed, {
    'uid': uid,
    'token': token,
    'reaction': reaction.toString().toUpperCase().split('.')[1],
    'rid': rid,
  });
}

//difficulty = 0,1,2,10
void callSearch(String title, List<String> tags, int difficulty, {Function(Map responseMap) success, Function(String error) failed}){
  callApi('search', success, failed, {
    'title':title,
    'order':"NEW",
    'tags': tags.map((t)=>'"'+t+'"').toList().toString(),
    'difficulty': difficulty.toString(),
  });
}