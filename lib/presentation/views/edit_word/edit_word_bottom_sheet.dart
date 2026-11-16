import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_mate/common/index.dart';
import 'package:word_mate/injector.dart';
import 'package:word_mate/l10n/app_localizations.dart';
import 'package:word_mate/presentation/views/edit_word/bloc/edit_word_bloc.dart';
import 'package:word_mate/presentation/views/edit_word/bloc/edit_word_event.dart';
import 'package:word_mate/presentation/views/edit_word/bloc/edit_word_state.dart';

Future<bool?> showEditWordBottomSheet(
  BuildContext context, {
  required Map<String, dynamic> cardData,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) => injector<EditWordBloc>()..add(InitEditWordEvent(cardData)),
      child: const _EditWordSheetContent(),
    ),
  );
}

class _EditWordSheetContent extends StatelessWidget {
  const _EditWordSheetContent();

  static const _types = ['Noun', 'Verb', 'Adj', 'Adv', 'Other'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<EditWordBloc, EditWordState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == EditWordStatus.success) {
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.wordAdded),
              backgroundColor: const Color(0xFF6F3AE0),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
        } else if (state.status == EditWordStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.failedToAddWord),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
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
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
              child: BlocBuilder<EditWordBloc, EditWordState>(
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Center(
                        child: Text(
                          l10n.edit,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      TextFormField(
                        initialValue: state.word,
                        onChanged: (v) =>
                            context.read<EditWordBloc>().add(UpdateEditWordTextEvent(v)),
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s\-\']")),
                        ],
                        decoration: InputDecoration(
                          hintText: l10n.enterWord,
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.35),
                            fontSize: 15.sp,
                          ),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.05),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(
                              color: Colors.white.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(
                              color: Colors.white.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: const BorderSide(
                              color: Color(0xFF9D63FF),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      TextFormField(
                        initialValue: state.meaning,
                        onChanged: (v) =>
                            context.read<EditWordBloc>().add(UpdateEditMeaningTextEvent(v)),
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        decoration: InputDecoration(
                          hintText: l10n.meaningHint,
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.35),
                            fontSize: 15.sp,
                          ),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.05),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(
                              color: Colors.white.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(
                              color: Colors.white.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: const BorderSide(
                              color: Color(0xFF9D63FF),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        l10n.wordType,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: _types.map((type) {
                          final isSelected =
                              state.selectedType?.toLowerCase() == type.toLowerCase();
                          return GestureDetector(
                            onTap: () => context
                                .read<EditWordBloc>()
                                .add(SelectEditWordTypeEvent(type)),
                            child: Container(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF9D63FF)
                                    : Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF9D63FF)
                                      : Colors.white.withValues(alpha: 0.15),
                                ),
                              ),
                              child: Text(
                                AppUtils.getLocalizedWordType(type, l10n),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight:
                                      isSelected ? FontWeight.w600 : FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        l10n.topics,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: state.topics.map((topic) {
                          final topicId = topic['topic_id'] as int;
                          final rawName = topic['name'] as String;
                          final name = AppUtils.getLocalizedTopicName(
                            topicId: topicId,
                            rawName: rawName,
                            l10n: l10n,
                          );
                          final isSelected = state.selectedTopicId == topicId;
                          return GestureDetector(
                            onTap: () => context
                                .read<EditWordBloc>()
                                .add(SelectEditTopicEvent(topicId)),
                            child: Container(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF6F3AE0)
                                    : Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF9D63FF)
                                      : Colors.white.withValues(alpha: 0.15),
                                ),
                              ),
                              child: Text(
                                name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight:
                                      isSelected ? FontWeight.w600 : FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 28.h),
                      GestureDetector(
                        onTap: (state.isValid && state.status != EditWordStatus.submitting)
                            ? () => context
                                .read<EditWordBloc>()
                                .add(const SubmitEditWordEvent())
                            : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          height: 52.h,
                          decoration: BoxDecoration(
                            gradient: state.isValid
                                ? const LinearGradient(
                                    colors: [Color(0xFF9D63FF), Color(0xFF6F3AE0)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            color: state.isValid
                                ? null
                                : Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(26.r),
                            boxShadow: state.isValid
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF9D63FF).withValues(alpha: 0.4),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ]
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: state.status == EditWordStatus.submitting
                              ? SizedBox(
                                  width: 24.w,
                                  height: 24.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  l10n.edit,
                                  style: TextStyle(
                                    color: state.isValid
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.35),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
