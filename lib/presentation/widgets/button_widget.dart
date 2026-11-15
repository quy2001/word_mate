import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Widget? iconBefore;
  final Widget? iconAfter;

  final bool isOutline;
  final Color primaryColor;

  const ButtonWidget._({
    super.key,
    required this.title,
    this.onPressed,
    this.iconBefore,
    this.iconAfter,
    this.isOutline = false,
    this.primaryColor = const Color(0xFF9D63FF),
  });

  factory ButtonWidget.primary({
    Key? key,
    required String title,
    VoidCallback? onPressed,
    Widget? iconBefore,
    Widget? iconAfter,
  }) {
    return ButtonWidget._(
      key: key,
      title: title,
      onPressed: onPressed,
      iconBefore: iconBefore,
      iconAfter: iconAfter,
      isOutline: false,
    );
  }

  factory ButtonWidget.outline({
    Key? key,
    required String title,
    VoidCallback? onPressed,
    Widget? iconBefore,
    Widget? iconAfter,
    Color color = const Color(0xFF9D63FF),
  }) {
    return ButtonWidget._(
      key: key,
      title: title,
      onPressed: onPressed,
      iconBefore: iconBefore,
      iconAfter: iconAfter,
      isOutline: true,
      primaryColor: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isOutline ? 16.r : 30.r),
          color: isEnabled
              ? (isOutline ? primaryColor.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.15))
              : Colors.white.withValues(alpha: 0.05),
          border: Border.all(
            color: isEnabled
                ? (isOutline ? primaryColor.withValues(alpha: 0.8) : primaryColor.withValues(alpha: 0.8))
                : Colors.white.withValues(alpha: 0.1),
            width: 1.5.w,
          ),
          boxShadow: (isEnabled && !isOutline)
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.4),
                    blurRadius: 15,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconBefore != null) ...[
              iconBefore!,
              SizedBox(width: 8.w),
            ],
            Text(
              title,
              style: TextStyle(
                color: isEnabled
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.5),
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (iconAfter != null) ...[
              SizedBox(width: 8.w),
              iconAfter!,
            ],
          ],
        ),
      ),
    );
  }
}
