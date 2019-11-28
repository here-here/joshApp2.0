import 'dart:async';
import 'dart:convert';
import 'package:user_repository/fileIO.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'screen_args.dart';
import 'broadcast.dart';
import 'dart:io';
//import 'package:native_widgets/native_widgets.dart';
//import 'package:scoped_model/scoped_model.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:uuid/uuid.dart';


Future<List<Course>> fetchCourses(http.Client client) async {
    final token = await readToken().timeout(const Duration(milliseconds: 500),); 
      Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json", 
      HttpHeaders.authorizationHeader: "Bearer $token",
    };

    print("-------------");
    print(token);
      print("-------------");
  final response =
      await client.get('http://10.0.2.2:80/api/classes/classes/',headers: headers);
    Map<String, String> args = {
      "body": response.body, 
      "token" : token
    };

  // Use the compute function to run parseCourses in a separate isolate
  return compute(parseCourses,args );
}

// A function that will convert a response body into a List<Course>
List<Course> parseCourses(Map<String,String> args) {
  final body = jsonDecode(args["body"]);
  final lst = body["classes"];
  //final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  final List<String> parsed = (lst as List<dynamic>).cast<String>();

  return parsed.map<Course>((json) => Course(title: json, token: args["token"])).toList();
}

class Course {
  final String title;
  final String token;

  Course({this.title, this.token});
  

  // factory Course.fromJson(Map<String, dynamic> json) {
  //   return Course(
  //     title: json['name'] as String,
  //   );
  
}



class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(title, style: headerTextStyle,overflow: TextOverflow.ellipsis),
      ),
      body: Padding(
        child: FutureBuilder<List<Course>>(
          future: fetchCourses(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? CoursesList(Courses: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
        padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
      ),
    );
  }
}

class CoursesList extends StatelessWidget {
  final List<Course> Courses;

  CoursesList({Key key, this.Courses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    List colors = [Colors.green[400], Colors.deepPurple[400], Colors.orange[400], Colors.red[400], Colors.brown[500]];
    return ListView.builder(
      itemCount: Courses.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 1.2,
              margin: EdgeInsets.only(top:3.0),
                color: Colors.white,
                alignment: Alignment.center,
                child: Card(
                  color: colors[index % colors.length],
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(Courses[index].title, style: headerTextStyle,overflow: TextOverflow.ellipsis,),
                        subtitle: Text("Place holder", style: subHeaderTextStyle),
                      ),
                      ButtonTheme.bar(
                        // make buttons use the appropriate styles for cards
                        child: ButtonBar(
                          children: <Widget>[                         
                            FlatButton(
                            //color: Colors.white,
                            child: new Icon(Icons.bluetooth, color: Colors.white),
                             onPressed: () {
                                  // When the user taps the button, navigate to the specific route
                                  // and provide the arguments as part of the RouteSettings.
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BroadCast(),
                                      // Pass the arguments as part of the RouteSettings. The
                                      // ExtractArgumentScreen reads the arguments from these
                                      // settings.
                                      settings: RouteSettings(
                                        arguments: ScreenArguments(
                                          Courses[index].title,
                                          Courses[index].token
                                        ),
                                      ),
                                    ),
                                  );
                                },
                            ),
                           FlatButton(
                            //color: Colors.white,
                            child: new Icon(Icons.assignment, color: Colors.white),
                             onPressed: () {
                                  // When the user taps the button, navigate to the specific route
                                  // and provide the arguments as part of the RouteSettings.
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BroadCast(),
                                      // Pass the arguments as part of the RouteSettings. The
                                      // ExtractArgumentScreen reads the arguments from these
                                      // settings.
                                      settings: RouteSettings(
                                        arguments: ScreenArguments(
                                          Courses[index].title,
                                          Courses[index].token,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                ),
          ],
        );
      },
    );
  }
}



final baseTextStyle = const TextStyle(
  fontFamily: 'Poppins'
);

final headerTextStyle = baseTextStyle.copyWith(
  color:  Colors.white,
  fontSize: 24.0,
  fontWeight: FontWeight.w600
);

final regularTextStyle = baseTextStyle.copyWith(
  color: Colors.white,
  fontSize: 12.0,
  fontWeight: FontWeight.w400
);

final subHeaderTextStyle = regularTextStyle.copyWith(
  fontSize: 14.0
);