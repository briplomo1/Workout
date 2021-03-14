import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout/blocs/authentication/authentication_bloc.dart';
import 'package:workout/blocs/authentication/authentication_event.dart';
import 'package:workout/models/models.dart';
import 'package:workout/services/authentication_service.dart';

class Home extends StatelessWidget {
  final User user;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Home({this.user});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        title: Text(
          'Page Name',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              textBaseline: TextBaseline.alphabetic),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(Icons.menu),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            }),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(child: Text('Name, name')),
            SettingsTile(
              icon: Icons.person,
              title: 'Profile',
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.person,
              title: 'Profile',
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.lock,
              title: 'Log out',
              onTap: () {},
            ),
          ],
        ),
      ),
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

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;

  const SettingsTile({this.icon, this.title, this.onTap});
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[300])),
        ),
        child: InkWell(
          splashColor: Colors.grey[300],
          onTap: onTap,
          child: Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: Theme.of(context).primaryColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.0,
                          letterSpacing: 1.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_right,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
