import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
//import 'package:native_widgets/native_widgets.dart';
//import 'package:scoped_model/scoped_model.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../some_exceptions.dart';
//import '../constants.dart';
import '../userp.dart';
//import '../web_client.dart';


class UserRepository {

  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    String url = "https://qvrptaji88.execute-api.us-east-2.amazonaws.com/apple";
    Body b = Body(pass: password, uid: username);
    User u = User(body: b, type: "login");
     var response = await post(url, u.toRawJson(), "token123"  );
    await Future.delayed(Duration(seconds: 1));
    int statusCode = response.statusCode;

    print(statusCode);
    print("------------");
  // check and respond
    String body = response.body;
    dynamic jbody = jsonDecode(body);
    if(jbody['statusCode'] !=200)
      throw ApiError();

    if(statusCode != 200)
      throw ApiError();
    else
      return jbody['body']['token'];
        }


  


  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> hasToken() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return false;
  }




   Future<dynamic> post(String url, String json, String token) async {
    final String _token = token ?? "";
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json", 
      HttpHeaders.authorizationHeader: "Bearer $token",
    };

  // make POST request
  http.Response response = await http.post(url, headers: headers, body: json);
  return response;

}


}