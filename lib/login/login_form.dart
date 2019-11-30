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
                      decoration: new InputDecoration(
                        labelText: "Enter Username",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                        //fillColor: Colors.green
                      ),
                      validator: (val) {
                        if(val.length==0) {
                          return "Username cannot be empty";
                        }else{
                          return null;
                        }
                      },
                      controller: _usernameController,
                     // keyboardType: TextInputType.emailAddress,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),




                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                    child:                   
                      TextFormField(
                        decoration: new InputDecoration(
                          labelText: "Enter Password",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                          //  color: Colors.orange,
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide( color: Colors.yellow
                            ),
                          ),
                       //   fillColor: Colors.green
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
