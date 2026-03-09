import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';
import '../../data/models/lesson_model.dart';
import '../../data/repositories/lesson_repository.dart';

class LessonListScreen extends StatefulWidget {
  const LessonListScreen({super.key});

  @override
  State<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Lesson> _n5Lessons = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLessons();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadLessons() async {
    final lessons = await LessonRepository().getLessons('N5');
    if (mounted) {
      setState(() {
        _n5Lessons = lessons;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài học'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.n5Color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('N5',
                        style: TextStyle(
                            color: AppTheme.n5Color,
                            fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 8),
                  const Text('Cơ bản'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.n4Color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('N4',
                        style: TextStyle(
                            color: AppTheme.n4Color,
                            fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 8),
                  const Text('Sơ trung cấp'),
                ],
              ),
            ),
          ],
          labelColor: AppTheme.textPrimary,
          unselectedLabelColor: AppTheme.textHint,
          indicatorColor: AppTheme.accentGold,
          dividerColor: Colors.transparent,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _buildLessonGrid(_n5Lessons, 'N5'),
          _buildComingSoon('N4'),
        ],
      ),
    );
  }

  Widget _buildLessonGrid(List<Lesson> lessons, String level) {
    if (lessons.isEmpty) {
      return const Center(child: Text('Không có bài học nào'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        return _LessonCard(lesson: lesson)
            .animate()
            .fadeIn(duration: 300.ms, delay: (index * 60).ms)
            .slideX(begin: -0.05, end: 0);
      },
    );
  }

  Widget _buildComingSoon(String level) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.n4Color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('🚀', style: TextStyle(fontSize: 48)),
          ),
          const SizedBox(height: 16),
          const Text(
            'Sắp ra mắt!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Nội dung N4 đang được chuẩn bị.\nHoàn thành N5 trước nhé!',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final Lesson lesson;
  const _LessonCard({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.levelColor(lesson.level);
    // Mock progress - lesson 1 partially complete
    final progress = lesson.lessonNumber == 1 ? 0.45 : 0.0;
    final isUnlocked = lesson.lessonNumber <= 3;

    return GestureDetector(
      onTap: isUnlocked
          ? () => context.push('/lessons/${lesson.id}')
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked
                ? color.withOpacity(0.2)
                : AppTheme.textHint.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            // Lesson number badge
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? color.withOpacity(0.15)
                    : AppTheme.textHint.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        lesson.level,
                        style: TextStyle(
                          color: isUnlocked ? color : AppTheme.textHint,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        '${lesson.lessonNumber}',
                        style: TextStyle(
                          color: isUnlocked ? color : AppTheme.textHint,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  if (!isUnlocked)
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.primaryDeep.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.lock_rounded,
                          color: AppTheme.textHint, size: 20),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: AppTheme.japaneseStyle(
                      fontSize: 17,
                      color: isUnlocked
                          ? AppTheme.textPrimary
                          : AppTheme.textHint,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lesson.titleVi,
                    style: TextStyle(
                      fontSize: 13,
                      color: isUnlocked
                          ? AppTheme.textSecondary
                          : AppTheme.textHint,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildTag('📝 ${lesson.vocabulary.length} từ', color),
                      const SizedBox(width: 6),
                      _buildTag(
                          '🔤 ${lesson.grammarPoints.length} ngữ pháp', color),
                    ],
                  ),
                  if (progress > 0) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: color.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation(color),
                        minHeight: 4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (progress >= 1.0)
              const Icon(Icons.check_circle_rounded,
                  color: AppTheme.n5Color, size: 22)
            else if (isUnlocked)
              Icon(Icons.arrow_forward_ios_rounded,
                  color: AppTheme.textHint, size: 16)
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, color: color.withOpacity(0.9)),
      ),
    );
  }
}
