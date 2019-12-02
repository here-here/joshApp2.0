import 'dart:developer';

import 'package:shimmer/shimmer.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screen_args.dart';
import 'package:flutter/material.dart';
import 'courses.dart';
import 'buttons.dart';

class BroadCast extends StatelessWidget
{

  static const routeName = '/broadcast';
  bool started = false;
  @override
  Widget build(BuildContext context) {

    final ScreenArguments args = ModalRoute.of(context).settings.arguments;

        final CounterBloc bp = CounterBloc();
    Size size = MediaQuery.of(context).size;
    double height = size.height/1.5;
    return Scaffold(
      body:
      Center(
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(0),
              child:
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 1.2,
                  color: Colors.amber[100],
                  child: 
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: 
                  Align(
                    alignment: Alignment.centerLeft,
                    child:
                    Text(
                      "Ready",
                       style: subHeaderTextStyle
                       )
                  )
                  )
                      ),
            ),
            Padding(
            padding: EdgeInsets.all(8.0),
            child:
            Container(
              width: MediaQuery.of(context).size.width / 1.2,
              height: 250,
              color: Colors.red[400],
              child: 
                BlocProvider<CounterBloc>(
                  builder: (context) => bp,
                  child: CounterPage(),
                 )
 
             // child: Center(child:  Text("Waiting...", style: headerTextStyle.copyWith(fontSize: 30))),
            ),
            ),
            ActionButton(bp: bp, height: 100, title: "Broadcast ", icon: Icon(Icons.bluetooth, color: Colors.white,)).build(context),
          ],
        )
      )

    );
  }
}