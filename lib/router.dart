import 'package:go_router/go_router.dart';
import 'package:word_mate/presentation/views/daily_goal/daily_goal_screen.dart';
import 'package:word_mate/presentation/views/home/home_screen.dart';
import 'package:word_mate/presentation/views/register/register_screen.dart';
import 'package:word_mate/presentation/views/topics/topic_words_screen.dart';

class AppRouter {
  static late final GoRouter router;

  static void setupRouter({required bool isRegistered}) {
    router = GoRouter(
      initialLocation: isRegistered ? '/home' : '/',
      routes: [
        GoRoute(
        path: '/',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: '/daily-goal',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const DailyGoalScreen(),
        ),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: '/topic-words',
        pageBuilder: (context, state) {
          final params = state.extra as Map<String, dynamic>? ?? {};
          return NoTransitionPage(
            key: state.pageKey,
            child: TopicWordsScreen(
              initialTopicId: params['topicId'] as int?,
              initialTopicName: params['topicName'] as String?,
            ),
          );
        },
      ),
    ],
  );
  }
}
