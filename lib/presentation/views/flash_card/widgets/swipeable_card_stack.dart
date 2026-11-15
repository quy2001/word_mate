import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SwipeableCardStack extends StatefulWidget {
  final Widget card;
  final Widget? nextCard;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final Widget leftOverlay;
  final Widget rightOverlay;

  const SwipeableCardStack({
    super.key,
    required this.card,
    this.nextCard,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.leftOverlay,
    required this.rightOverlay,
  });

  @override
  State<SwipeableCardStack> createState() => _SwipeableCardStackState();
}

class _SwipeableCardStackState extends State<SwipeableCardStack> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Animation<Offset>? _offsetAnimation;
  Offset _dragOffset = Offset.zero;
  double _angle = 0;
  Size _screenSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        if (_offsetAnimation != null) {
          setState(() {
            _dragOffset = _offsetAnimation!.value;
            _angle = 45 * (_dragOffset.dx / _screenSize.width) * pi / 180;
          });
        }
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenSize = MediaQuery.of(context).size;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    _animationController.stop();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
      _angle = 45 * (_dragOffset.dx / _screenSize.width) * pi / 180;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_dragOffset.dx > 100) {
      _animateOut(isRight: true);
    } else if (_dragOffset.dx < -100) {
      _animateOut(isRight: false);
    } else {
      _snapBack();
    }
  }

  void _animateOut({required bool isRight}) {
    final endX = isRight ? _screenSize.width * 1.5 : -_screenSize.width * 1.5;
    final endY = _dragOffset.dy + (_dragOffset.dy > 0 ? 100 : -100);

    _offsetAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset(endX, endY),
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationController.reset();
    _animationController.forward().then((_) {
      if (isRight) {
        widget.onSwipeRight();
      } else {
        widget.onSwipeLeft();
      }
      setState(() {
        _dragOffset = Offset.zero;
        _angle = 0;
        _offsetAnimation = null;
      });
    });
  }

  void _snapBack() {
    _offsetAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut));

    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    Widget overlay = const SizedBox.shrink();
    if (_dragOffset.dx > 20) {
      overlay = Opacity(
        opacity: min(1, _dragOffset.dx / 100),
        child: widget.rightOverlay,
      );
    } else if (_dragOffset.dx < -20) {
      overlay = Opacity(
        opacity: min(1, -_dragOffset.dx / 100),
        child: widget.leftOverlay,
      );
    }

    double dragPercent = min(1.0, _dragOffset.distance / 150.0);
    double nextCardScale = 0.95 + (0.05 * dragPercent);
    double nextCardOffsetY = 10.h * (1 - dragPercent);

    return Stack(
      alignment: Alignment.center,
      children: [
        if (widget.nextCard != null)
          Transform.scale(
            scale: nextCardScale,
            child: Transform.translate(
              offset: Offset(0, nextCardOffsetY),
              child: widget.nextCard!,
            ),
          ),
        GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: Transform.translate(
            offset: _dragOffset,
            child: Transform.rotate(
              angle: _angle,
              child: Stack(
                children: [
                  widget.card,
                  Positioned.fill(child: overlay),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
