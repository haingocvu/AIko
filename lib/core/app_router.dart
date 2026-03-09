import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/home_screen.dart';
import '../features/lessons/lesson_list_screen.dart';
import '../features/lessons/lesson_detail_screen.dart';
import '../features/listening/listening_screen.dart';
import '../features/speaking/speaking_screen.dart';
import '../features/vocabulary/vocabulary_screen.dart';
import '../features/progress/progress_screen.dart';
import '../shared/widgets/main_shell.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/lessons',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LessonListScreen(),
          ),
        ),
        GoRoute(
          path: '/progress',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProgressScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/lessons/:lessonId',
      builder: (context, state) => LessonDetailScreen(
        lessonId: state.pathParameters['lessonId']!,
      ),
    ),
    GoRoute(
      path: '/listening/:lessonId',
      builder: (context, state) => ListeningScreen(
        lessonId: state.pathParameters['lessonId']!,
      ),
    ),
    GoRoute(
      path: '/speaking/:lessonId',
      builder: (context, state) => SpeakingScreen(
        lessonId: state.pathParameters['lessonId']!,
      ),
    ),
    GoRoute(
      path: '/vocabulary/:lessonId',
      builder: (context, state) => VocabularyScreen(
        lessonId: state.pathParameters['lessonId']!,
      ),
    ),
  ],
);
