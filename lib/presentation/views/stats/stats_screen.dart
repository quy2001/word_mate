import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:word_mate/injector.dart';
import 'package:word_mate/l10n/app_localizations.dart';
import 'bloc/stats_bloc.dart';
import 'bloc/stats_event.dart';
import 'bloc/stats_state.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => injector<StatsBloc>()..add(LoadStatsEvent()),
      child: const _StatsView(),
    );
  }
}

class _StatsView extends StatelessWidget {
  const _StatsView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Text(
            l10n.navStats,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24.h),
          BlocBuilder<StatsBloc, StatsState>(
            builder: (context, state) {
              if (state.status == StatsStatus.loading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(color: Color(0xFF9D63FF)),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview Cards Grid
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.local_fire_department_rounded,
                          iconColor: const Color(0xFFFF9F43),
                          title: l10n.dayStreak,
                          value: '${state.dayStreak}',
                          subtitle: l10n.daysInARow,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.style_rounded,
                          iconColor: const Color(0xFF9D63FF),
                          title: l10n.wordsSaved,
                          value: '${state.totalWords}',
                          subtitle: l10n.totalVocabulary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.check_circle_rounded,
                          iconColor: const Color(0xFF2FE3D6),
                          title: l10n.mastered,
                          value: '${state.masteredWords}',
                          subtitle: l10n.retentionSolid,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.auto_stories_rounded,
                          iconColor: const Color(0xFF54A0FF),
                          title: l10n.learning,
                          value: '${state.learningWords}',
                          subtitle: l10n.inProgress,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Weekly Activity Bar Chart
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.weeklyActivity,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFF9D63FF).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                l10n.reviewsCount(state.totalReviews),
                                style: TextStyle(
                                  color: const Color(0xFF9D63FF),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        _buildWeeklyBarChart(context, state.weeklyActivity),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Accuracy & Due Summary
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6F3AE0).withValues(alpha: 0.3),
                          const Color(0xFF9D63FF).withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: const Color(0xFF9D63FF).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _SummaryItem(
                          label: l10n.accuracy,
                          value: '${state.accuracy.toStringAsFixed(1)}%',
                          icon: Icons.track_changes_rounded,
                          color: const Color(0xFF2FE3D6),
                        ),
                        Container(
                          width: 1,
                          height: 40.h,
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                        _SummaryItem(
                          label: l10n.dueToday,
                          value: '${state.dueWords}',
                          icon: Icons.alarm_rounded,
                          color: const Color(0xFFFF6B6B),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 120.h),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyBarChart(BuildContext context, List<Map<String, dynamic>> activity) {
    if (activity.isEmpty) return const SizedBox.shrink();

    final locale = Localizations.localeOf(context).languageCode;
    int maxCount = 1;
    for (final item in activity) {
      final c = (item['count'] as int?) ?? 0;
      if (c > maxCount) maxCount = c;
    }

    return SizedBox(
      height: 130.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: activity.map((item) {
          final count = (item['count'] as int?) ?? 0;
          final date = item['day'] as DateTime;
          final dayLabel = DateFormat('E', locale).format(date);
          final double barHeight = maxCount > 0 ? (count / maxCount) * 80.h : 0;

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$count',
                style: TextStyle(
                  color: count > 0 ? Colors.white : Colors.white.withValues(alpha: 0.3),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                width: 22.w,
                height: barHeight < 6.h ? 6.h : barHeight,
                decoration: BoxDecoration(
                  gradient: count > 0
                      ? const LinearGradient(
                          colors: [Color(0xFF9D63FF), Color(0xFF6F3AE0)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : null,
                  color: count > 0 ? null : Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                dayLabel,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 12.sp,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String subtitle;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20.sp),
              ),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 28.sp),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
