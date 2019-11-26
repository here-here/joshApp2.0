export 'check_in.dart';
import 'package:flutter/material.dart';

class CheckIn extends StatelessWidget{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check In'),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: CheckInForm()
        )
      )
    );
  }
}

class CheckInForm extends StatefulWidget{
  CheckInForm({Key key}) : super(key: key);

  @override
  _CheckInFormState createState() => _CheckInFormState();
}

class _CheckInFormState extends State<CheckInForm>{
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'PID',
              labelStyle: TextStyle(color: Colors.white)
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'PID is required.';
              }
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'ClassID',
              labelStyle: TextStyle(color: Colors.white)
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'ClassID is required.';
              }
            },
          ),
          Row(
            children: <Widget>[
              Spacer(),
              OutlineButton(
                highlightedBorderColor: Colors.white,
                onPressed: _submit,
                child: Text('Check In', style: TextStyle(color: Colors.white))
              )
            ],
          )
        ],
      )
    );
  }

  void _submit() {
    _formKey.currentState.validate();

    // Check the student in
    
  }
}

