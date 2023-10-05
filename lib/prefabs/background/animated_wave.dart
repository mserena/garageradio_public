import 'dart:math';
import 'package:flutter/material.dart';
import 'package:garageradio/defines/theme.dart';
import 'package:simple_animations/simple_animations.dart';

class AnimatedWave extends StatelessWidget {
  // Area in which the wave acts
  final double height;
  // Animation duration of a wave pass
  final double speed;
  // A shift in the x-axis to give a wave different start positon
  final double offset;
  // Wave color
  final Color color;

  const AnimatedWave({super.key, required this.height, required this.speed, this.offset = 0.0, this.color = defWaveBackgroundColor});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return SizedBox(
        height: height,
        width: constraints.biggest.width,
        child: LoopAnimationBuilder(
          duration: Duration(milliseconds: (5000 / speed).round()),
          tween: Tween(begin: 0.0, end: 2 * pi),
          builder: (BuildContext context, double value, Widget? child) {
            return CustomPaint(
              foregroundPainter: CurvePainter(value + offset, color),
            );
          }
        ),
      );
    });
  }
}

class CurvePainter extends CustomPainter {
  final double value;
  final Color color;

  CurvePainter(this.value, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = color;
    final path = Path();

    //Calculate Start/Control/End wave points
    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);
    final startPointY = size.height * (0.5 + 0.4 * y1);
    final controlPointY = size.height * (0.5 + 0.4 * y2);
    final endPointY = size.height * (0.5 + 0.4 * y3);

    path.moveTo(size.width * 0, startPointY);
    //Curves between points are calculated using Bézier function 
    path.quadraticBezierTo(size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}