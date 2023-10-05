import 'package:flutter/material.dart';

abstract class AnimatedText {
  final String text;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final Duration duration;

  AnimatedText({
    required this.text,
    this.textAlign = TextAlign.center,
    this.textStyle,
    this.duration = const Duration(seconds: 5),
  });

  // Return the remaining Duration for the Animation.
  Duration? get remaining => null;

  void initAnimation(AnimationController controller);

  Widget textWidget(String data) => Text(
    data,
    textAlign: textAlign,
    style: textStyle,
  );

  // Widget showing the complete text (when animation is complete or paused).
  Widget completeText(BuildContext context) => textWidget(text);

  // Widget showing animated text.
  Widget animatedBuilder(BuildContext context, Widget? child);
}