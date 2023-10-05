import 'package:flutter/material.dart';
import 'animated_text.dart';

class FadeAnimatedText extends AnimatedText {
  final double fadeInEnd;
  final double fadeOutBegin;
  late Animation<double> _fadeIn;
  late Animation<double> _fadeOut;

  FadeAnimatedText(
    String text, 
    {
      TextAlign textAlign = TextAlign.center,
      TextStyle? textStyle,
      Duration duration = const Duration(seconds: 5),
      this.fadeInEnd = 0.5,
      this.fadeOutBegin = 0.8,
    }
  )  : assert(fadeInEnd < fadeOutBegin, 'The "fadeInEnd" argument must be less than "fadeOutBegin"'), super(
    text: text,
    textAlign: textAlign,
    textStyle: textStyle,
    duration: duration,
  );

  @override
  void initAnimation(AnimationController controller) {
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, fadeInEnd, curve: Curves.linear),
      ),
    );

    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(fadeOutBegin, 1.0, curve: Curves.linear),
      ),
    );
  }

  @override
  Widget completeText(BuildContext context) => const SizedBox.shrink();

  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    return Opacity(
      opacity: _fadeIn.value != 1.0 ? _fadeIn.value : _fadeOut.value,
      child: textWidget(text),
    );
  }
}