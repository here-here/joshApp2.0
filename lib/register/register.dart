export 'register.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: RegisterForm()
        )
      )
    );
  }
}

class RegisterForm extends StatefulWidget{
  RegisterForm({Key key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm>{
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool idgood = false;
  bool passgood = false;

  @override
  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Username'
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'Username is required.';
              }
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'Password is required.';
              }
            },
          ),
          Row(
            children: <Widget>[
              Spacer(),
              OutlineButton(
                highlightedBorderColor: Colors.black,
                onPressed: _submit,
                child: Text('Register')
              )
            ],
          )
        ],
      )
    );
  }

  void _submit() {
    _formKey.currentState.validate();
  }
}

