import 'dart:convert';

class Body {
  String token;
  String class_name;
  String pid;
  String name;
  String hwid;

  Body({this.token, this.class_name, this.pid, this.name, this.hwid});

  Body.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    class_name = json['class_name'];
    pid = json['pid'];
    name = json['name'];
    hwid = json['hwid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['class_name'] = this.class_name;
    data['pid'] = this.pid;
    data['name'] = this.name;
    data['hwid'] = this.hwid;
    return data;
  }
}
