import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: AppTheme.primaryDeep,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(context),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildStreakCard(context)
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.1, end: 0),
                const SizedBox(height: 20),
                _buildProgressSection(context)
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 100.ms)
                    .slideY(begin: 0.1, end: 0),
                const SizedBox(height: 24),
                _buildQuickActions(context)
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 200.ms)
                    .slideY(begin: 0.1, end: 0),
                const SizedBox(height: 24),
                _buildRecentLesson(context)
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 300.ms)
                    .slideY(begin: 0.1, end: 0),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryDeep, AppTheme.primaryLight],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Konnichiwa! 👋',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.accentGold,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'NihonGo!',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accentGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.accentGold.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  '日本語',
                  style: AppTheme.japaneseStyle(
                    fontSize: 18,
                    color: AppTheme.accentGold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A5F), Color(0xFF0F3460)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.accentGold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 28)),
                const SizedBox(height: 4),
                Text(
                  '7',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppTheme.accentGold,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                Text(
                  'ngày',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.accentGold.withOpacity(0.8),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Streak tuyệt vời!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'Bạn đã học 7 ngày liên tiếp. Tiếp tục nhé!',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                _buildWeekDots(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDots() {
    final days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    final completed = [true, true, true, true, true, true, true];
    return Row(
      children: List.generate(7, (i) {
        return Padding(
          padding: const EdgeInsets.only(right: 6),
          child: Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: completed[i]
                      ? AppTheme.accentGold
                      : AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: completed[i]
                    ? const Icon(Icons.check, size: 14, color: AppTheme.primaryDeep)
                    : null,
              ),
              const SizedBox(height: 4),
              Text(
                days[i],
                style: const TextStyle(
                  fontSize: 9,
                  color: AppTheme.textHint,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tiến độ JLPT', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildLevelProgress(
                context,
                level: 'N5',
                progress: 0.12,
                completedLessons: 3,
                totalLessons: 25,
                color: AppTheme.n5Color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildLevelProgress(
                context,
                level: 'N4',
                progress: 0.0,
                completedLessons: 0,
                totalLessons: 25,
                color: AppTheme.n4Color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLevelProgress(
    BuildContext context, {
    required String level,
    required double progress,
    required int completedLessons,
    required int totalLessons,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  level,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$completedLessons / $totalLessons bài',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Luyện tập nhanh', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: '🎧',
                title: 'Luyện nghe',
                subtitle: 'N5 - Bài 1',
                color: const Color(0xFF4ECDC4),
                onTap: () => context.push('/listening/n5_l1'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                icon: '🗣️',
                title: 'Luyện nói',
                subtitle: 'N5 - Bài 1',
                color: AppTheme.accentGold,
                onTap: () => context.push('/speaking/n5_l1'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                icon: '📖',
                title: 'Từ vựng',
                subtitle: 'N5 - Bài 1',
                color: AppTheme.n5Color,
                onTap: () => context.push('/vocabulary/n5_l1'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentLesson(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Tiếp tục học',
                style: Theme.of(context).textTheme.headlineLarge),
            const Spacer(),
            GestureDetector(
              onTap: () => context.go('/lessons'),
              child: Text(
                'Xem tất cả',
                style: TextStyle(
                  color: AppTheme.accentGold,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _RecentLessonCard(
          level: 'N5',
          lessonNumber: 1,
          title: 'はじめまして',
          titleVi: 'Xin chào / Tự giới thiệu',
          progress: 0.45,
          onTap: () => context.push('/lessons/n5_l1'),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentLessonCard extends StatelessWidget {
  final String level;
  final int lessonNumber;
  final String title;
  final String titleVi;
  final double progress;
  final VoidCallback onTap;

  const _RecentLessonCard({
    required this.level,
    required this.lessonNumber,
    required this.title,
    required this.titleVi,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.levelColor(level);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    level,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w800,
                        fontSize: 12),
                  ),
                  Text(
                    'L$lessonNumber',
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.japaneseStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 2),
                  Text(titleVi,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: color.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation(color),
                            minHeight: 5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.arrow_forward_ios_rounded,
                color: AppTheme.textHint, size: 16),
          ],
        ),
      ),
    );
  }
}
