import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppPageIndicator extends StatelessWidget {
  final int totalPages;
  final int currentPage;

  const AppPageIndicator({
    super.key,
    required this.totalPages,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isActive = index == currentPage;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF9D63FF) : Colors.white.withValues(alpha: 0.3),
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    const BoxShadow(
                      color: Color(0xFF9D63FF),
                      blurRadius: 4,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
