import 'dart:math';

import 'package:flutter/material.dart';

import 'CustomWidgets/ProgressRing.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    _animation = Tween<double>(begin: 0.0, end: 75.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.decelerate))
      ..addListener(() {
        setState(() {});
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              CustomPaint(
                foregroundPainter: ProgressRing(_animation.value),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  child: Center(
                    child: Text('Deadlift',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
