import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_mate/l10n/app_localizations.dart';
import 'package:word_mate/presentation/widgets/topics/dashed_rounded_rect_painter.dart';

class AddTopicCard extends StatelessWidget {
  final VoidCallback onTap;

  const AddTopicCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: CustomPaint(
            painter: DashedRoundedRectPainter(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: 24.r,
              dashLength: 6.w,
              gap: 4.w,
              strokeWidth: 1.5,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                color: const Color(0xFF1E163B).withValues(alpha: 0.3),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline_rounded,
                    color: Colors.white.withValues(alpha: 0.35),
                    size: 38.sp,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    l10n.addTopic,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
