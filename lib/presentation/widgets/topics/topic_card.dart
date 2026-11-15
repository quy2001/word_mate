import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_mate/l10n/app_localizations.dart';

class TopicCard extends StatelessWidget {
  final String name;
  final int wordCount;
  final Color themeColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isDeleteMode;
  final VoidCallback? onDelete;

  const TopicCard({
    super.key,
    required this.name,
    required this.wordCount,
    required this.themeColor,
    this.onTap,
    this.onLongPress,
    this.isDeleteMode = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: Stack(
            children: [
              // Background and Border
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E163B).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                      width: 2,
                    ),
                  ),
                ),
              ),
              // Fading background gradient matching themeColor
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    gradient: LinearGradient(
                      colors: [
                        themeColor.withValues(alpha: 0.15),
                        themeColor.withValues(alpha: 0.02),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // Top glowing border highlight
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 3.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        themeColor.withValues(alpha: 0.2),
                        themeColor,
                        themeColor.withValues(alpha: 0.2),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: themeColor.withValues(alpha: 0.6),
                        blurRadius: 8.r,
                        spreadRadius: 1.r,
                      ),
                    ],
                  ),
                ),
              ),
              // Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        l10n.wordsCount(wordCount),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Delete Icon Badge (top-left)
                if (isDeleteMode)
                  Positioned(
                    top: 10.h,
                    left: 10.w,
                    child: GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF4D4D),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 14.sp,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
  }
}
