import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_mate/presentation/views/add_word/add_word_bottom_sheet.dart';
import 'package:word_mate/presentation/widgets/bottom_nav/bottom_nav_bloc.dart';
import 'package:word_mate/presentation/widgets/bottom_nav/bottom_nav_event.dart';
import 'package:word_mate/presentation/widgets/bottom_nav/bottom_nav_state.dart';
import 'package:word_mate/presentation/widgets/bottom_nav/radial_menu_item.dart';
import 'package:word_mate/presentation/views/home/bloc/home_bloc.dart';
import 'package:word_mate/presentation/views/home/bloc/home_event.dart';
import 'package:word_mate/presentation/views/topics/bloc/topics_bloc.dart';
import 'package:word_mate/presentation/views/topics/bloc/topics_event.dart';

class RadialMenu extends StatefulWidget {
  const RadialMenu({super.key});

  @override
  State<RadialMenu> createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu> with SingleTickerProviderStateMixin {
  final double _distance = 75.w; // Compact radius
  double _scrollOffset = 0.0;
  late AnimationController _snapController;
  Animation<double>? _snapAnimation;
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.home_rounded, 'label': 'Home', 'tab': 0},
    {'icon': Icons.grid_view_rounded, 'label': 'Topics', 'tab': 1},
    {'icon': Icons.bar_chart_rounded, 'label': 'Stats', 'tab': 3},
    {'icon': Icons.settings_rounded, 'label': 'Settings', 'tab': 4},
  ];

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 300)
    );
    _snapController.addListener(() {
      if (_snapAnimation != null) {
        setState(() {
          _scrollOffset = _snapAnimation!.value;
        });
      }
    });
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  int _getMenuIndexFromTab(int tabIndex) {
    int idx = _menuItems.indexWhere((item) => item['tab'] == tabIndex);
    return idx != -1 ? idx : 0;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      // Tweak sensitivity. Negative because swiping up should advance the menu.
      _scrollOffset -= details.delta.dy * 0.015 + details.delta.dx * 0.015;
      
      // Wrap around logic
      if (_scrollOffset < -0.5) _scrollOffset += 4.0;
      if (_scrollOffset > 3.5) _scrollOffset -= 4.0;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    double target = _scrollOffset.roundToDouble();
    if (target < 0) target = 3;
    if (target > 3) target = 0;

    // Small hack to handle wrapping jump in animation
    if ((target - _scrollOffset).abs() > 2) {
      if (target == 0 && _scrollOffset > 3) {
        _scrollOffset -= 4.0;
      } else if (target == 3 && _scrollOffset < 0) {
        _scrollOffset += 4.0;
      }
    }

    _snapAnimation = Tween<double>(begin: _scrollOffset, end: target).animate(
      CurvedAnimation(parent: _snapController, curve: Curves.easeOutCubic)
    );

    _snapController.forward(from: 0).then((_) {
      int newIndex = target.toInt() % 4;
      if (newIndex < 0) newIndex += 4;

      if (_currentIndex != newIndex) {
        _currentIndex = newIndex;
        HapticFeedback.selectionClick();
        
        int tabIndex = _menuItems[_currentIndex]['tab'] as int;
        context.read<BottomNavBloc>().add(ChangeTabEvent(tabIndex));
      }
    });
  }

  Widget _buildItem(int index, Map<String, dynamic> item) {
    double diff = (index - _scrollOffset) % 4;
    if (diff > 2) diff -= 4;
    if (diff < -2) diff += 4;

    // 1.25 * pi is 225 degrees (top-left of FAB)
    double angle = (1.25 * pi) + (diff * pi / 4);

    double offsetX = _distance * cos(angle);
    double offsetY = _distance * sin(angle);

    double opacity = 1.0 - (diff.abs() * 0.7);
    opacity = opacity.clamp(0.0, 1.0);

    double scale = 1.0 - (diff.abs() * 0.4);
    scale = scale.clamp(0.4, 1.0);

    if (opacity == 0) return const SizedBox.shrink();

    return Positioned(
      bottom: 0,
      right: 0,
      child: Transform.translate(
        offset: Offset(offsetX, offsetY),
        child: Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: RadialMenuItem(
              icon: item['icon'] as IconData,
              label: item['label'] as String,
              isSelected: diff.abs() < 0.1,
              angleOffset: 0, // No counter-rotation needed anymore as we don't rotate the canvas
              onTap: () {
                if (diff.abs() > 0.1) {
                  // Tap on a non-active item to scroll to it
                  setState(() {
                    _scrollOffset = index.toDouble();
                    _currentIndex = index;
                  });
                  HapticFeedback.selectionClick();
                  context.read<BottomNavBloc>().add(ChangeTabEvent(item['tab'] as int));
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BottomNavBloc, BottomNavState>(
      listenWhen: (previous, current) => previous.selectedIndex != current.selectedIndex,
      listener: (context, state) {
        int targetIndex = _getMenuIndexFromTab(state.selectedIndex);
        if (_currentIndex != targetIndex && !_snapController.isAnimating) {
          setState(() {
            _scrollOffset = targetIndex.toDouble();
            _currentIndex = targetIndex;
          });
        }
      },
      builder: (context, state) {
        return SizedBox(
          width: 200.w,
          height: 200.w,
          child: Stack(
            alignment: Alignment.bottomRight,
            clipBehavior: Clip.none,
            children: [
              // Gesture Area
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: Container(color: Colors.transparent),
                ),
              ),
              
              // Animated Menu Items
              for (int i = 0; i < _menuItems.length; i++)
                _buildItem(i, _menuItems[i]),
              
              // Fixed Main FAB (Add Word)
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    final result = await showAddWordBottomSheet(context);
                    if (result == true && context.mounted) {
                      try {
                        context.read<HomeBloc>().add(LoadHomeDataEvent());
                      } catch (_) {}
                      try {
                        context.read<TopicsBloc>().add(LoadTopicsEvent());
                      } catch (_) {}
                    }
                  },
                  child: Container(
                    width: 64.w,
                    height: 64.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9D63FF), Color(0xFF6F3AE0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF9D63FF).withValues(alpha: 0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(Icons.add_rounded, color: Colors.white, size: 36.sp),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
