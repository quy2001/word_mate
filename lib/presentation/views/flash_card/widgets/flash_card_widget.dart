import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_mate/common/index.dart';
import 'package:word_mate/l10n/app_localizations.dart';

class FlashCardWidget extends StatefulWidget {
  final Map<String, dynamic> cardData;
  final bool isFlipped;
  final VoidCallback onFlip;
  final VoidCallback onPlayAudio;

  const FlashCardWidget({
    super.key,
    required this.cardData,
    required this.isFlipped,
    required this.onFlip,
    required this.onPlayAudio,
  });

  @override
  State<FlashCardWidget> createState() => _FlashCardWidgetState();
}

class _FlashCardWidgetState extends State<FlashCardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    if (widget.isFlipped) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(FlashCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
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
    return GestureDetector(
      onTap: widget.onFlip,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * pi;
          final isFront = _animation.value < 0.5;

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            alignment: Alignment.center,
            child: isFront
                ? _buildFront()
                // Mirror the back side so it doesn't look backwards
                : Transform(
                    transform: Matrix4.identity()..rotateY(pi),
                    alignment: Alignment.center,
                    child: _buildBack(context),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFront() {
    final word = widget.cardData['word'] as String? ?? '';
    return Container(
      width: double.infinity,
      height: 500.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1E163B),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      padding: EdgeInsets.all(24.w),
      child: Stack(
        children: [
          // Audio icon
          Positioned(
            top: 0,
            left: 0,
            child: GestureDetector(
              onTap: widget.onPlayAudio,
              child: Icon(
                Icons.volume_up_rounded,
                color: Colors.white,
                size: 28.sp,
              ),
            ),
          ),
          // Star icon
          Positioned(
            top: 0,
            right: 0,
            child: Icon(
              Icons.star_border_rounded,
              color: Colors.white,
              size: 28.sp,
            ),
          ),
          // Word
          Center(
            child: Text(
              word,
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final meaning = widget.cardData['meaning'] as String? ?? '';
    final ipa = widget.cardData['ipa'] as String? ?? '';
    final type = widget.cardData['type'] as String? ?? '';
    final example = widget.cardData['example'] as String? ?? '';

    return Container(
      width: double.infinity,
      height: 500.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1E163B),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (type.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFF9E5DF2).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                AppUtils.getLocalizedWordType(type, l10n).toUpperCase(),
                style: TextStyle(
                  color: const Color(0xFF9E5DF2),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (ipa.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Text(
                ipa,
                style: TextStyle(
                  color: const Color(0xFF2FE3D6),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          Text(
            meaning,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (example.isNotEmpty) ...[
            SizedBox(height: 24.h),
            Text(
              example,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16.sp,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ]
        ],
      ),
    );
  }
}
