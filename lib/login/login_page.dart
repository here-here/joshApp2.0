import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/home/text.dart';
import 'package:user_repository/user_repository.dart';

import 'package:flutter_login/authentication/authentication.dart';
import 'package:flutter_login/login/login.dart';
import 'package:flutter_login/checkin/checkin.dart';
import 'check_in.dart';


class LoginPage extends StatelessWidget {
  final UserRepository userRepository;
  final CheckInRepository checkInRepository;

  LoginPage({Key key, @required this.userRepository, @required this.checkInRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        builder: (context) {
          return LoginBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            userRepository: userRepository,
          );
        },
        child:
          ListView(
            children: <Widget>[
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: Container(
                   
                    color: Colors.amber[600],
                    child: Center(
                      child: 
                        Stack(
                          children: <Widget>[
                            // Stroked text as border
                            Text(
                              "Here Here",
                              style: headerTextStyle.copyWith(fontSize: 60)
                            ),
                            // White text for filler
                            Text(
                              'Here Here',
                              style: headerTextStyle.copyWith(fontSize: 60)
                            )
                          ],
                        )
                    ),
                  ),
                ),
              ),
              Center(
                child:
                  LoginForm()
              ),
              Center(
                child:
                  Padding(
                    padding: EdgeInsets.all(110),
                    child:
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckinPage(checkInRepository: checkInRepository),
                              settings: RouteSettings(),
                            )
                          );
                        },
                        child:
                          Text('Check In', style: TextStyle(color: Colors.black))
                      )
                  ) 
                  //CheckIn()
              )
            ],

          ),
          
      ),
      backgroundColor: Colors.white,
    );
  }
}
