import 'dart:math';

import 'package:flutter/material.dart';

class ProgressRing extends CustomPainter {
  final ringThickness = 20.0;
  double ringProgress;
  double circleRadius = 200;

  ProgressRing(this.ringProgress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint circle = Paint()
      ..strokeWidth = ringThickness
      ..color = Colors.blue
      ..style = PaintingStyle.stroke;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = 70.0;
    canvas.drawCircle(center, radius, circle);

    Paint animationArc = Paint()
      ..strokeWidth = ringThickness
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double angle = 2 * pi * (ringProgress / 100);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 3 * pi / 2,
        angle, false, animationArc);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
