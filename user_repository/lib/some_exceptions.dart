import 'package:flutter/semantics.dart';

class ApiError implements Exception {
  String errorMessage(String s) {
    return s;
  }
@override
  String toString(){
    return "Login failed";
  }
}