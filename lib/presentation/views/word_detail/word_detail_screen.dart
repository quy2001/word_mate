import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:word_mate/l10n/app_localizations.dart';
import 'package:word_mate/injector.dart';
import 'package:word_mate/presentation/views/word_detail/bloc/word_detail_bloc.dart';
import 'package:word_mate/presentation/views/word_detail/bloc/word_detail_event.dart';
import 'package:word_mate/presentation/views/word_detail/bloc/word_detail_state.dart';
import 'package:word_mate/presentation/widgets/register/gradient_background.dart';
import 'package:word_mate/presentation/widgets/button_widget.dart';
import 'package:animate_do/animate_do.dart';
import 'package:audioplayers/audioplayers.dart';

class WordDetailScreen extends StatelessWidget {
  final int cardId;

  const WordDetailScreen({super.key, required this.cardId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => injector<WordDetailBloc>()..add(LoadWordDetailEvent(cardId)),
      child: const _WordDetailView(),
    );
  }
}

class _WordDetailView extends StatefulWidget {
  const _WordDetailView();

  @override
  State<_WordDetailView> createState() => _WordDetailViewState();
}

class _WordDetailViewState extends State<_WordDetailView> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio(String? audioUrl) async {
    if (audioUrl == null || audioUrl.isEmpty) return;
    try {
      await _audioPlayer.play(UrlSource(audioUrl));
    } catch (e) {
      debugPrint("Audio play error: $e");
    }
  }

  void _confirmDelete(BuildContext context, int cardId) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1235),
        title: Text(l10n.confirmDelete, style: const TextStyle(color: Colors.white)),
        content: Text(l10n.deleteWordConfirm, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel, style: const TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<WordDetailBloc>().add(DeleteWordEvent(cardId));
            },
            child: Text(l10n.delete, style: const TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: GradientBackground(
        child: BlocConsumer<WordDetailBloc, WordDetailState>(
          listener: (context, state) {
            if (state.status == WordDetailStatus.deleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.wordDeleted),
                  backgroundColor: Colors.green,
                ),
              );
              context.pop();
            } else if (state.status == WordDetailStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Error'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.status == WordDetailStatus.loading || state.status == WordDetailStatus.initial) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }
            if (state.status == WordDetailStatus.failure && state.cardData == null) {
              return Center(child: Text(state.errorMessage ?? 'Error', style: const TextStyle(color: Colors.white)));
            }

            final card = state.cardData!;
            final word = card['word'] as String? ?? '';
            final meaning = card['meaning'] as String? ?? '';
            final type = card['type'] as String? ?? '';
            final ipa = card['ipa'] as String?;
            final example = card['example'] as String?;
            final audioPath = card['audio_path'] as String?;
            final streak = card['streak'] as int? ?? 0;
            final nextReviewTs = card['next_review_ts'] as int? ?? 0;
            final ef = card['easiness_factor'] as double? ?? 2.5;

            // Calculate memory level
            final memoryLevel = ((ef - 1.3) / 1.2).clamp(0.0, 1.0) * 100;
            
            // Calculate next review days
            final now = DateTime.now();
            final nextReviewDate = DateTime.fromMillisecondsSinceEpoch(nextReviewTs * 1000);
            final difference = nextReviewDate.difference(now).inDays;

            String nextReviewText;
            if (difference < 0) {
              nextReviewText = l10n.nextToday;
            } else if (difference == 0) {
              if (nextReviewDate.day != now.day) {
                nextReviewText = l10n.nextTomorrow;
              } else {
                nextReviewText = l10n.nextToday;
              }
            } else if (difference == 1) {
              nextReviewText = l10n.nextTomorrow;
            } else {
              nextReviewText = l10n.nextInDays(difference);
            }

            return SafeArea(
              child: Column(
                children: [
                  // App Bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => context.pop(),
                        ),
                        Text(
                          l10n.wordDetail,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white70, size: 20),
                            onPressed: () {
                              // Edit functionality
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Main Card
                          FadeInUp(
                            duration: const Duration(milliseconds: 400),
                            child: _buildGlassContainer(
                              child: Padding(
                                padding: EdgeInsets.all(24.w),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: _buildBadge(type.toUpperCase()),
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      word,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    if (ipa != null && ipa.isNotEmpty)
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            ipa,
                                            style: TextStyle(
                                              color: const Color(0xFF4ADE80),
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                          if (audioPath != null && audioPath.isNotEmpty) ...[
                                            SizedBox(width: 8.w),
                                            GestureDetector(
                                              onTap: () => _playAudio(audioPath),
                                              child: Container(
                                                padding: EdgeInsets.all(6.w),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white.withValues(alpha: 0.2),
                                                ),
                                                child: const Icon(
                                                  Icons.volume_up,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      meaning,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Example and Streak Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: FadeInUp(
                                  duration: const Duration(milliseconds: 500),
                                  child: _buildGlassContainer(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.w),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.format_align_left, color: Colors.white70, size: 16.sp),
                                              SizedBox(width: 6.w),
                                              Text(
                                                l10n.example,
                                                style: TextStyle(color: Colors.white70, fontSize: 12.sp, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12.h),
                                          if (example != null && example.isNotEmpty)
                                            ...example.split('\n').map((line) {
                                              return Padding(
                                                padding: EdgeInsets.only(bottom: 8.h),
                                                child: Text(
                                                  line.startsWith('"') ? line : '"$line"',
                                                  style: TextStyle(
                                                    color: Colors.white.withValues(alpha: 0.9),
                                                    fontSize: 14.sp,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              );
                                            })
                                          else
                                            Text(
                                              "No example",
                                              style: TextStyle(color: Colors.white54, fontSize: 14.sp),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: FadeInUp(
                                  duration: const Duration(milliseconds: 600),
                                  child: _buildGlassContainer(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.w),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.local_fire_department, color: Colors.white70, size: 16.sp),
                                              SizedBox(width: 6.w),
                                              Text(
                                                l10n.reviewStreak,
                                                style: TextStyle(color: Colors.white70, fontSize: 12.sp, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12.h),
                                          Row(
                                            children: [
                                              Text(
                                                streak.toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 32.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 4.w),
                                              Text(
                                                "🔥",
                                                style: TextStyle(fontSize: 24.sp),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            nextReviewText,
                                            style: TextStyle(
                                              color: const Color(0xFF4ADE80),
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),

                          // Memory Level Card
                          FadeInUp(
                            duration: const Duration(milliseconds: 700),
                            child: _buildGlassContainer(
                              child: Padding(
                                padding: EdgeInsets.all(16.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          l10n.memoryLevel,
                                          style: TextStyle(color: Colors.white70, fontSize: 12.sp, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${memoryLevel.toInt()}%",
                                          style: TextStyle(color: const Color(0xFF4ADE80), fontSize: 12.sp, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12.h),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4.r),
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 8.h,
                                            width: double.infinity,
                                            color: Colors.white.withValues(alpha: 0.1),
                                          ),
                                          Container(
                                            height: 8.h,
                                            width: MediaQuery.of(context).size.width * (memoryLevel / 100) * 0.8, // approximate width
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [Color(0xFFF97316), Color(0xFF4ADE80)],
                                              ),
                                              borderRadius: BorderRadius.circular(4.r),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),

                          // Edit & Delete Buttons
                          FadeInUp(
                            duration: const Duration(milliseconds: 800),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ButtonWidget.outline(
                                    title: l10n.edit,
                                    iconBefore: Icon(Icons.edit, color: const Color(0xFF9D63FF), size: 18.sp),
                                    color: const Color(0xFF9D63FF),
                                    onPressed: () {
                                      // TODO: Navigate to Edit screen
                                    },
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: ButtonWidget.outline(
                                    title: l10n.delete,
                                    iconBefore: Icon(Icons.delete_outline, color: const Color(0xFFF87171), size: 18.sp),
                                    color: const Color(0xFFF87171),
                                    onPressed: () => _confirmDelete(context, card['card_id'] as int),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGlassContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: child,
    );
  }

  Widget _buildBadge(String text) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1B3B3B),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFF4ADE80),
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
