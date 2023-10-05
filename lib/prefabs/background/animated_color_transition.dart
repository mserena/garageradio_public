import 'package:flutter/material.dart';
import 'package:garageradio/defines/theme.dart';
import 'package:simple_animations/simple_animations.dart';

class AnimatedColorTransition extends StatelessWidget {
  const AnimatedColorTransition({super.key});

  @override
  Widget build(BuildContext context) {
    final tween = MovieTween()
      ..tween('color1', ColorTween(begin: defBackgroundColor1Begin, end: defBackgroundColor1End), duration: const Duration(seconds: 4))
      ..tween('color2', ColorTween(begin: defBackgroundColor2Begin, end: defBackgroundColor2End), duration: const Duration(seconds: 4));

    //Using simple animations package to create colors gradient mirror animation between color1 and color2
    return MirrorAnimationBuilder(
      tween: tween,
      duration: tween.duration,
      builder: (BuildContext context, Movie value, Widget? child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [value.get('color1'), value.get('color2')]
            )
          ),
        );
      },
    );
  }
}