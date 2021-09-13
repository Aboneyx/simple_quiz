import 'package:flutter/material.dart';
import 'package:simple_quiz/second_screen.dart';

import 'animated_wave.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Пройди опрос!',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              const Positioned(child: AnimatedBackground()),

              Column(
                children: [
                  const Spacer(),
                  Container(
                    height: 50,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>  ParticleBackgroundApp(),
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
                      child: const Text('Начать опрос!'),
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white,
                        primary: Colors.deepPurple,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
