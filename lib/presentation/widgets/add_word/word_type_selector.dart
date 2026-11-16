import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_mate/common/index.dart';
import 'package:word_mate/l10n/app_localizations.dart';
import 'package:word_mate/presentation/views/add_word/bloc/add_word_bloc.dart';
import 'package:word_mate/presentation/views/add_word/bloc/add_word_event.dart';
import 'package:word_mate/presentation/views/add_word/bloc/add_word_state.dart';

class WordTypeSection extends StatelessWidget {
  const WordTypeSection({super.key});

  static const _types = ['Noun', 'Verb', 'Adj', 'Adv', 'Other'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.wordType,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10.h),
        BlocBuilder<AddWordBloc, AddWordState>(
          buildWhen: (prev, curr) => prev.selectedType != curr.selectedType,
          builder: (context, state) {
            return Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: _types.map((type) {
                final isSelected =
                    state.selectedType?.toLowerCase() == type.toLowerCase();
                return TypeChip(
                  label: AppUtils.getLocalizedWordType(type, l10n),
                  isSelected: isSelected,
                  onTap: () => context
                      .read<AddWordBloc>()
                      .add(SelectWordTypeEvent(type.toLowerCase())),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class TypeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const TypeChip({
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
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6F3AE0)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF9D63FF)
                : Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF9D63FF).withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.7),
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
