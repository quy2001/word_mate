import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvatarSelector extends StatelessWidget {
  final List<String> avatars;
  final String? selectedAvatar;
  final ValueChanged<String> onAvatarSelected;

  const AvatarSelector({
    super.key,
    required this.avatars,
    this.selectedAvatar,
    required this.onAvatarSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16.w,
      runSpacing: 16.h,
      alignment: WrapAlignment.center,
      children: avatars.map((avatar) {
        final isSelected = avatar == selectedAvatar;
        return GestureDetector(
          onTap: () => onAvatarSelected(avatar),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 70.w,
            height: 70.w,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
              border: Border.all(
                color: isSelected ? const Color(0xFF9D63FF) : Colors.white.withOpacity(0.2),
                width: isSelected ? 2.w : 1.w,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF9D63FF).withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 2,
                      )
                    ]
                  : null,
            ),
            child: Image.asset(avatar),
          ),
        );
      }).toList(),
    );
  }
}
