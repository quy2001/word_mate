import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_mate/common/index.dart';
import 'package:word_mate/l10n/app_localizations.dart';
import 'package:word_mate/injector.dart';
import 'package:word_mate/presentation/views/add_word/add_word_bottom_sheet.dart';
import 'package:word_mate/presentation/views/topics/bloc/topic_words_bloc.dart';
import 'package:word_mate/presentation/views/topics/bloc/topic_words_event.dart';
import 'package:word_mate/presentation/views/topics/bloc/topic_words_state.dart';
import 'package:word_mate/presentation/views/flash_card/flash_card_screen.dart';
import 'package:word_mate/presentation/views/word_detail/word_detail_screen.dart';
import 'package:word_mate/presentation/widgets/register/gradient_background.dart';

class TopicWordsScreen extends StatelessWidget {
  final int? initialTopicId;
  final String? initialTopicName;

  const TopicWordsScreen({
    super.key,
    this.initialTopicId,
    this.initialTopicName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TopicWordsBloc>(
      create: (context) => injector<TopicWordsBloc>()
        ..add(InitTopicWordsEvent(initialTopicId: initialTopicId)),
      child: _TopicWordsScreenContent(
        initialTopicId: initialTopicId,
        initialTopicName: initialTopicName,
      ),
    );
  }
}

class _TopicWordsScreenContent extends StatefulWidget {
  final int? initialTopicId;
  final String? initialTopicName;
  const _TopicWordsScreenContent({
    this.initialTopicId,
    this.initialTopicName,
  });

  @override
  State<_TopicWordsScreenContent> createState() =>
      _TopicWordsScreenContentState();
}

class _TopicWordsScreenContentState extends State<_TopicWordsScreenContent> {
  final TextEditingController _searchController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _searchController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Top App Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      AppUtils.getLocalizedTopicName(
                        topicId: widget.initialTopicId,
                        rawName: widget.initialTopicName,
                        l10n: l10n,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: (){
                        final currentTopicId = context.read<TopicWordsBloc>().state.selectedTopicId;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => FlashCardScreen(topicId: currentTopicId),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.card_giftcard_outlined,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 12.h),

              // Bloc State Builder
              Expanded(
                child: BlocBuilder<TopicWordsBloc, TopicWordsState>(
                  builder: (context, state) {
                    if (state.status == TopicWordsStatus.initial ||
                        (state.status == TopicWordsStatus.loading &&
                            state.topics.isEmpty)) {
                      return const Center(
                        child:
                            CircularProgressIndicator(color: Color(0xFF9D63FF)),
                      );
                    }

                    if (state.status == TopicWordsStatus.error) {
                      return Center(
                        child: Text(
                          l10n.failedToLoadVocab,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search bar & Words count info
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.12),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 16.w),
                                Icon(
                                  Icons.assignment_outlined,
                                  color: Colors.white.withValues(alpha: 0.4),
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  l10n.wordsCount(state.cards.length),
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: (val) {
                                      context
                                          .read<TopicWordsBloc>()
                                          .add(SearchWordsEvent(val));
                                    },
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.sp),
                                    decoration: InputDecoration(
                                      hintText: l10n.searchWord,
                                      hintStyle: TextStyle(
                                        color:
                                            Colors.white.withValues(alpha: 0.3),
                                        fontSize: 15.sp,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(4.w),
                                  padding: EdgeInsets.all(10.w),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF1A1235),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        SizedBox(height: 16.h),

                        // Vocabulary Words cards list
                        Expanded(
                          child: state.cards.isEmpty
                              ? Center(
                                  child: Text(
                                    l10n.noWordsFound,
                                    style: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.4),
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 4.h, 20.w, 80.h),
                                  itemCount: state.cards.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: 16.h),
                                    itemBuilder: (context, index) {
                                      final card = state.cards[index];
                                      return _WordCard(
                                        card: card,
                                        onPlayAudio: () async {
                                          final audioPath = card['audio_path'] as String? ?? '';
                                          if (audioPath.isNotEmpty) {
                                            try {
                                              await _audioPlayer.play(UrlSource(audioPath));
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text(l10n.cannotPlayAudio)),
                                                );
                                              }
                                            }
                                          } else {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text(l10n.noAudioData)),
                                              );
                                            }
                                          }
                                        },
                                      );
                                    },
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<TopicWordsBloc, TopicWordsState>(
        builder: (context, state) {
          final currentTopicId = state.selectedTopicId;
          return FloatingActionButton(
            onPressed: () async {
              final result = await showAddWordBottomSheet(
                context,
                preSelectedTopicId: currentTopicId,
                hideTopicSelector: currentTopicId != null,
              );

              if (result == true && context.mounted) {
                context.read<TopicWordsBloc>().add(RefreshWordsEvent());
              }
            },
            backgroundColor: const Color(0xFF9D63FF),
            shape: const CircleBorder(),
            child: Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF9D63FF), Color(0xFF6F3AE0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9D63FF).withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 28.sp,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WordCard extends StatelessWidget {
  final Map<String, dynamic> card;
  final VoidCallback? onPlayAudio;

  const _WordCard({
    required this.card,
    this.onPlayAudio,
  });

  String _formatTimeAgo(BuildContext context, int timestampSeconds) {
    if (timestampSeconds == 0) return '';
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final createdAt =
        DateTime.fromMillisecondsSinceEpoch(timestampSeconds * 1000);
    final difference = now.difference(createdAt);

    int seconds = difference.inSeconds;
    if (seconds < 0) seconds = 0;

    if (seconds < 60) {
      return l10n.timeSeconds(seconds);
    }

    int minutes = difference.inMinutes;
    if (minutes < 60) {
      return l10n.timeMinutes(minutes);
    }

    int hours = difference.inHours;
    if (hours < 24) {
      return l10n.timeHours(hours);
    }

    int days = difference.inDays;
    if (days < 30) {
      return l10n.timeDays(days);
    } else if (days < 365) {
      final months = (days / 30).floor();
      return l10n.timeMonths(months);
    } else {
      final years = (days / 365).floor();
      return l10n.timeYears(years);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final word = card['word'] as String? ?? '';
    final meaning = card['meaning'] as String? ?? '';
    final type = card['type'] as String? ?? '';
    final ipa = card['ipa'] as String? ?? '';
    final createdAtTs = card['created_at'] as int? ?? 0;

    return GestureDetector(
      onTap: () {
        final cardId = card['card_id'] as int?;
        if (cardId != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => WordDetailScreen(cardId: cardId),
            ),
          );
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1E163B).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1.5,
              ),
            ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type and IPA row
                  Row(
                    children: [
                      if (type.isNotEmpty) ...[
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF9E5DF2).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            AppUtils.getLocalizedWordType(type, l10n).toUpperCase(),
                            style: TextStyle(
                              color: const Color(0xFF9E5DF2),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                      ],
                      if (ipa.isNotEmpty)
                        Text(
                          ipa,
                          style: TextStyle(
                            color: const Color(0xFF2FE3D6),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Word
                  Text(
                    word,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  // Meaning
                  Text(
                    meaning,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              // Interval Badge (top right)
              Positioned(
                top: 0,
                right: 0,
                child: Row(
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFB82E),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      _formatTimeAgo(context, createdAtTs),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              // Audio Play button (bottom right)
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onPlayAudio,
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.volume_up_rounded,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  }
}
