import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout/blocs/authentication/authentication_bloc.dart';
import 'package:workout/blocs/authentication/authentication_event.dart';
import 'package:workout/blocs/authentication/authentication_state.dart';
import 'package:workout/services/authentication_service.dart';
import 'package:workout/views/forgot_password.dart';
import 'views/login.dart';
import 'views/home.dart';
import 'views/register.dart';
import 'constants.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(RepositoryProvider<AuthenticationService>(
    create: (context) {
      return AuthenticationService();
    },
    child: BlocProvider<AuthenticationBloc>(
      create: (context) {
        final authService =
            RepositoryProvider.of<AuthenticationService>(context);
        return AuthenticationBloc(authService)..add(AppLoaded());
      },
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(
            displayMedium: TextStyle(
          color: Colors.white,
        )),
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Color.fromARGB(255, 57, 248, 255),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
        if (state is AuthenticationAuthenticated) {
          print('yes auth');
          return Home(user: state.user);
        }
        print("not auth");
        return LoginUser();
      }),
    );
  }
}
