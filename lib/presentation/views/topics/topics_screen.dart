import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_mate/common/index.dart';
import 'package:word_mate/l10n/app_localizations.dart';
import 'package:word_mate/presentation/views/topics/bloc/topics_bloc.dart';
import 'package:word_mate/presentation/views/topics/bloc/topics_event.dart';
import 'package:word_mate/presentation/views/topics/bloc/topics_state.dart';
import 'package:word_mate/presentation/views/home/bloc/home_bloc.dart';
import 'package:word_mate/presentation/views/home/bloc/home_event.dart';
import 'package:word_mate/presentation/widgets/topics/add_topic_card.dart';
import 'package:word_mate/presentation/widgets/topics/topic_card.dart';
import 'package:word_mate/presentation/widgets/topics/wiggle_wrapper.dart';

class TopicsView extends StatelessWidget {
  const TopicsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _TopicsViewContent();
  }
}

class _TopicsViewContent extends StatefulWidget {
  const _TopicsViewContent();

  @override
  State<_TopicsViewContent> createState() => _TopicsViewContentState();
}

class _TopicsViewContentState extends State<_TopicsViewContent> {
  final TextEditingController _searchController = TextEditingController();
  bool _isDeleteMode = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        if (_isDeleteMode) {
          setState(() {
            _isDeleteMode = false;
          });
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          // Search Input
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                context.read<TopicsBloc>().add(SearchTopicsEvent(value));
              },
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
              decoration: InputDecoration(
                hintText: l10n.searchTopics,
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 16.sp,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Colors.white.withValues(alpha: 0.4),
                  size: 20.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Grid List
          Expanded(
            child: BlocBuilder<TopicsBloc, TopicsState>(
              builder: (context, state) {
                if (state.status == TopicsStatus.loading && state.topics.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF9D63FF)),
                  );
                }

                if (state.status == TopicsStatus.error) {
                  return Center(
                    child: Text(
                      l10n.failedToLoadTopics,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  );
                }

                final topicsCount = state.topics.length;
                return GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 16.w,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: topicsCount + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return AddTopicCard(
                        onTap: () => _showAddTopicDialog(context),
                      );
                    }

                    // Shift indices by 1 for actual topics
                    final topicIndex = index - 1;
                    final topic = state.topics[topicIndex];
                    final rawName = topic['name'] as String;
                    final topicId = topic['topic_id'] as int;
                    final name = AppUtils.getLocalizedTopicName(
                      topicId: topicId,
                      rawName: rawName,
                      l10n: l10n,
                    );
                    final wordCount = topic['word_count'] as int? ?? 0;
                    final colorHex = topic['color_hex'] as String? ?? '#9E5DF2';
                    final themeColor = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));

                    return WiggleWrapper(
                      animate: _isDeleteMode,
                      child: TopicCard(
                        name: name,
                        wordCount: wordCount,
                        themeColor: themeColor,
                        isDeleteMode: _isDeleteMode,
                        onLongPress: () {
                          if (!_isDeleteMode) {
                            setState(() {
                              _isDeleteMode = true;
                            });
                          }
                        },
                        onTap: () async {
                          if (_isDeleteMode) {
                            setState(() {
                              _isDeleteMode = false;
                            });
                          } else {
                            await context.push(
                              '/topic-words',
                              extra: {
                                'topicId': topicId,
                                'topicName': name,
                              },
                            );
                            if (context.mounted) {
                              try {
                                context.read<TopicsBloc>().add(LoadTopicsEvent());
                              } catch (_) {}
                              try {
                                context.read<HomeBloc>().add(LoadHomeDataEvent());
                              } catch (_) {}
                            }
                          }
                        },
                        onDelete: () {
                          _showDeleteConfirmationDialog(context, topicId, name);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    ),
  );
}

  void _showDeleteConfirmationDialog(
      BuildContext blocContext, int topicId, String topicName) {
    final l10n = AppLocalizations.of(blocContext)!;
    showDialog(
      context: blocContext,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 32.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1E163B).withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(28.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: const Color(0xFFFF4D4D),
                        size: 24.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        l10n.deleteTopic,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    l10n.deleteTopicConfirm(topicName),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14.sp,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.of(dialogContext).pop(),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.12),
                              ),
                              color: Colors.white.withValues(alpha: 0.02),
                            ),
                            child: Center(
                              child: Text(
                                l10n.cancel,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            blocContext
                                .read<TopicsBloc>()
                                .add(DeleteTopicEvent(topicId));
                            Navigator.of(dialogContext).pop();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFF5E5E),
                                  Color(0xFFFF3333),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF3333)
                                      .withValues(alpha: 0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                l10n.delete,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddTopicDialog(BuildContext blocContext) {
    final l10n = AppLocalizations.of(blocContext)!;
    final controller = TextEditingController();
    String selectedColorHex = '#9E5DF2'; // Default purple color

    showDialog(
      context: blocContext,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1E163B).withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(28.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 1.5,
                ),
              ),
              child: StatefulBuilder(
                builder: (context, setState) {
                  final List<String> colorsHex = [
                    '#9E5DF2', // Purple
                    '#2FE3D6', // Teal
                    '#FFB82E', // Yellow
                    '#338BFF', // Blue
                    '#FF5E99', // Pink
                    '#FF6B6B', // Terracotta
                  ];

                  Color hexToColor(String hex) {
                    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Row(
                        children: [
                          Text(
                            l10n.newTopic,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            '✨',
                            style: TextStyle(fontSize: 20.sp),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // Label Topic Name
                      Text(
                        l10n.topicName,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // Input Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: controller,
                          autofocus: true,
                          style: TextStyle(color: Colors.white, fontSize: 16.sp),
                          decoration: InputDecoration(
                            hintText: l10n.topicNameHint,
                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.35),
                              fontSize: 15.sp,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Label Color Picker
                      Text(
                        l10n.chooseThemeColor,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Colors Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: colorsHex.map((hex) {
                          final isSelected = selectedColorHex == hex;
                          final color = hexToColor(hex);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedColorHex = hex;
                              });
                            },
                            child: Container(
                              width: 38.w,
                              height: 38.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(color: Colors.white, width: 2.w)
                                    : null,
                              ),
                              padding: isSelected
                                  ? EdgeInsets.all(3.w)
                                  : EdgeInsets.zero,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 28.h),

                      // Buttons Row
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => Navigator.of(dialogContext).pop(),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.12),
                                  ),
                                  color: Colors.white.withValues(alpha: 0.02),
                                ),
                                child: Center(
                                  child: Text(
                                    l10n.cancel,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (controller.text.trim().isNotEmpty) {
                                  blocContext.read<TopicsBloc>().add(
                                        AddTopicEvent(
                                          controller.text.trim(),
                                          colorHex: selectedColorHex,
                                        ),
                                      );
                                  Navigator.of(dialogContext).pop();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF8C71F2),
                                      Color(0xFF6C5DD3),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF6C5DD3)
                                          .withValues(alpha: 0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    l10n.createTopic,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
