import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_mate/l10n/app_localizations.dart';

class GoalAdjuster extends StatelessWidget {
  final int currentGoal;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const GoalAdjuster({
    super.key,
    required this.currentGoal,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildArrowButton(
            icon: Icons.chevron_left,
            onTap: onDecrease,
          ),
          Column(
            children: [
              Text(
                currentGoal.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 72.sp,
                  fontWeight: FontWeight.w300,
                  height: 1.0,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                l10n.wordsPerDay,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          _buildArrowButton(
            icon: Icons.chevron_right,
            onTap: onIncrease,
          ),
        ],
      ),
    );
  }

  Widget _buildArrowButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24.sp,
        ),
      ),
    );
  }
}
