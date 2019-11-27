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
    String username;
    String password;

    Body({
        this.username,
        this.password,
    });

    factory Body.fromRawJson(String str) => Body.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Body.fromJson(Map<String, dynamic> json) => Body(
        username: json["username"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
    };
}
