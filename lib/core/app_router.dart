import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/alphabet/alphabet_screen.dart';
import '../features/alphabet/kana_learning_screen.dart';

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
  ],
);
