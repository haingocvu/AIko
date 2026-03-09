import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tiến độ học')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverallStats(context)
                .animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 24),
            _buildJLPTProgress(context)
                .animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 24),
            _buildSkillBreakdown(context)
                .animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 24),
            _buildWeeklyActivity(context)
                .animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallStats(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatCard(value: '3', label: 'Bài học\nhoàn thành', icon: '📚', color: AppTheme.n5Color)),
        const SizedBox(width: 12),
        Expanded(child: _StatCard(value: '24', label: 'Từ vựng\nđã học', icon: '📝', color: AppTheme.accentBlue)),
        const SizedBox(width: 12),
        Expanded(child: _StatCard(value: '7', label: 'Ngày\nstreak', icon: '🔥', color: AppTheme.accentGold)),
      ],
    );
  }

  Widget _buildJLPTProgress(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lộ trình JLPT', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 16),
        _JLPTProgressCard(
          level: 'N5',
          description: 'Bài 1–25 • Minna no Nihongo Vol.1',
          progress: 0.12,
          completedLessons: 3,
          totalLessons: 25,
          completedWords: 24,
          totalWords: 500,
          color: AppTheme.n5Color,
          readinessScore: 12,
        ),
        const SizedBox(height: 12),
        _JLPTProgressCard(
          level: 'N4',
          description: 'Bài 26–50 • Minna no Nihongo Vol.2',
          progress: 0.0,
          completedLessons: 0,
          totalLessons: 25,
          completedWords: 0,
          totalWords: 700,
          color: AppTheme.n4Color,
          readinessScore: 0,
          locked: true,
        ),
      ],
    );
  }

  Widget _buildSkillBreakdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Kỹ năng', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppTheme.surfaceCard, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              _SkillRow(icon: '🎧', skill: 'Nghe', progress: 0.15, color: AppTheme.accentBlue),
              const SizedBox(height: 14),
              _SkillRow(icon: '🗣️', skill: 'Nói', progress: 0.10, color: AppTheme.accentGold),
              const SizedBox(height: 14),
              _SkillRow(icon: '📖', skill: 'Từ vựng', progress: 0.20, color: AppTheme.n5Color),
              const SizedBox(height: 14),
              _SkillRow(icon: '📝', skill: 'Ngữ pháp', progress: 0.12, color: const Color(0xFFAB47BC)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyActivity(BuildContext context) {
    final data = [40, 20, 65, 50, 80, 45, 70]; // minutes
    final days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    final maxVal = data.reduce((a, b) => a > b ? a : b).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hoạt động tuần này', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppTheme.surfaceCard, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (i) {
                  final h = (data[i] / maxVal * 100).clamp(10.0, 100.0);
                  final isToday = i == 6;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(children: [
                        Text('${data[i]}p', style: TextStyle(
                            fontSize: 10,
                            color: isToday ? AppTheme.accentGold : AppTheme.textHint)),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 400 + i * 80),
                          height: h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isToday
                                  ? [AppTheme.accentGold, AppTheme.accentGold.withOpacity(0.6)]
                                  : [AppTheme.accentBlue, AppTheme.accentBlue.withOpacity(0.4)],
                              begin: Alignment.topCenter, end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(days[i], style: TextStyle(
                            fontSize: 11,
                            color: isToday ? AppTheme.accentGold : AppTheme.textHint,
                            fontWeight: isToday ? FontWeight.w700 : FontWeight.w400)),
                      ]),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.timer_outlined, size: 14, color: AppTheme.textSecondary),
                  const SizedBox(width: 6),
                  const Text('Tổng: 370 phút tuần này',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value, label, icon;
  final Color color;
  const _StatCard({required this.value, required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _JLPTProgressCard extends StatelessWidget {
  final String level, description;
  final double progress;
  final int completedLessons, totalLessons, completedWords, totalWords, readinessScore;
  final Color color;
  final bool locked;

  const _JLPTProgressCard({
    required this.level, required this.description, required this.progress,
    required this.completedLessons, required this.totalLessons,
    required this.completedWords, required this.totalWords,
    required this.color, required this.readinessScore, this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(locked ? 0.1 : 0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: color.withOpacity(locked ? 0.1 : 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(level, style: TextStyle(color: locked ? AppTheme.textHint : color, fontWeight: FontWeight.w800, fontSize: 15)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(description, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          ])),
          if (locked)
            const Icon(Icons.lock_rounded, color: AppTheme.textHint, size: 18)
          else
            Text('$readinessScore%\nSẵn sàng',
                textAlign: TextAlign.center,
                style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation(locked ? AppTheme.textHint.withOpacity(0.3) : color),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 10),
        Row(children: [
          Text('$completedLessons/$totalLessons bài', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(width: 16),
          Text('$completedWords/$totalWords từ', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        ]),
      ]),
    );
  }
}

class _SkillRow extends StatelessWidget {
  final String icon, skill;
  final double progress;
  final Color color;
  const _SkillRow({required this.icon, required this.skill, required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(icon, style: const TextStyle(fontSize: 18)),
      const SizedBox(width: 12),
      SizedBox(width: 60, child: Text(skill, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w500))),
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
          ),
        ),
      ),
      const SizedBox(width: 12),
      Text('${(progress * 100).toInt()}%',
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
    ]);
  }
}
