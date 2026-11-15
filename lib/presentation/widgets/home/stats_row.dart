import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_mate/l10n/app_localizations.dart';

class StatsRow extends StatelessWidget {
  final int dayStreak;
  final int wordsSaved;

  const StatsRow({
    super.key,
    required this.dayStreak,
    required this.wordsSaved,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(child: _StatCard(icon: Icons.local_fire_department, value: dayStreak, label: l10n.dayStreak)),
        SizedBox(width: 16.w),
        Expanded(child: _StatCard(icon: Icons.bookmark_rounded, value: wordsSaved, label: l10n.wordsSaved)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFF9D63FF).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF9D63FF), size: 20.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            value.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
