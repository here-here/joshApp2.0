import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/home/text.dart';
import 'package:flutter_login/login/login.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonPressed(
          username: _usernameController.text,
          password: _passwordController.text,
        ),
      );
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Form(
            child:
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
                    child:
                    TextFormField(
                      decoration: InputDecoration(labelText: 'username'),
                      controller: _usernameController,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
                    child:                   
                      TextFormField(
                      decoration: InputDecoration(
                        
                        border: InputBorder.none,
                        focusColor: Colors.black,
                        hoverColor: Colors.black,
                         labelStyle: headerTextStyle.copyWith(color: Colors.white),
                         hintStyle: headerTextStyle.copyWith(color: Colors.white),
                         //prefixIcon: Icon(Icons.vpn_key),
                        // fillColor: Colors.grey,
                         filled: true,

                        ),
                         
                      controller: _passwordController,
                      obscureText: true,
                      ),
                    ),
                  RaisedButton(
                    onPressed:
                        state is! LoginLoading ? _onLoginButtonPressed : null,
                    child: Text('Login'),
                  ),
                  Container(
                    child: state is LoginLoading
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
