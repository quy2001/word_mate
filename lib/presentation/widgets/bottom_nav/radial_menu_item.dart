import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RadialMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  final double angleOffset;

  const RadialMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
    this.angleOffset = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Transform.rotate(
        angle: -angleOffset, // Counter-rotate so it stays upright
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF9D63FF).withValues(alpha: 0.3) : const Color(0xFF1A1235).withValues(alpha: 0.6),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: const Color(0xFF9D63FF).withValues(alpha: 0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 22.sp,
              ),
            ),
            SizedBox(height: 6.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFFE4D4FF) : Colors.white,
                  fontSize: 10.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
