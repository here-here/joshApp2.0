import 'dart:convert';

class Body {
  String token;
  String classid;
  String pid;
  String name;
  String hwid;

  Body({this.token, this.classid, this.pid, this.name, this.hwid});

  Body.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    classid = json['classid'];
    pid = json['pid'];
    name = json['name'];
    hwid = json['hwid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['classid'] = this.classid;
    data['pid'] = this.pid;
    data['name'] = this.name;
    data['hwid'] = this.hwid;
    return data;
  }
}
