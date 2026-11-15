import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_mate/presentation/widgets/bottom_nav/bottom_nav_bloc.dart';
import 'package:word_mate/presentation/widgets/bottom_nav/bottom_nav_event.dart';
import 'package:word_mate/presentation/widgets/bottom_nav/bottom_nav_state.dart';
import 'package:word_mate/l10n/app_localizations.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<BottomNavBloc, BottomNavState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: 70.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.w,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _NavItem(icon: Icons.home_rounded, label: l10n.home, index: 0, currentIndex: state.selectedIndex),
                    _NavItem(icon: Icons.grid_view_rounded, label: l10n.topics, index: 1, currentIndex: state.selectedIndex),
                    SizedBox(width: 56.w), // Space for FAB overlapping
                    _NavItem(icon: Icons.bar_chart_rounded, label: l10n.navStats, index: 3, currentIndex: state.selectedIndex),
                    _NavItem(icon: Icons.settings_rounded, label: l10n.settings, index: 4, currentIndex: state.selectedIndex),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;
    
    return GestureDetector(
      onTap: () {
        context.read<BottomNavBloc>().add(ChangeTabEvent(index));
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
              size: 24.sp,
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            SizedBox(height: 4.h),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 20.w : 0,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFFF9800), // Glowing orange indicator
                borderRadius: BorderRadius.circular(2.r),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFFFF9800).withValues(alpha: 0.6),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
