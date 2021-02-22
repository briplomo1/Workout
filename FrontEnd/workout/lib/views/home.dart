import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout/blocs/authentication/authentication_bloc.dart';
import 'package:workout/blocs/authentication/authentication_event.dart';
import 'package:workout/models/models.dart';
import 'package:workout/services/authentication_service.dart';

class Home extends StatelessWidget {
  final User user;
  const Home({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            FlatButton(
              textColor: Theme.of(context).primaryColor,
              child: Text('Logout'),
              onPressed: () {
                // Add UserLoggedOut to authentication event stream.
                authBloc.add(UserLoggedOut());
              },
            )
          ],
        ),
      )),
    );
  }
}
