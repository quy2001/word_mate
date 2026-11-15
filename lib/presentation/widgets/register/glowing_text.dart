import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlowingText extends StatelessWidget {
  final String text;

  const GlowingText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 48.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 4.w,
        shadows: [
          Shadow(
            blurRadius: 15.0,
            color: Colors.white.withOpacity(0.8),
            offset: const Offset(0, 0),
          ),
          Shadow(
            blurRadius: 30.0,
            color: Colors.blueAccent.withOpacity(0.5),
            offset: const Offset(0, 0),
          ),
        ],
      ),
    );
  }
}
