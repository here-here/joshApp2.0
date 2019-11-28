import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_login/authentication/authentication.dart';
import 'package:flutter_login/checkin/checkin.dart';
import 'package:user_repository/user_repository.dart';

class CheckinBloc extends Bloc<CheckinEvent, CheckinState> {
  final CheckInRepository checkInRepository;
  final AuthenticationBloc authenticationBloc;

  CheckinBloc({
    @required this.checkInRepository,
    @required this.authenticationBloc,
  })  : assert(checkInRepository != null),
        assert(authenticationBloc != null);

  @override
  CheckinState get initialState => CheckinInitial();

  @override
  Stream<CheckinState> mapEventToState(CheckinEvent event) async* {
    if (event is CheckinButtonPressed) {
      yield CheckinLoading();

      try {

        /// scan for teacher here
        final checkin_result = await checkInRepository.checkin(
          pid: event.pid,
          hwid: "hey",
          token: "newtoken", //teacher's session token
          class_name: "kdjal",
          name: "Name isn't passed in"
        );
       // authenticationBloc.add(CheckedIn(token: token));
        yield CheckinInitial();
      } catch (error) {
        yield CheckinFailure(error: error.toString());
      }
    }
  }
}
