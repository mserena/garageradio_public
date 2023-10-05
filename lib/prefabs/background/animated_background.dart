import 'dart:math';
import 'package:flutter/material.dart';
import 'package:garageradio/prefabs/background/animated_color_transition.dart';
import 'package:garageradio/prefabs/background/animated_wave.dart';

class AnimatedBackground extends StatelessWidget {
  final bool showWaves;

  const AnimatedBackground({super.key, required this.showWaves});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        const Positioned.fill(child: AnimatedColorTransition()),
        if(showWaves) ...{
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedWave(
              height: 0.25*screenHeight,
              speed: 1.0
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedWave(
              height: 0.20*screenHeight,
              speed: 0.9,
              offset: pi,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedWave(
              height: 0.30*screenHeight,
              speed: 1.2,
              offset: pi/2,
            ),
          ),
        }
      ],
    );
  }
}