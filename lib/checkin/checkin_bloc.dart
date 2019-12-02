import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_login/authentication/authentication.dart';
import 'package:flutter_login/checkin/checkin.dart';
import 'package:user_repository/user_repository.dart';

import 'package:flutter_beacon/flutter_beacon.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';


class CheckinBloc extends Bloc<CheckinEvent, CheckinState>{
  final CheckInRepository checkInRepository;
  final AuthenticationBloc authenticationBloc;

  CheckinBloc({
    @required this.checkInRepository,
    @required this.authenticationBloc,
  })
      : assert(checkInRepository != null),
        assert(authenticationBloc != null);

  @override
  CheckinState get initialState => CheckinInitial();

  @override
  Stream<CheckinState> mapEventToState(CheckinEvent event) async* {
    if (event is CheckinButtonPressed) {
      yield CheckinLoading();

      try {
//        /// need to call the class MyApp and pass the UUID but it has errors
//        var route = new MaterialPageRoute(
//            builder: (BuildContext context) =>
//                new MyApp(UUID: '39ed98ff-2900-441a-802f-9c398fc199d2'),
//        );
//        Navigator.push(build(BuildContext context){return;}), route)
        /// scan for teacher here
        //final session_token = await bluetoothstuff.scanforsession();
//        final checkin_result = await checkInRepository.checkin(
//            pid: event.pid,
//            hwid: "hey",
//            token: "newtoken",
//            //teacher's session token
//            class_name: "kdjal",
//            name: "Name isn't passed in"
//        );
        // authenticationBloc.add(CheckedIn(token: token));
        yield CheckinInitial();
      } catch (error) {
        yield CheckinFailure(error: error.toString());
      }
    }
  }
}