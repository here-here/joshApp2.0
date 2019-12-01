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
        /// need to call the class MyApp and pass the UUID but it has errors
        var route = new MaterialPageRoute(
            builder: (BuildContext context) =>
                new MyApp(UUID: '39ed98ff-2900-441a-802f-9c398fc199d2'),
        );
        Navigator.push(build(BuildContext context){return;}), route)
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
class MyApp extends StatefulWidget {
  final String UUID;

  MyApp({Key key, this.UUID}) : super (key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String id;
  String searchUUID = '39ed98ff-2900-441a-802f-9c398fc199d2';
  final String region = "com.attendhere.beacon";
  final StreamController<BluetoothState> streamController = StreamController();
  StreamSubscription<BluetoothState> _streamBluetooth;
  StreamSubscription<RangingResult> _streamRanging;
//  final _regionBeacons = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];
  bool authorizationStatusOk = false;
  bool locationServiceEnabled = false;
  bool bluetoothEnabled = false;
  bool started;
//  BeaconBroadcast beaconBroadcast = BeaconBroadcast();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();

    return listeningState();
  }

  listeningState() async {
    print("starting");
    print("${widget.UUID}");
    id = await makeDeviceID();
    print(id);
//    Future<bool> result;
    print('Listening to bluetooth state');
    _streamBluetooth = flutterBeacon
        .bluetoothStateChanged()
        .listen((BluetoothState state) async {
      print('BluetoothState = $state');
      streamController.add(state);

      switch (state) {
        case BluetoothState.stateOn:
          initScanBeacon();
          break;
        case BluetoothState.stateOff:
          await pauseScanBeacon();
          await checkAllRequirements();
          break;
      }
    });
//    return result;
  }

  checkAllRequirements() async {
    final bluetoothState = await flutterBeacon.bluetoothState;
    final bluetoothEnabled = bluetoothState == BluetoothState.stateOn;
    final authorizationStatus = await flutterBeacon.authorizationStatus;
    final authorizationStatusOk =
        authorizationStatus == AuthorizationStatus.allowed ||
            authorizationStatus == AuthorizationStatus.always;
    final locationServiceEnabled =
    await flutterBeacon.checkLocationServicesIfEnabled;

    setState(() {
      this.authorizationStatusOk = authorizationStatusOk;
      this.locationServiceEnabled = locationServiceEnabled;
      this.bluetoothEnabled = bluetoothEnabled;
    });
  }

  initScanBeacon() async {
    await flutterBeacon.initializeScanning;
    await checkAllRequirements();
    if (!authorizationStatusOk ||
        !locationServiceEnabled ||
        !bluetoothEnabled) {
      print('RETURNED, authorizationStatusOk=$authorizationStatusOk, '
          'locationServiceEnabled=$locationServiceEnabled, '
          'bluetoothEnabled=$bluetoothEnabled');
      return;
    }
    final regions = <Region>[
      Region(
        identifier: region,
        proximityUUID: searchUUID,
      ),
    ];

    if (_streamRanging != null) {
      if (_streamRanging.isPaused) {
        _streamRanging.resume();
        return;
      }
    }

    _streamRanging =
        flutterBeacon.ranging(regions).listen((RangingResult result) {
//          print(result);
          if (result != null) {
            var itt = result.beacons.iterator;
            while (itt.moveNext()) {
              var currentBeacon = itt.current;
              if (currentBeacon.proximityUUID.toLowerCase() == searchUUID.toLowerCase()) {
                print('found beacon');
                // this means a valid beacon is found

                // stop searching
                pauseScanBeacon();

                /// This is where we hit the api to register then navigate to the next screen
              }
            }
          }
//          return false;
        });
//    return false;
  }

  pauseScanBeacon() async {
    _streamRanging?.pause();
    if (_beacons.isNotEmpty) {
      setState(() {
        _beacons.clear();
      });
    }
  }

//  int _compareParameters(Beacon a, Beacon b) {
//    int compare = a.proximityUUID.compareTo(b.proximityUUID);
//
//    if (compare == 0) {
//      compare = a.major.compareTo(b.major);
//    }
//
//    if (compare == 0) {
//      compare = a.minor.compareTo(b.minor);
//    }
//
//    return compare;
//  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print('AppLifecycleState = $state');
    if (state == AppLifecycleState.resumed) {
      if (_streamBluetooth != null && _streamBluetooth.isPaused) {
        _streamBluetooth.resume();
      }
      await checkAllRequirements();
      if (authorizationStatusOk && locationServiceEnabled && bluetoothEnabled) {
        await initScanBeacon();
      } else {
        await pauseScanBeacon();
        await checkAllRequirements();
      }
    } else if (state == AppLifecycleState.paused) {
      _streamBluetooth?.pause();
    }
  }

  @override
  void dispose() {
//    WidgetsBinding.instance.removeObserver(this);
    streamController?.close();
    _streamRanging?.cancel();
    _streamBluetooth?.cancel();
    flutterBeacon.close;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Scaffold(
          body: Container(
//            decoration: BoxDecoration(
//              image: DecorationImage(
////                  image: AssetImage("assets/images/Logo.png"),
//                  fit: BoxFit.cover),
//            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
//                  TextSection(Text('Here Here')),
//                  TextSection(Text('Attendance')),
                  RaisedButton(
//                        padding: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 5.0),
                    color: Colors.blue,
                    child: Text("Test"),
                    onPressed: () {
//                      myFunction();
                    },
                  ),
                  RaisedButton(
                    color: Colors.red,
                    child: Text("get beacons"),
                    onPressed: () async {
                      await flutterBeacon.requestAuthorization;
                    },
                  ),
                ],
              ),
            ),
          )

      ),
    );
  }

  static Future<List<String>> getDeviceDetails() async {
    print('running deviceinfo');
    String deviceName;
    String deviceVersion;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId;
      }
      else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor;
      }
    }
    on PlatformException {
      print('Failed to get platform version');
    }

    return [deviceName, deviceVersion, identifier];
  }

  static Future<String> makeDeviceID() async {
    List<String> temp = await getDeviceDetails();
    String retVal = "";

    var itt = temp.iterator;

    while (itt.moveNext()){
      retVal += itt.current;
    }

    return retVal;
  }
}