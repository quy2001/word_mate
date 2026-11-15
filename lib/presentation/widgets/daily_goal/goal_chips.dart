import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoalChips extends StatelessWidget {
  final List<int> goals;
  final int selectedGoal;
  final ValueChanged<int> onGoalSelected;

  const GoalChips({
    super.key,
    required this.goals,
    required this.selectedGoal,
    required this.onGoalSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      alignment: WrapAlignment.center,
      children: goals.map((goal) {
        final isSelected = goal == selectedGoal;
        return GestureDetector(
          onTap: () => onGoalSelected(goal),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF9D63FF)
                    : Colors.white.withValues(alpha: 0.2),
                width: isSelected ? 2.w : 1.w,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF9D63FF).withValues(alpha: 0.4),
                        blurRadius: 10,
                        spreadRadius: 1,
                      )
                    ]
                  : null,
            ),
            child: Text(
              goal.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
