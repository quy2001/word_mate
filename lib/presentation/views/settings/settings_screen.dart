import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_mate/l10n/app_localizations.dart';
import 'package:word_mate/presentation/views/settings/bloc/locale_bloc.dart';
import 'package:word_mate/presentation/views/settings/bloc/locale_event.dart';
import 'package:word_mate/presentation/views/settings/bloc/locale_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
            SizedBox(height: 32.h),

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

            SizedBox(height: 40.h),
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
            // Flag
            Text(
              flag,
              style: TextStyle(fontSize: 28.sp),
            ),
            SizedBox(width: 16.w),
            // Language name & subtitle
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
            // Selected indicator
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
