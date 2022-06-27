import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:workout/constants.dart';

import '../../models/models.dart';
import 'CustomWidgets/ProgressRing.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key, required User user}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

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
        Container(
          height: 200,
          width: MediaQuery.of(context).size.height * (2 / 5),
          child: LineChart(
            LineChartData(
                backgroundColor: Colors.transparent,
                maxX: 8,
                maxY: 7,
                minX: 0,
                minY: 0,
                titlesData: Titles.getTitleDat(),
                gridData: FlGridData(
                  show: false,
                ),
                borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.transparent, width: 1)),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 0),
                      const FlSpot(3, 4),
                      const FlSpot(5, 3),
                      const FlSpot(7, 6),
                      const FlSpot(8, 4),
                    ],
                    dotData: FlDotData(show: true),
                    isCurved: true,
                    barWidth: 5,
                    color: Colors.blue[800],
                    belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [Colors.blue[800]!, Colors.transparent],
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                        )),
                  ),
                ]),
          ),
        ),
      ],
    );
  }
}

class Titles {
  static getTitleDat() => FlTitlesData(
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: false,
        )),
        topTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: false,
        )),
        leftTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: false,
        )),
        rightTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: false,
        )),
      );
}
