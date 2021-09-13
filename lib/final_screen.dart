import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sa_v1_migration/simple_animations/controlled_animation.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:simple_quiz/animated_wave.dart';

class FinalScreen extends StatelessWidget {
  const FinalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            const Positioned(child: AnimatedBackground()),
            onBottom(const AnimatedWave(
              height: 180,
              speed: 1.0,
            )),
            onBottom(const AnimatedWave(
              height: 120,
              speed: 0.9,
              offset: pi,
            )),
            onBottom(const AnimatedWave(
              height: 220,
              speed: 1.2,
              offset: pi / 2,
            )),
            Center(
                child: const Text(
                  "Так и знал =)",
                  style: TextStyle(color: Colors.white),
                  textScaleFactor: 3,
                ),),
          ],
        ),
      ),
    );
  }

  onBottom(Widget child) =>
      Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );
}

class AnimatedWave extends StatelessWidget {
  final double height;
  final double speed;
  final double offset;

  const AnimatedWave(
      {required this.height, required this.speed, this.offset = 0.0});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: height,
        width: constraints.biggest.width,
        child: ControlledAnimation(
            playback: Playback.LOOP,
            duration: Duration(milliseconds: (5000 / speed).round()),
            tween: Tween(begin: 0.0, end: 2 * pi),
            builder: (context, value) {
              return CustomPaint(
                foregroundPainter: CurvePainter((value as double) + offset),
              );
            }),
      );
    });
  }
}

class CurvePainter extends CustomPainter {
  final double value;

  CurvePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()
      ..color = Colors.white.withAlpha(60);
    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = size.height * (0.5 + 0.4 * y1);
    final controlPointY = size.height * (0.5 + 0.4 * y2);
    final endPointY = size.height * (0.5 + 0.4 * y3);

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
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

