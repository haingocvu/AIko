import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/alphabet/alphabet_screen.dart';
import '../features/alphabet/kana_learning_screen.dart';
import '../features/alphabet/writing_practice_screen.dart';
import '../features/settings/settings_screen.dart';
import '../data/models/kana_model.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AlphabetScreen(),
    ),
    GoRoute(
      path: '/alphabet/learn',
      builder: (context, state) => const KanaLearningScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/alphabet/write',
      builder: (context, state) {
        final kana = state.extra as KanaModel;
        return WritingPracticeScreen(kana: kana);
      },
    ),
  ],
);
