import 'dart:async';
import 'package:flutter/material.dart';

class TextScroll extends StatefulWidget {
  final String text;
  final TextAlign? textAlign;
  final TextDirection textDirection;
  final TextStyle? style;
  final Velocity velocity;
  final int? intervalSpaces;
  final Duration? delayBefore;

  const TextScroll(
    this.text, {
    Key? key,
    this.style,
    this.textAlign = TextAlign.center,
    this.textDirection = TextDirection.ltr,
    this.velocity = const Velocity(pixelsPerSecond: Offset(50, 0)),
    this.intervalSpaces = 5,
    this.delayBefore = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  State<TextScroll> createState() => _TextScrollState();
}

class _TextScrollState extends State<TextScroll> {
  final _scrollController = ScrollController();
  String? _endlessText;
  double? _originalTextWidth;
  double _textMinWidth = 0;
  Timer? _timer;
  bool _running = false;

  @override
  void initState() {
    super.initState();

    final WidgetsBinding binding = WidgetsBinding.instance;
    binding.addPostFrameCallback(_initScroller);
  }

  @override
  void didUpdateWidget(covariant TextScroll oldWidget) {
    _onUpdate(oldWidget);

    //Update timer to adapt to changes in [widget.velocity]
    _setTimer();

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget baseWidget = Directionality(
      textDirection: widget.textDirection,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: _textMinWidth,
          ),
          child: Text(
            _endlessText ?? widget.text,
            style: widget.style,
            textAlign: widget.textAlign,
          ),
        )
      ),
    );
    return baseWidget;
  }

  Future<void> _initScroller(_) async {
    setState(() {
      _textMinWidth = _scrollController.position.viewportDimension;
    });

    await _delayBefore();
    _setTimer();
  }

  // Sets [_timer] for animation
  void _setTimer() {
    //Cancel previous timer if it exists
    _timer?.cancel();

    //Reset [_running] to allow for updates on changed velocity
    _running = false;

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_available) {
        timer.cancel();
        return;
      }

      if (!_running) _run();
    });
  }

  Future<void> _run() async {
    _running = true;
    await _animateEndless();
    _running = false;
  }

  Future<void> _animateEndless() async {
    if (!_available) return;

    final ScrollPosition position = _scrollController.position;
    final bool needsScrolling = position.maxScrollExtent > 0;
    if (!needsScrolling) {
      if (_endlessText != null) setState(() => _endlessText = null);
      return;
    }

    if (_endlessText == null || _originalTextWidth == null) {
      setState(() {
        _originalTextWidth =
            position.maxScrollExtent + position.viewportDimension;
        _endlessText =
            widget.text + _getSpaces(widget.intervalSpaces ?? 1) + widget.text;
      });
      return;
    }

    final double endlessTextWidth = position.maxScrollExtent + position.viewportDimension;
    final double singleRoundExtent = endlessTextWidth - _originalTextWidth!;
    final Duration duration = _getDuration(singleRoundExtent);
    if (duration == Duration.zero) return;

    if (!_available) return;
    await _scrollController.animateTo(
      singleRoundExtent,
      duration: duration,
      curve: Curves.linear,
    );
    if (!_available) return;
    _scrollController.jumpTo(position.minScrollExtent);
  }


  Future<void> _delayBefore() async {
    final Duration? delayBefore = widget.delayBefore;
    if (delayBefore == null) return;

    await Future<dynamic>.delayed(delayBefore);
  }

  Duration _getDuration(double extent) {
    //No movement when velocity offset dx equals 0
    if (widget.velocity.pixelsPerSecond.dx == 0) return Duration.zero;
    final int milliseconds = (extent * 1000 / widget.velocity.pixelsPerSecond.dx).round();
    return Duration(milliseconds: milliseconds);
  }

  void _onUpdate(TextScroll oldWidget) {
    if (widget.text != oldWidget.text && _endlessText != null) {
      setState(() {
        _endlessText = null;
        _originalTextWidth = null;
      });
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
  }

  String _getSpaces(int number) {
    String spaces = '';
    for (int i = 0; i < number; i++) {
      spaces += '\u{00A0}';
    }

    return spaces;
  }

  bool get _available => mounted && _scrollController.hasClients;
}