import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_mate/l10n/app_localizations.dart';
import 'package:word_mate/injector.dart';
import 'package:word_mate/presentation/views/add_word/bloc/add_word_bloc.dart';
import 'package:word_mate/presentation/views/add_word/bloc/add_word_event.dart';
import 'package:word_mate/presentation/views/add_word/bloc/add_word_state.dart';
import 'package:word_mate/presentation/widgets/add_word/word_type_selector.dart';
import 'package:word_mate/presentation/widgets/add_word/topic_selector.dart';
import 'package:word_mate/presentation/widgets/add_word/add_word_submit_button.dart';

/// Shows the Add New Word bottom sheet.
/// Call this from the center nav button's onTap.
Future<bool?> showAddWordBottomSheet(BuildContext context, {int? preSelectedTopicId, bool hideTopicSelector = false}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) => injector<AddWordBloc>(),
      child: _AddWordSheetContent(
        preSelectedTopicId: preSelectedTopicId,
        hideTopicSelector: hideTopicSelector,
      ),
    ),
  );
}

class _AddWordSheetContent extends StatefulWidget {
  final int? preSelectedTopicId;
  final bool hideTopicSelector;

  const _AddWordSheetContent({
    this.preSelectedTopicId,
    this.hideTopicSelector = false,
  });

  @override
  State<_AddWordSheetContent> createState() => _AddWordSheetContentState();
}

class _AddWordSheetContentState extends State<_AddWordSheetContent> {
  @override
  void initState() {
    super.initState();
    // Delay loading database topics until animation finishes to avoid stuttering transition
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        context.read<AddWordBloc>().add(LoadTopicsEvent(preSelectedTopicId: widget.preSelectedTopicId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<AddWordBloc, AddWordState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == AddWordStatus.success) {
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
        } else if (state.status == AddWordStatus.failure) {
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
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

                  // Title
                  Center(
                    child: Text(
                      l10n.newWord,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Word input
                  _buildTextField(
                    context,
                    hintText: l10n.enterWord,
                    onChanged: (v) =>
                        context.read<AddWordBloc>().add(UpdateWordEvent(v)),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s\-\']")),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Meaning input
                  _buildTextField(
                    context,
                    hintText: l10n.meaningHint,
                    onChanged: (v) =>
                        context.read<AddWordBloc>().add(UpdateMeaningEvent(v)),
                  ),
                  SizedBox(height: 20.h),

                  // Word Type section
                  const WordTypeSection(),
                  SizedBox(height: 20.h),

                  // Topics section
                  if (!widget.hideTopicSelector) ...[
                    const TopicsSection(),
                    SizedBox(height: 28.h),
                  ] else
                    SizedBox(height: 16.h),

                  // Submit button
                  const AddWordSubmitButton(),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String hintText,
    required ValueChanged<String> onChanged,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: TextField(
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        style: TextStyle(color: Colors.white, fontSize: 16.sp),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 16.sp,
          ),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        ),
      ),
    );
  }
}
