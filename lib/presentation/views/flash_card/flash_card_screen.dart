import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:word_mate/l10n/app_localizations.dart';
import 'package:word_mate/core/utils/audio_helper.dart';
import 'package:word_mate/injector.dart';
import 'package:word_mate/presentation/widgets/register/gradient_background.dart';
import 'bloc/flash_card_bloc.dart';
import 'bloc/flash_card_event.dart';
import 'bloc/flash_card_state.dart';
import 'widgets/flash_card_widget.dart';
import 'widgets/swipeable_card_stack.dart';

class FlashCardScreen extends StatelessWidget {
  final int? topicId;
  final bool isReviewMode;

  const FlashCardScreen({super.key, this.topicId, this.isReviewMode = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => injector<FlashCardBloc>()..add(LoadFlashCards(topicId: topicId, isReviewMode: isReviewMode)),
      child: const _FlashCardView(),
    );
  }
}

class _FlashCardView extends StatelessWidget {
  const _FlashCardView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              BlocBuilder<FlashCardBloc, FlashCardState>(
                builder: (context, state) {
                  final current = state.status == FlashCardStatus.finished ? state.cards.length : state.currentIndex + 1;
                  final total = state.cards.length;
                  
                  final learningCount = state.swipeHistory.where((b) => !b).length;
                  final masteredCount = state.swipeHistory.where((b) => b).length;

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.orangeAccent, width: 1.5),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: _AnimatedOdometer(
                            value: learningCount,
                            style: TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _AnimatedOdometer(
                              value: current,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' / $total',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF2FE3D6), width: 1.5),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: _AnimatedOdometer(
                            value: masteredCount,
                            style: TextStyle(
                              color: const Color(0xFF2FE3D6),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: BlocBuilder<FlashCardBloc, FlashCardState>(
                    builder: (context, state) {
                      if (state.status == FlashCardStatus.initial ||
                          state.status == FlashCardStatus.loading) {
                        return const Center(
                          child: CircularProgressIndicator(color: Color(0xFF9D63FF)),
                        );
                      }

                      if (state.status == FlashCardStatus.error) {
                        return Center(
                          child: Text(
                            l10n.failedToLoadCards,
                            style: TextStyle(color: Colors.white, fontSize: 16.sp),
                          ),
                        );
                      }

                      if (state.cards.isEmpty || state.status == FlashCardStatus.finished) {
                        return _buildFinishedState(context);
                      }

                      final currentCard = state.cards[state.currentIndex];
                      final nextCard = state.currentIndex + 1 < state.cards.length
                          ? FlashCardWidget(
                              cardData: state.cards[state.currentIndex + 1],
                              isFlipped: false,
                              onFlip: () {},
                              onPlayAudio: () {},
                            )
                          : null;

                      return SwipeableCardStack(
                        key: ValueKey(state.currentIndex), // Key is important to force recreate on index change
                        nextCard: nextCard,
                        onSwipeLeft: () => context.read<FlashCardBloc>().add(SwipeCardEvent(isKnown: false)),
                        onSwipeRight: () => context.read<FlashCardBloc>().add(SwipeCardEvent(isKnown: true)),
                        leftOverlay: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E163B),
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border.all(color: Colors.orangeAccent, width: 1.5),
                          ),
                          child: Center(
                            child: Transform.rotate(
                              angle: -0.2,
                              child: Text(
                                l10n.learning,
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 40.sp,
                                  fontWeight: FontWeight.w900,
                                  shadows: const [Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))],
                                ),
                              ),
                            ),
                          ),
                        ),
                        rightOverlay: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E163B),
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border.all(color: const Color(0xFF2FE3D6), width: 1.5),
                          ),
                          child: Center(
                            child: Transform.rotate(
                              angle: 0.2,
                              child: Text(
                                l10n.mastered,
                                style: TextStyle(
                                  color: const Color(0xFF2FE3D6),
                                  fontSize: 40.sp,
                                  fontWeight: FontWeight.w900,
                                  shadows: const [Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))],
                                ),
                              ),
                            ),
                          ),
                        ),
                        card: FlashCardWidget(
                          cardData: currentCard,
                          isFlipped: state.isFlipped,
                          onFlip: () => context.read<FlashCardBloc>().add(FlipCardEvent()),
                          onPlayAudio: () {
                            final audioPath = currentCard['audio_path'] as String? ?? '';
                            AudioHelper().playAudio(context, audioPath);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              _buildBottomBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Icon(Icons.close_rounded, color: Colors.white, size: 20.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => context.read<FlashCardBloc>().add(UndoSwipeEvent()),
            child: Icon(Icons.undo_rounded, color: Colors.white.withOpacity(0.5), size: 30.sp),
          ),
          GestureDetector(
            onTap: () {
              // Auto play functionality not fully specified
            },
            child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishedState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline_rounded, color: const Color(0xFF2FE3D6), size: 100.sp),
          SizedBox(height: 20.h),
          Text(
            l10n.completed,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 40.h),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9D63FF),
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
            child: Text(
              l10n.goBack,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _AnimatedOdometer extends StatelessWidget {
  final int value;
  final TextStyle style;

  const _AnimatedOdometer({required this.value, required this.style});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final isIncoming = (child.key as ValueKey<int>?)?.value == value;
        final beginOffset = isIncoming ? const Offset(0.0, 1.0) : const Offset(0.0, -1.0);
        return ClipRect(
          child: SlideTransition(
            position: Tween<Offset>(begin: beginOffset, end: Offset.zero).animate(animation),
            child: child,
          ),
        );
      },
      child: Text(
        '$value',
        key: ValueKey<int>(value),
        style: style,
      ),
    );
  }
}
