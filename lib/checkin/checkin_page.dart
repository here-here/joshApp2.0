import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/home/text.dart';
import 'package:user_repository/user_repository.dart';

import 'package:flutter_login/authentication/authentication.dart';
import 'package:flutter_login/checkin/checkin.dart';
import 'check_in.dart';


class CheckinPage extends StatelessWidget {
  final CheckInRepository checkInRepository;

  CheckinPage({Key key, @required this.checkInRepository})
      : assert(checkInRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.amber[600],
        title: Text(
            "Check into class",
            style: headerTextStyle,
        ),
      ),
      body: BlocProvider(
        builder: (context) {
          return CheckinBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            checkInRepository: checkInRepository,
          );
        },
        child:
          ListView(
            children: <Widget>[
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Container(
                    color: Colors.amber[600],
                    child: Center(
                      child: 
                        Stack(
                          children: <Widget>[
                            // Stroked text as border
                            Text(
                              "Check into class",
                              style: headerTextStyle.copyWith(fontSize: 30)
                            ),
                            // White text for filler
                           
                          ],
                        )
                    ),
                  ),
                ),
              ),
              Center(
                child:
                  CheckinForm()
              )
            ],

          ),
          
      ),
      backgroundColor: Colors.white,
    );
  }
}
