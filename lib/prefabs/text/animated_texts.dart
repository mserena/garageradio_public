import 'dart:async';
import 'package:flutter/material.dart';
import 'package:garageradio/prefabs/text/animated_text.dart';

class AnimatedTextKit extends StatefulWidget {
  final List<AnimatedText> animatedTexts;

  // Define the duration of the pause between texts.
  final Duration pause;

  // onNext callback to the animated widget. Will be called right before the next text, after the pause parameter.
  final void Function(int, bool)? onNext;

  // Adds the onFinished [VoidCallback] to the animated widget.
  final VoidCallback? onFinished;

  /// Sets if the animation should repeat forever. 
  final bool repeatForever;

  const AnimatedTextKit({
    Key? key,
    required this.animatedTexts,
    this.pause = const Duration(milliseconds: 1000),
    this.onNext,
    this.onFinished,
    this.repeatForever = true,
  })  : assert(animatedTexts.length > 0), super(key: key);

  /// Creates the mutable state for this widget.
  @override
  AnimatedTextKitState createState() => AnimatedTextKitState();
}

class AnimatedTextKitState extends State<AnimatedTextKit> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimatedText _currentAnimatedText;
  int _index = 0;
  bool _isCurrentlyPausing = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completeText = _currentAnimatedText.completeText(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: _isCurrentlyPausing || !_controller.isAnimating
          ? completeText
          : AnimatedBuilder(
              animation: _controller,
              builder: _currentAnimatedText.animatedBuilder,
              child: completeText,
            ),
    );
  }

  bool get _isLast => _index == widget.animatedTexts.length - 1;

  void _nextAnimation() {
    final isLast = _isLast;
    _isCurrentlyPausing = false;
    widget.onNext?.call(_index, isLast);

    if (isLast) {
      if(widget.repeatForever){
        _index = 0;
      } else {
        widget.onFinished?.call();
        return;
      }
    } else {
      _index++;
    }

    if (mounted) setState(() {});
    _controller.dispose();

    // Re-initialize animation
    _initAnimation();
  }

  void _initAnimation() {
    _currentAnimatedText = widget.animatedTexts[_index];

    _controller = AnimationController(
      duration: _currentAnimatedText.duration,
      vsync: this,
    );

    _currentAnimatedText.initAnimation(_controller);

    _controller..addStatusListener(_animationEndCallback)..forward();
  }

  void _setPause() {
    _isCurrentlyPausing = true;
    if (mounted) setState(() {});
  }

  void _animationEndCallback(AnimationStatus state) {
    if (state == AnimationStatus.completed) {
      _setPause();
      assert(null == _timer || !_timer!.isActive);
      _timer = Timer(widget.pause, _nextAnimation);
    }
  }
}
