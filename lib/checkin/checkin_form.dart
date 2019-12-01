import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_login/home/text.dart';
import 'package:flutter_login/checkin/checkin.dart';
//import 'package:flutter_login/register/register.dart';

import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:async';

class CheckinForm extends StatefulWidget {
  final String uuid;

  CheckinForm({Key key, this.uuid}) : super (key: key);

  @override
  State<CheckinForm> createState() => _checkinFormState();
}

class _checkinFormState extends State<CheckinForm> with WidgetsBindingObserver {
  final _pidController = TextEditingController();
  final _classController = TextEditingController();
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

  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();

//    searchUUID = widget.uuid;

    return listeningState();
  }

  listeningState() async {
    print("starting");
//    print("${widget.UUID}");
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
              if (currentBeacon.proximityUUID.toLowerCase() ==
                  searchUUID.toLowerCase()) {
                print('found beacon');
                // this means a valid beacon is found

                // stop searching
                pauseScanBeacon();

                Navigator.pop(context);

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

    while (itt.moveNext()) {
      retVal += itt.current;
    }

    return retVal;
  }

  @override
  Widget build(BuildContext context) {
//    _onCheckinButtonPressed() {
//      BlocProvider.of<CheckinBloc>(context).add(
//        CheckinButtonPressed(
//          pid: _pidController.text,
//          class_name: _classController.text,
//        ),
//      );
//    }

    return BlocListener<CheckinBloc, CheckinState>(
      listener: (context, state) {
        if (state is CheckinFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<CheckinBloc, CheckinState>(
        builder: (context, state) {
          return Form(
            child:
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child:
                    TextFormField(
                      decoration: new InputDecoration(
                        labelText: "Enter PID",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                        //fillColor: Colors.green
                      ),
                      controller: _pidController,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
                    child:
                      TextFormField(
                        decoration: new InputDecoration(
                        labelText: "Enter Class ID",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(
                        ),
                        ),
                        //fillColor: Colors.green
                        ),
                      controller: _classController,
                      ),
                    ),
                  RaisedButton(
                    onPressed: () async {
                      initState();
//                      await flutterBeacon.requestAuthorization;
//                      state is! CheckinLoading ? _onCheckinButtonPressed : null,
                    },
                    child: Text('checkin'),
                  ),

                  Container(
                    child: state is CheckinLoading
                        ? CircularProgressIndicator()
                        : null,
                  ),
                ],
              ),
          );
        },
      ),
    );
  }
}
