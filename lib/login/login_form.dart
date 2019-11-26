import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/home/text.dart';
import 'package:flutter_login/login/login.dart';
import 'package:flutter_login/register/register.dart';

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
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child:
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Username',
                        hintStyle: TextStyle(fontSize: 15.0, color: Colors.yellow[400]),
                        fillColor: Colors.black,
                        focusColor: Colors.white,
                        hoverColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow[400], width: 2.0)
                        )
                      ),
                      controller: _usernameController,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
                    child:                   
                      TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(fontSize: 15.0, color: Colors.yellow[400]),
                        border: InputBorder.none,
                        fillColor: Colors.black,
                        focusColor: Colors.white,
                        hoverColor: Colors.white,
                         //labelStyle: headerTextStyle.copyWith(color: Colors.white),
                         //hintStyle: headerTextStyle.copyWith(color: Colors.white),
                         //prefixIcon: Icon(Icons.vpn_key),
                        // fillColor: Colors.grey,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.yellow[400], width: 2.0)
                          )
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
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register(),
                          settings: RouteSettings(),
                        )
                      );
                    },
                    child: Text('Don\'t have an account? Register now', style: TextStyle(color: Colors.blue))
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
