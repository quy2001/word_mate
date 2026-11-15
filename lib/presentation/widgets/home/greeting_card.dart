import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_mate/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class GreetingCard extends StatelessWidget {
  final String nickname;
  final String? avatarPath;

  const GreetingCard({
    super.key,
    required this.nickname,
    this.avatarPath,
  });

  String _getGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.goodMorning;
    if (hour < 17) return l10n.goodAfternoon;
    return l10n.goodEvening;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = DateFormat('EEEE, dd MMM', locale).format(now);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_getGreeting(l10n)} ✨',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                dateStr,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF9D63FF).withValues(alpha: 0.6),
                    width: 2.w,
                  ),
                ),
                child: ClipOval(
                  child: avatarPath != null
                      ? Image.asset(avatarPath!, fit: BoxFit.cover)
                      : Icon(Icons.person, color: Colors.white, size: 28.sp),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                nickname,
                style: TextStyle(
                  color: const Color(0xFF9D63FF),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
