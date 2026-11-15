import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_mate/l10n/app_localizations.dart';

class MonthlyEstimationBadge extends StatelessWidget {
  final int wordsPerMonth;

  const MonthlyEstimationBadge({super.key, required this.wordsPerMonth});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0F4A5E).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFF28A745).withValues(alpha: 0.5),
          width: 1.w,
        ),
      ),
      child: Text(
        l10n.wordsPerMonth(wordsPerMonth),
        style: TextStyle(
          color: const Color(0xFF28A745),
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
