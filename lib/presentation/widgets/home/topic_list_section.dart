import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:word_mate/l10n/app_localizations.dart';
import 'package:word_mate/presentation/views/home/bloc/home_bloc.dart';
import 'package:word_mate/presentation/views/home/bloc/home_event.dart';

class TopicListSection extends StatelessWidget {
  final List<Map<String, dynamic>> topics;
  final VoidCallback? onAddTopic;

  const TopicListSection({
    super.key,
    required this.topics,
    this.onAddTopic,
  });

  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return const Color(0xFF9D63FF);
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return const Color(0xFF9D63FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.popularTopics,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.more_horiz,
              color: Colors.white.withValues(alpha: 0.5),
              size: 20.sp,
            ),
          ],
        ),
        SizedBox(height: 14.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              ...topics.map((topic) {
                final name = (topic['name'] as String?) ?? 'Topic';
                final colorHex = topic['color_hex'] as String?;
                final chipColor = _parseColor(colorHex);
                final topicId = topic['topic_id'] as int?;

                return Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: GestureDetector(
                    onTap: () async {
                      if (topicId != null) {
                        await context.push(
                          '/topic-words',
                          extra: {
                            'topicId': topicId,
                            'topicName': name,
                          },
                        );
                        if (context.mounted) {
                          context.read<HomeBloc>().add(LoadHomeDataEvent());
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: chipColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: chipColor.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        name,
                        style: TextStyle(
                          color: chipColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }),
              // Nút thêm topic mới
              GestureDetector(
                onTap: onAddTopic,
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9D63FF).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF9D63FF).withValues(alpha: 0.5),
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    color: const Color(0xFF9D63FF),
                    size: 18.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
