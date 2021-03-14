import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout/blocs/authentication/authentication_bloc.dart';
import 'package:workout/blocs/authentication/authentication_event.dart';
import 'package:workout/blocs/authentication/authentication_state.dart';
import 'package:workout/blocs/login/login_bloc.dart';
import 'package:workout/blocs/login/login_event.dart';
import 'package:workout/blocs/login/login_state.dart';
import 'package:workout/services/authentication_service.dart';
import 'package:workout/services/services.dart';
import 'package:workout/views/forgot_password.dart';
import 'package:workout/services/api.dart';
import 'package:workout/models/models.dart';
import 'package:workout/views/home.dart';
import 'dart:convert';
import 'package:workout/constants.dart';

import 'package:workout/views/register.dart';

class LoginUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            final authBloc = BlocProvider.of<AuthenticationBloc>(context);
            if (state is AuthenticationNotAuthenticated) {
              return _AuthForm();
            }
            if (state is AuthenticationFailure) {
              //Show error dialogue
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(state.message),
                    RaisedButton(
                      textColor: Theme.of(context).accentColor,
                      child: Text('Retry'),
                      onPressed: () {
                        authBloc.add(AppLoaded());
                      },
                    )
                  ],
                ),
              );
            }
            // Else if state isnt authenticated or failure then its loading
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = RepositoryProvider.of<AuthenticationService>(context);
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Container(
      child: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(authBloc, authService),
        child: _SignInForm(),
      ),
    );
  }
}

class _SignInForm extends StatefulWidget {
  @override
  __SignInFormState createState() => __SignInFormState();
}

class __SignInFormState extends State<_SignInForm> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  bool hidePassword = true;
  LoginRequest loginModel;
  AuthenticationService auth;
  StorageService storage;
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loginModel = new LoginRequest();
  }

  @override
  Widget build(BuildContext context) {
    final _loginBloc = BlocProvider.of<LoginBloc>(context);

    _onLoginButtonPressed() {
      if (validateAndSaveLoginForm()) {
        _loginBloc.add(LoginButtonPressed(user: loginModel));
      }
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          _showError(state.error);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            key: scaffoldKey,
            body: ListView(
              children: [
                Container(
                  height: 300,
                ),
                Container(
                  child: Form(
                    key: globalFormKey,
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.email),
                              onPressed: () {},
                              color: Theme.of(context).primaryColor,
                            ),
                            Expanded(
                                child: Container(
                              margin: EdgeInsets.only(left: 4, right: 20),
                              child: TextFormField(
                                onSaved: (input) => loginModel.email = input,
                                keyboardType: TextInputType.emailAddress,
                                validator: (input) => input.contains("@")
                                    ? null
                                    : "Invalid email address",
                                decoration: InputDecoration(
                                  hintText: 'Email Adress',
                                ),
                              ),
                            ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.lock),
                              onPressed: () {},
                              color: Theme.of(context).primaryColor,
                            ),
                            Expanded(
                                child: Container(
                              margin: EdgeInsets.only(left: 4, right: 20),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (input) => loginModel.password = input,
                                validator: (input) => input.length < 8
                                    ? "Invalid password length"
                                    : null,
                                obscureText: hidePassword,
                                decoration: InputDecoration(
                                    hintText: 'Password',
                                    suffixIcon: IconButton(
                                        icon: Icon(hidePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.6),
                                        onPressed: () {
                                          setState(() {
                                            hidePassword = !hidePassword;
                                          });
                                        })),
                              ),
                            ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 35),
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.grey[350],
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 7))
                          ]),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: Color(0xFF04061a),
                            onPressed: state is LoginLoading
                                ? () {}
                                : _onLoginButtonPressed,
                            child: Text('SIGN IN', style: buttonsText
                                //GoogleFonts.ptSansCaption(
                                //   color: Colors.grey[400],
                                //   fontSize: 20,
                                //   letterSpacing: 3,
                                // ),
                                ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPassword())),
                        child: Container(
                          child: Text('Forgot password?'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register())),
                        child: Container(
                          child: Text('Register now'),
                        ),
                      )
                    ]),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  bool validateAndSaveLoginForm() {
    final loginForm = globalFormKey.currentState;
    if (loginForm.validate()) {
      loginForm.save();
      return true;
    }
    return false;
  }

  void _showError(String error) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(error),
      backgroundColor: Theme.of(context).errorColor,
    ));
  }
}
