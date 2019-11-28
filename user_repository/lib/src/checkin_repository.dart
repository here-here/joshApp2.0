import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../checkin_model.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../some_exceptions.dart';




class CheckInRepository {

  Future<String> checkin({
    @required String token,
    @required String classid,
    @required String pid,
    @required String hwid,
    @required String name,


  }) async {
    String url = "http://10.0.2.2:80/api/classes/validateToken/";
   
   
   Body b = Body(token: token, name: name, hwid: hwid, pid: pid);
    var bod = json.encode(b.toJson());
     var response = await post(url,bod, "");
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
	return " ";
    }

    

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