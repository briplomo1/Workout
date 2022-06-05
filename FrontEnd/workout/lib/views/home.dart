import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout/blocs/authentication/authentication_bloc.dart';
import 'package:workout/blocs/authentication/authentication_event.dart';
import 'package:workout/models/models.dart';
import 'package:workout/constants.dart';
import 'MainScreens/log.dart';
import 'MainScreens/dashboard.dart';
import 'MainScreens/analysis.dart';

class Home extends StatefulWidget {
  // User is passed into class. Is available to entire class
  final User? user;

  Home({this.user});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedItemIndex = 0;
  PageController _pageController = new PageController();

  @override
  void initState() {
    super.initState();
  }

  //Nav bar screens and Titles
  List<Widget> _pageScreens = [
    DashboardScreen(),
    LogScreen(),
    AnalysisScreen()
  ];
  List<String> _pageTitles = ["Dashboard", "Workout Log", "Analysis"];

  void _onPageChanged(int index) {}

  //Nav bar Item Widget
  GestureDetector buildNavBarItem(
      IconData icon, String title, bool isActive, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedItemIndex = index;
          _pageController.jumpToPage(_selectedItemIndex);
        });
      },
      child: Container(
        height: 50.0,
        width: MediaQuery.of(context).size.width / 3,
        decoration: index == _selectedItemIndex
            ? BoxDecoration(
                border: BorderDirectional(
                    top: BorderSide(
                  width: 7.0,
                  color: index == _selectedItemIndex
                      ? Theme.of(context).primaryColor
                      : Color.fromARGB(0, 255, 255, 255),
                )),
              )
            : BoxDecoration(color: Colors.transparent),
        child: Column(
          children: [
            Icon(
              icon,
              color: index == _selectedItemIndex
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
              size: 28.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: AppBar(
          title: Center(
            child: Text(
              _pageTitles[_selectedItemIndex],
              style: TextStyle(
                  color: Colors.grey, textBaseline: TextBaseline.alphabetic),
            ),
          ),
          backgroundColor: Colors.grey[700],
          elevation: 1.0,
          leading: IconButton(
              icon: Icon(Icons.menu),
              color: Colors.grey,
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              }),
        ),
        drawer: Drawer(
          backgroundColor: Colors.grey[800],
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
                onTap: () {
                  authBloc.add(UserLoggedOut());
                },
              ),
            ],
          ),
        ),
        body: PageView(
          controller: _pageController,
          children: _pageScreens,
          onPageChanged: _onPageChanged,
        ),
        bottomNavigationBar: Row(
          children: [
            buildNavBarItem(Icons.home, 'Dashboard', true, 0),
            buildNavBarItem(Icons.edit, 'Log', false, 1),
            buildNavBarItem(Icons.show_chart, 'Charts', false, 2),
          ],
        ));
  }
}

class SettingsTile extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final Function? onTap;

  const SettingsTile({this.icon, this.title, this.onTap});
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0.0),
      child: Container(
        decoration: BoxDecoration(),
        child: InkWell(
          splashColor: Color.fromARGB(255, 7, 7, 7),
          onTap: onTap as void Function()?,
          child: Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                      child: Text(
                        title!,
                        style: menuText(Colors.grey, 18.0),
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_right,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
