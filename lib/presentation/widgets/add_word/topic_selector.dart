import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_mate/common/index.dart';
import 'package:word_mate/l10n/app_localizations.dart';
import 'package:word_mate/presentation/views/add_word/bloc/add_word_bloc.dart';
import 'package:word_mate/presentation/views/add_word/bloc/add_word_event.dart';
import 'package:word_mate/presentation/views/add_word/bloc/add_word_state.dart';

class TopicsSection extends StatelessWidget {
  const TopicsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.topics,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10.h),
        BlocBuilder<AddWordBloc, AddWordState>(
          buildWhen: (prev, curr) =>
              prev.topics != curr.topics ||
              prev.selectedTopicId != curr.selectedTopicId,
          builder: (context, state) {
            return Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                ...state.topics.map((topic) {
                  final topicId = topic['topic_id'] as int;
                  final rawName = topic['name'] as String;
                  final name = AppUtils.getLocalizedTopicName(
                    topicId: topicId,
                    rawName: rawName,
                    l10n: l10n,
                  );
                  final isSelected = state.selectedTopicId == topicId;
                  return TopicChip(
                    label: name,
                    isSelected: isSelected,
                    onTap: () => context
                        .read<AddWordBloc>()
                        .add(SelectTopicEvent(topicId)),
                  );
                }),
                // "+ New" button
                AddTopicChip(
                  onTap: () => _showAddTopicDialog(context),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _showAddTopicDialog(BuildContext blocContext) {
    final l10n = AppLocalizations.of(blocContext)!;
    final controller = TextEditingController();
    showDialog(
      context: blocContext,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF231A3D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          l10n.newTopic,
          style: TextStyle(color: Colors.white, fontSize: 18.sp),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
          decoration: InputDecoration(
            hintText: l10n.topicNameHint2,
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF9D63FF)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              l10n.cancel,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                blocContext
                    .read<AddWordBloc>()
                    .add(AddNewTopicEvent(controller.text));
                Navigator.of(dialogContext).pop();
              }
            },
            child: Text(
              l10n.add,
              style: const TextStyle(color: Color(0xFF9D63FF)),
            ),
          ),
        ],
      ),
    );
  }
}

class TopicChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const TopicChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6F3AE0).withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF9D63FF)
                : Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.label_rounded,
              color: isSelected
                  ? const Color(0xFF9D63FF)
                  : Colors.white.withValues(alpha: 0.5),
              size: 16.sp,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.7),
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddTopicChip extends StatelessWidget {
  final VoidCallback onTap;

  const AddTopicChip({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: const Color(0xFF9D63FF).withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_rounded,
              color: const Color(0xFF9D63FF),
              size: 16.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              l10n.newLabel,
              style: TextStyle(
                color: const Color(0xFF9D63FF),
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
