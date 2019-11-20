import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/home/text.dart';
import 'package:user_repository/user_repository.dart';

import 'package:flutter_login/authentication/authentication.dart';
import 'package:flutter_login/login/login.dart';

class LoginPage extends StatelessWidget {
  final UserRepository userRepository;

  LoginPage({Key key, @required this.userRepository})
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
                  child:
                   Container(
                    color: Colors.amber[600],
                    child:
                      Center(
                        child:
                          Text("Here Here", style: headerTextStyle.copyWith(fontSize: 50),),
                        ),
                  ),
                ),
              ),
              Center(
                child:
                  LoginForm()
              )
            ],

          ),
          
      ),
    );
  }
}
