import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../fileIO.dart';
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
    String url = "https://attendhere.com/api/classes/token/";
    Body b = Body(password: password, username: username);
    User u = User(body: b, type: "login");

    var bod = b.toJson();

     var response = await post(url, b.toRawJson(), "");
    await Future.delayed(Duration(seconds: 1));
    int statusCode = response.statusCode;
    print(response.body);

    print(statusCode);
    print("------------");
  // check and respond
    String body = response.body;
    dynamic jbody = jsonDecode(body);

    if(statusCode != 200)
      throw ApiError();
    else{
      writeToken(jbody['access'].toString());
      writeRefresh(jbody['refresh'].toString());
      return jbody['access'].toString();
    }

    
      
        }






  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    /// 
    /// 
    await writeToken(token);

 
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