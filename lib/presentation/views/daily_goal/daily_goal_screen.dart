import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:word_mate/l10n/app_localizations.dart';
import 'package:word_mate/injector.dart';
import 'package:word_mate/presentation/views/daily_goal/bloc/daily_goal_bloc.dart';
import 'package:word_mate/presentation/views/daily_goal/bloc/daily_goal_event.dart';
import 'package:word_mate/presentation/views/daily_goal/bloc/daily_goal_state.dart';
import 'package:word_mate/presentation/widgets/daily_goal/goal_adjuster.dart';
import 'package:word_mate/presentation/widgets/daily_goal/goal_chips.dart';
import 'package:word_mate/presentation/widgets/daily_goal/monthly_estimation_badge.dart';
import 'package:word_mate/presentation/widgets/register/gradient_background.dart';
import 'package:word_mate/presentation/widgets/button_widget.dart';
import 'package:word_mate/presentation/widgets/page_indicator.dart';

class DailyGoalScreen extends StatelessWidget {
  const DailyGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider<DailyGoalBloc>(
      create: (context) => injector.get<DailyGoalBloc>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: GradientBackground(
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            children: [
                              SizedBox(height: 60.h),
                              Text(
                                l10n.setDailyGoal,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                l10n.howManyWords,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 48.h),
                              BlocBuilder<DailyGoalBloc, DailyGoalState>(
                                builder: (context, state) {
                                  return GoalAdjuster(
                                    currentGoal: state.goal,
                                    onDecrease: () {
                                      context.read<DailyGoalBloc>().add(DecreaseGoalEvent());
                                    },
                                    onIncrease: () {
                                      context.read<DailyGoalBloc>().add(IncreaseGoalEvent());
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 32.h),
                              BlocBuilder<DailyGoalBloc, DailyGoalState>(
                                builder: (context, state) {
                                  return GoalChips(
                                    goals: const [5, 10, 20, 30, 50],
                                    selectedGoal: state.goal,
                                    onGoalSelected: (goal) {
                                      context.read<DailyGoalBloc>().add(SelectGoalEvent(goal));
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 32.h),
                              BlocBuilder<DailyGoalBloc, DailyGoalState>(
                                builder: (context, state) {
                                  return MonthlyEstimationBadge(
                                    wordsPerMonth: state.goal * 30,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: BlocConsumer<DailyGoalBloc, DailyGoalState>(
                        listenWhen: (previous, current) => previous.status != current.status,
                        listener: (context, state) {
                          if (state.status == DailyGoalStatus.success) {
                            context.go('/home');
                          }
                        },
                        builder: (context, state) {
                          final isSubmitting = state.status == DailyGoalStatus.submitting;
                          return ButtonWidget.primary(
                            title: isSubmitting ? l10n.starting : l10n.startLearning,
                            iconAfter: isSubmitting
                                ? SizedBox(
                                    width: 20.sp,
                                    height: 20.sp,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "🚀",
                                    style: TextStyle(fontSize: 18.sp),
                                  ),
                            onPressed: !isSubmitting
                                ? () {
                                    context.read<DailyGoalBloc>().add(SubmitGoalEvent());
                                  }
                                : null,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 40.h),
                    const AppPageIndicator(totalPages: 2, currentPage: 1),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
