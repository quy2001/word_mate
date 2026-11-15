import 'dart:math';
import 'package:flutter/material.dart';

class WiggleWrapper extends StatefulWidget {
  final Widget child;
  final bool animate;

  const WiggleWrapper({
    super.key,
    required this.child,
    required this.animate,
  });

  @override
  State<WiggleWrapper> createState() => _WiggleWrapperState();
}

class _WiggleWrapperState extends State<WiggleWrapper> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Randomize initial offset slightly so cards don't wiggle perfectly in phase
    final double offset = Random().nextDouble() * 0.2;
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );
    
    _animation = Tween<double>(begin: -0.015, end: 0.015).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.animate) {
      Future.delayed(Duration(milliseconds: (offset * 100).toInt()), () {
        if (mounted && widget.animate) {
          _controller.repeat(reverse: true);
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant WiggleWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        final double offset = Random().nextDouble() * 0.2;
        Future.delayed(Duration(milliseconds: (offset * 100).toInt()), () {
          if (mounted && widget.animate) {
            _controller.repeat(reverse: true);
          }
        });
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animate) {
      return widget.child;
    }
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
