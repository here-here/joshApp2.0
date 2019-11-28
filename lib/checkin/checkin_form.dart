import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/home/text.dart';
import 'package:flutter_login/checkin/checkin.dart';
import 'package:flutter_login/register/register.dart';

class CheckinForm extends StatefulWidget {
  @override
  State<CheckinForm> createState() => _checkinFormState();
}

class _checkinFormState extends State<CheckinForm> {
  final _pidController = TextEditingController();
  final _classController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _onCheckinButtonPressed() {
      BlocProvider.of<CheckinBloc>(context).add(
        CheckinButtonPressed(
          pid: _pidController.text,
          classid: _classController.text,
        ),
      );
    }

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
                      decoration: InputDecoration(
                        hintText: 'PID',
                        hintStyle: TextStyle(fontSize: 15.0, color: Colors.yellow[400]),
                      //  fillColor: Colors.black,
                        focusColor: Colors.white,
                        hoverColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow[400], width: 2.0)
                        )
                      ),
                      controller: _pidController,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
                    child:                   
                      TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Class ID',
                        hintStyle: TextStyle(fontSize: 15.0, color: Colors.yellow[400]),
                        border: InputBorder.none,
                         //labelStyle: headerTextStyle.copyWith(color: Colors.white),
                         //hintStyle: headerTextStyle.copyWith(color: Colors.white),
                         //prefixIcon: Icon(Icons.vpn_key),
                        // fillColor: Colors.grey,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.yellow[400], width: 2.0)
                          )
                        ),   
                      controller: _classController,
                      obscureText: true,
                      ),
                    ),
                  RaisedButton(
                    onPressed:
                        state is! CheckinLoading ? _onCheckinButtonPressed : null,
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
