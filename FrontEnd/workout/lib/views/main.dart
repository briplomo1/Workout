import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout/blocs/authentication/authentication_bloc.dart';
import 'package:workout/blocs/authentication/authentication_event.dart';
import 'package:workout/blocs/authentication/authentication_state.dart';
import 'package:workout/services/authentication_service.dart';
import 'package:workout/views/forgot_password.dart';
import 'login.dart';
import 'home.dart';
import 'register.dart';

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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[200],
          primaryColor: Color.fromARGB(255, 3, 3, 7),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.yellow[200])),
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
