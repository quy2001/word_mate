import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: const BoxDecoration(
            color: Color(0xFF9D63FF),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0xFF9D63FF),
                blurRadius: 4,
                spreadRadius: 1,
              )
            ],
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
