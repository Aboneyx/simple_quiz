import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

import 'final_screen.dart';

class ParticleBackgroundApp extends StatefulWidget {
  const ParticleBackgroundApp({Key? key}) : super(key: key);

  @override
  _ParticleBackgroundApp createState() => _ParticleBackgroundApp();
}

class _ParticleBackgroundApp extends State<ParticleBackgroundApp> {
  double _width = 100;
  double _height = 50;
  Color _color = Colors.deepOrangeAccent;
  Color _textColor = Colors.white;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(30);
  double _bottom = 100;
  double _left = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          const Positioned(child: AnimatedBackground()),
          Positioned.fill(child: Particles(30)),
          const Positioned.fill(child: CenteredText()),
          Positioned(
              right: 20,
              bottom: 100,
              child: SizedBox(
                width: 100,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>  const FinalScreen(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,

                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.black,
                    primary: Colors.deepOrangeAccent,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'ДА',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )),
          Positioned(
            bottom: _bottom,
            left: _left,
            child: SizedBox(
              width: _width,
              height: _height,
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      final random = Random();

                      // Generate a random width and height.
                      _width = random.nextInt(400).toDouble();
                      _height = random.nextInt(400).toDouble();
                      _bottom = random.nextInt(400).toDouble();
                      _left = random.nextInt(200).toDouble();

                      if (_width < 50 || _height < 50) {
                        _width = 50;
                        _height = 50;
                      }

                      // Generate a random color.
                      _color = Color.fromRGBO(
                        random.nextInt(256),
                        random.nextInt(256),
                        random.nextInt(256),
                        1,
                      );
                      _textColor = Color.fromRGBO(
                        random.nextInt(256),
                        random.nextInt(256),
                        random.nextInt(256),
                        1,
                      );

                      _borderRadius =
                          BorderRadius.circular(random.nextInt(100).toDouble());
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.black,
                    primary: _color,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: _borderRadius,
                    ),
                  ),
                  child: Text(
                    'НЕТ',
                    style: TextStyle(
                      fontSize: 20,
                      color: _textColor,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class Particles extends StatefulWidget {
  final int numberOfParticles;

  Particles(this.numberOfParticles);

  @override
  _ParticlesState createState() => _ParticlesState();
}

class _ParticlesState extends State<Particles> {
  final Random random = Random();

  final List<ParticleModel> particles = [];

  @override
  void initState() {
    widget.numberOfParticles.times(() => particles.add(ParticleModel(random)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoopAnimation(
      tween: ConstantTween(1),
      builder: (context, child, _) {
        _simulateParticles();
        return CustomPaint(
          painter: ParticlePainter(particles),
        );
      },
    );
  }

  _simulateParticles() {
    for (var particle in particles) {
      particle.checkIfParticleNeedsToBeRestarted();
    }
  }
}

enum _OffsetProps { x, y }

class ParticleModel {
  MultiTween<_OffsetProps>? tween;
  double? size;
  Duration? duration;
  Duration? startTime;
  Random random;

  ParticleModel(this.random) {
    _restart();
    _shuffle();
  }

  _restart({Duration time = Duration.zero}) {
    final startPosition = Offset(-0.2 + 1.4 * random.nextDouble(), 1.2);
    final endPosition = Offset(-0.2 + 1.4 * random.nextDouble(), -0.2);

    tween = MultiTween<_OffsetProps>()
      ..add(_OffsetProps.x, startPosition.dx.tweenTo(endPosition.dx))
      ..add(_OffsetProps.y, startPosition.dy.tweenTo(endPosition.dy));

    duration = 3000.milliseconds + random.nextInt(6000).milliseconds;
    startTime = DateTime.now().duration();
    size = 0.2 + random.nextDouble() * 0.4;
  }

  void _shuffle() {
    startTime = startTime! -
        (random.nextDouble() * duration!.inMilliseconds)
            .round()
            .milliseconds;
  }

  checkIfParticleNeedsToBeRestarted() {
    if (progress() == 1.0) {
      _restart();
    }
  }

  double progress() {
    return ((DateTime.now().duration() - startTime!) / duration!)
        .clamp(0.0, 1.0)
        .toDouble();
  }
}

class ParticlePainter extends CustomPainter {
  List<ParticleModel> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withAlpha(50);

    for (var particle in particles) {
      final progress = particle.progress();
      final MultiTweenValues<_OffsetProps> animation =
          particle.tween!.transform(progress);
      final position = Offset(
        animation.get<double>(_OffsetProps.x) * size.width,
        animation.get<double>(_OffsetProps.y) * size.height,
      );
      canvas.drawCircle(
          position, size.width * 0.2 * (particle.size as double), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

enum _ColorTween { color1, color2 }

class AnimatedBackground extends StatelessWidget {
  const AnimatedBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<_ColorTween>()
      ..add(
        _ColorTween.color1,
        const Color(0xff8a113a).tweenTo(Colors.lightBlue.shade900),
        3.seconds,
      )
      ..add(
        _ColorTween.color2,
        const Color(0xff440216).tweenTo(Colors.blue.shade600),
        3.seconds,
      );

    return MirrorAnimation<MultiTweenValues<_ColorTween>>(
      tween: tween,
      duration: tween.duration,
      builder: (context, child, value) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                value.get<Color>(_ColorTween.color1),
                value.get<Color>(_ColorTween.color2)
              ])),
        );
      },
    );
  }
}

class CenteredText extends StatelessWidget {
  const CenteredText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
      "Ты даун?",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
      textScaleFactor: 4,
    ));
  }
}
