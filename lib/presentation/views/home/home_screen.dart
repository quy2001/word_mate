import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_mate/injector.dart';
import 'package:word_mate/presentation/views/home/bloc/home_bloc.dart';
import 'package:word_mate/presentation/views/home/bloc/home_event.dart';
import 'package:word_mate/presentation/views/home/bloc/home_state.dart';
import 'package:word_mate/presentation/widgets/home/due_for_review_card.dart';
import 'package:word_mate/presentation/widgets/home/greeting_card.dart';
import 'package:word_mate/presentation/widgets/home/stats_row.dart';
import 'package:word_mate/presentation/widgets/home/today_goal_card.dart';

import 'package:word_mate/presentation/widgets/register/gradient_background.dart';
import 'package:word_mate/presentation/views/topics/topics_screen.dart';
import 'package:word_mate/presentation/views/topics/bloc/topics_bloc.dart';
import 'package:word_mate/presentation/views/topics/bloc/topics_event.dart';
import 'package:word_mate/presentation/widgets/bottom_nav/radial_menu.dart';
import 'package:word_mate/presentation/widgets/bottom_nav/custom_bottom_nav.dart';
import 'package:word_mate/presentation/widgets/bottom_nav/bottom_nav_bloc.dart';
import 'package:word_mate/presentation/widgets/bottom_nav/bottom_nav_state.dart';
import 'package:word_mate/presentation/widgets/shimmer.dart';
import 'package:word_mate/presentation/views/settings/settings_screen.dart';
import 'package:word_mate/l10n/app_localizations.dart';
import 'package:word_mate/presentation/views/add_word/add_word_bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => injector.get<HomeBloc>()..add(LoadHomeDataEvent()),
        ),
        BlocProvider<TopicsBloc>(
          create: (context) => injector.get<TopicsBloc>()..add(LoadTopicsEvent()),
        ),
        BlocProvider<BottomNavBloc>(
          create: (context) => injector.get<BottomNavBloc>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return BlocListener<BottomNavBloc, BottomNavState>(
            listenWhen: (previous, current) => previous.selectedIndex != current.selectedIndex,
            listener: (context, navState) {
              if (navState.selectedIndex == 0) {
                context.read<HomeBloc>().add(LoadHomeDataEvent());
              }
            },
            child: Scaffold(
              extendBody: true,
              body: Stack(
                children: [
                  GradientBackground(
                    child: SafeArea(
                      bottom: false,
                      child: BlocBuilder<BottomNavBloc, BottomNavState>(
                    builder: (context, navState) {
                      switch (navState.selectedIndex) {
                        case 0:
                        return BlocBuilder<HomeBloc, HomeState>(
                          builder: (context, state) {
                            if (state.status == HomeStatus.initial ||
                                state.status == HomeStatus.loading) {
                              return const HomeShimmer();
                            }

                            return SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 16.h),
                                    GreetingCard(
                                      nickname: state.nickname,
                                      avatarPath: state.avatarPath,
                                    ),
                                    SizedBox(height: 16.h),
                                    TodayGoalCard(
                                      todayLearned: state.todayLearnedCount,
                                      dailyGoal: state.dailyGoal,
                                    ),
                                    SizedBox(height: 16.h),
                                    StatsRow(
                                      dayStreak: state.dayStreak,
                                      wordsSaved: state.totalWordsSaved,
                                    ),
                                    SizedBox(height: 16.h),
                                    DueForReviewCard(
                                      words: state.dueForReviewWords,
                                      onStartReview: () {
                                        // TODO: Navigate to Review screen
                                      },
                                    ),
                                    SizedBox(height: 120.h),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      case 1:
                        return const TopicsView();
                      case 3:
                        return Center(
                          child: Text(
                            AppLocalizations.of(context)!.statsScreen,
                            style: const TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        );
                      case 4:
                        return const SettingsScreen();
                      default:
                        return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ),
            
            // Floating Bottom Navigation & FAB
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 110.h,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    const CustomBottomNav(),
                    Positioned(
                      top: 4.h,
                      child: Container(
                        width: 64.w,
                        height: 64.w,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF5E5CE6), Color(0xFF3B39C2)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF5E5CE6).withValues(alpha: 0.4),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: FloatingActionButton(
                          shape: const CircleBorder(),
                          onPressed: () async {
                            final result = await showAddWordBottomSheet(context);
                            if (result == true && context.mounted) {
                              try { context.read<HomeBloc>().add(LoadHomeDataEvent()); } catch (_) {}
                              try { context.read<TopicsBloc>().add(LoadTopicsEvent()); } catch (_) {}
                            }
                          },
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          focusElevation: 0,
                          hoverElevation: 0,
                          highlightElevation: 0,
                          child: Icon(Icons.add_rounded, color: Colors.white, size: 36.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
        },
      ),
    );
  }
}
