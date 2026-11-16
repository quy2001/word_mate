import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_mate/domain/repositories/app_settings_repository.dart';
import 'package:word_mate/domain/usecases/save_daily_goal_usecase.dart';
import 'package:word_mate/domain/usecases/save_user_profile_usecase.dart';
import 'package:word_mate/gen/assets.gen.dart';
import 'package:word_mate/injector.dart';
import 'package:word_mate/l10n/app_localizations.dart';
import 'package:word_mate/presentation/views/home/bloc/home_bloc.dart';
import 'package:word_mate/presentation/views/home/bloc/home_event.dart';
import 'package:word_mate/presentation/views/settings/bloc/locale_bloc.dart';
import 'package:word_mate/presentation/views/settings/bloc/locale_event.dart';
import 'package:word_mate/presentation/views/settings/bloc/locale_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _nickname = 'Learner';
  String _avatarPath = Assets.images.fox.path;
  int _dailyGoal = 10;

  final List<String> _avatars = [
    Assets.images.fox.path,
    Assets.images.moon.path,
    Assets.images.octopus.path,
    Assets.images.thunder.path,
    Assets.images.darts.path,
    Assets.images.books.path,
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final repo = injector<AppSettingsRepository>();
    final nickname = await repo.getNickname();
    final avatar = await repo.getAvatar();
    final goal = await repo.getDailyGoal();
    if (mounted) {
      setState(() {
        _nickname = nickname ?? 'Learner';
        _avatarPath = avatar ?? Assets.images.fox.path;
        _dailyGoal = goal ?? 10;
      });
    }
  }

  Future<void> _updateGoal(int newGoal) async {
    if (newGoal < 1 || newGoal > 100) return;
    setState(() => _dailyGoal = newGoal);
    await injector<SaveDailyGoalUseCase>()(SaveDailyGoalParams(goal: newGoal));
    if (mounted) {
      try {
        context.read<HomeBloc>().add(LoadHomeDataEvent());
      } catch (_) {}
    }
  }

  void _showEditProfileBottomSheet() {
    final l10n = AppLocalizations.of(context)!;
    final textController = TextEditingController(text: _nickname);
    String tempAvatar = _avatarPath;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1235),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      l10n.chooseAvatar,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Wrap(
                      spacing: 14.w,
                      runSpacing: 14.h,
                      alignment: WrapAlignment.center,
                      children: _avatars.map((av) {
                        final isSel = av == tempAvatar;
                        return GestureDetector(
                          onTap: () => setModalState(() => tempAvatar = av),
                          child: Container(
                            width: 60.w,
                            height: 60.w,
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSel
                                  ? const Color(0xFF9D63FF).withValues(alpha: 0.25)
                                  : Colors.white.withValues(alpha: 0.05),
                              border: Border.all(
                                color: isSel
                                    ? const Color(0xFF9D63FF)
                                    : Colors.white.withValues(alpha: 0.15),
                                width: isSel ? 2 : 1,
                              ),
                            ),
                            child: Image.asset(av),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 24.h),
                    TextField(
                      controller: textController,
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      decoration: InputDecoration(
                        hintText: l10n.nicknameHint,
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 15.sp,
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.06),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    GestureDetector(
                      onTap: () async {
                        final newNick = textController.text.trim();
                        if (newNick.isEmpty) return;
                        await injector<SaveUserProfileUseCase>()(
                          SaveUserProfileParams(
                            nickname: newNick,
                            avatarPath: tempAvatar,
                          ),
                        );
                        if (mounted) {
                          setState(() {
                            _nickname = newNick;
                            _avatarPath = tempAvatar;
                          });
                          try {
                            context.read<HomeBloc>().add(LoadHomeDataEvent());
                          } catch (_) {}
                        }
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 48.h,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9D63FF), Color(0xFF6F3AE0)],
                          ),
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          l10n.add,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),

            // Header
            Text(
              l10n.settings,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.h),

            // Profile Card
            _buildSectionTitle(l10n.profile),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56.w,
                    height: 56.w,
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF9D63FF).withValues(alpha: 0.2),
                      border: Border.all(
                        color: const Color(0xFF9D63FF),
                        width: 1.5,
                      ),
                    ),
                    child: Image.asset(_avatarPath),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nickname,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          l10n.wordMateLearner,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit_rounded, color: const Color(0xFF9D63FF), size: 22.sp),
                    onPressed: _showEditProfileBottomSheet,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Daily Goal Section
            _buildSectionTitle(l10n.todaysGoal),
            SizedBox(height: 12.h),
            Container(
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
                      Text(
                        l10n.targetWordsPerDay,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9D63FF).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Text(
                          '$_dailyGoal ${l10n.wordsPerDay}',
                          style: TextStyle(
                            color: const Color(0xFF9D63FF),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [5, 10, 15, 20, 25].map((g) {
                      final isSelected = g == _dailyGoal;
                      return GestureDetector(
                        onTap: () => _updateGoal(g),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF9D63FF)
                                : Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF9D63FF)
                                  : Colors.white.withValues(alpha: 0.12),
                            ),
                          ),
                          child: Text(
                            '$g',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Language Section
            _buildSectionTitle(l10n.appLanguage),
            SizedBox(height: 8.h),
            Text(
              l10n.chooseLanguage,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 16.h),

            BlocBuilder<LocaleBloc, LocaleState>(
              builder: (context, state) {
                return Column(
                  children: [
                    _LanguageOption(
                      flag: '🇺🇸',
                      languageName: l10n.english,
                      subtitle: 'English',
                      isSelected: state.locale.languageCode == 'en',
                      onTap: () {
                        context
                            .read<LocaleBloc>()
                            .add(ChangeLocaleEvent(const Locale('en')));
                      },
                    ),
                    SizedBox(height: 12.h),
                    _LanguageOption(
                      flag: '🇻🇳',
                      languageName: l10n.vietnamese,
                      subtitle: 'Tiếng Việt',
                      isSelected: state.locale.languageCode == 'vi',
                      onTap: () {
                        context
                            .read<LocaleBloc>()
                            .add(ChangeLocaleEvent(const Locale('vi')));
                      },
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 120.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 20.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF9D63FF), Color(0xFF6F3AE0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String flag;
  final String languageName;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.flag,
    required this.languageName,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6F3AE0).withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF9D63FF).withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.1),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF9D63FF).withValues(alpha: 0.15),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: TextStyle(fontSize: 28.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF9D63FF)
                      : Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFF9D63FF), Color(0xFF6F3AE0)],
                      )
                    : null,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 14.sp,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
