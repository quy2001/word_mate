import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_mate/l10n/app_localizations.dart';
import 'package:word_mate/presentation/views/add_word/bloc/add_word_bloc.dart';
import 'package:word_mate/presentation/views/add_word/bloc/add_word_event.dart';
import 'package:word_mate/presentation/views/add_word/bloc/add_word_state.dart';

class AddWordSubmitButton extends StatelessWidget {
  const AddWordSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<AddWordBloc, AddWordState>(
      buildWhen: (prev, curr) =>
          prev.isValid != curr.isValid || prev.status != curr.status,
      builder: (context, state) {
        final isEnabled =
            state.isValid && state.status != AddWordStatus.submitting;
        return GestureDetector(
          onTap: isEnabled
              ? () => context.read<AddWordBloc>().add(SubmitWordEvent())
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              gradient: isEnabled
                  ? const LinearGradient(
                      colors: [Color(0xFF9D63FF), Color(0xFF6F3AE0)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
              color: isEnabled ? null : Colors.white.withValues(alpha: 0.05),
              boxShadow: isEnabled
                  ? [
                      BoxShadow(
                        color:
                            const Color(0xFF9D63FF).withValues(alpha: 0.4),
                        blurRadius: 15,
                        spreadRadius: 1,
                      )
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state.status == AddWordStatus.submitting) ...[
                  SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.w,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10.w),
                ],
                Text(
                  l10n.addToWordy,
                  style: TextStyle(
                    color: isEnabled
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.3),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
