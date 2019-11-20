import 'dart:convert';

class User {
    Body body;
    String type;

    User({
        this.body,
        this.type,
    });

    factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory User.fromJson(Map<String, dynamic> json) => User(
        body: Body.fromJson(json["body"]),
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "body": body.toJson(),
        "type": type,
    };
}

class Body {
    String uid;
    String pass;

    Body({
        this.uid,
        this.pass,
    });

    factory Body.fromRawJson(String str) => Body.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Body.fromJson(Map<String, dynamic> json) => Body(
        uid: json["uid"],
        pass: json["pass"],
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "pass": pass,
    };
}
