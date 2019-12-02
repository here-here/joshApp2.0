import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_login/home/text.dart';
import 'package:flutter_login/checkin/checkin.dart';
//import 'package:flutter_login/register/register.dart';

import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:device_info/device_info.dart';
import 'dart:async';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

class CheckinForm extends StatefulWidget {
  @override
  State<CheckinForm> createState() => _checkinFormState();
}

class _checkinFormState extends State<CheckinForm> {
  final _pidController = TextEditingController();
  final _classController = TextEditingController();
  final _nameController = TextEditingController();

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
                Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child:
                TextFormField(
                  decoration: new InputDecoration(
                    labelText: "Enter Your Name",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(
                      ),
                    ),
                    //fillColor: Colors.green
                  ),
                  controller: _nameController,
                )
                ),
                RaisedButton(
                  onPressed: () async {
                    // Check if text was entered
                    if (_pidController.text.length > 0 &&_classController.text.length > 0 && _nameController.text.length > 1) {
                      /// navigate to search screen
                      var route = new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new MyApp(uuid: '39ed98ff-2900-441a-802f-9c398fc199d2',
                            pid: _pidController.text,
                            classCode: _classController.text,
                            name: _nameController.text),
                      );
                      var result = await Navigator.push(context, route);
                      if (result == "checked in")
                        Navigator.pop(context);
                      else {
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("ERROR!", style: TextStyle(color: Colors.red), textAlign: TextAlign.center),
                              content: Text(result),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Okay'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          },
                        );
                      }
                    }
                    else {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text("Please enter the values for all fields!"),
                          );
                        },
                      );
                    }
                    },

                  child: Text('Check In'),
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

class MyApp extends StatefulWidget {
  final String uuid;
  final String pid;
  final String classCode;
  final String name;

  MyApp({Key key, this.uuid, this.pid, this.classCode, this.name}) : super (key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String id;
  String searchUUID;
  final String region = "com.attendhere.beacon";
  final StreamController<BluetoothState> streamController = StreamController();
  StreamSubscription<BluetoothState> _streamBluetooth;
  StreamSubscription<RangingResult> _streamRanging;
  final _beacons = <Beacon>[];
  bool authorizationStatusOk = false;
  bool locationServiceEnabled = false;
  bool bluetoothEnabled = false;
  bool started;

  @override
  void initState() {
    if (widget.uuid != null) {
      searchUUID = widget.uuid;
    }
    WidgetsBinding.instance.addObserver(this);

    super.initState();

    listeningState();
  }

  listeningState() async {
    print("starting");
    id = await makeDeviceID();
    print(id);
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

                // Call checkin API
                print("Navigating");

                navigate();

              }
            }
          }
        });
  }

  navigate() async {
    print("hitting!");
    var url = 'https://www.attendhere.com/api/classes/validateToken';
    var response = await http.post(url, body: {'token': widget.uuid, 'name': widget.name, 'hwid': id, 'pid': widget.pid});
    if (response.statusCode == 200) {
      print("successfully hit");
      Navigator.pop(context, "success!");
    }
    else {
      print("post error");
      print(response.body);
      Navigator.pop(context, "Please try again!\nIf the issue persists please inform the Professor!");
    }
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
    WidgetsBinding.instance.removeObserver(this);
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
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/knighttro.jpg"),
                  fit: BoxFit.cover),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RaisedButton(
                    color: Colors.red,
                    child: Text("Search for Beacons!"),
                    onPressed: () async {
                      await flutterBeacon.requestAuthorization;
                      Navigator.pop(context);
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

    while (itt.moveNext()) {
      retVal += itt.current;
    }

    return retVal;
  }
}