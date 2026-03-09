import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';
import '../../data/models/lesson_model.dart';
import '../../data/repositories/lesson_repository.dart';

class LessonDetailScreen extends StatefulWidget {
  final String lessonId;
  const LessonDetailScreen({super.key, required this.lessonId});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  Lesson? _lesson;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final lesson = await LessonRepository().getLessonById(widget.lessonId);
    if (mounted) setState(() { _lesson = lesson; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_lesson == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bài học')),
        body: const Center(child: Text('Không tìm thấy bài học')),
      );
    }
    final lesson = _lesson!;
    final color = AppTheme.levelColor(lesson.level);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.primaryDeep, color.withOpacity(0.3)],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(children: [
                      _levelBadge(lesson.level, color),
                      const SizedBox(width: 8),
                      _levelBadge('Bài ${lesson.lessonNumber}', color),
                    ]),
                    const SizedBox(height: 8),
                    Text(lesson.title, style: AppTheme.japaneseStyle(fontSize: 26, fontWeight: FontWeight.w700)),
                    Text(lesson.titleVi, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildActivities(context, lesson)
                    .animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: 24),
                _buildGrammar(context, lesson)
                    .animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: 24),
                _buildVocabPreview(context, lesson)
                    .animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _levelBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }

  Widget _buildActivities(BuildContext context, Lesson lesson) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Luyện tập', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: _ActivityCard(
              icon: '🎧', label: 'Luyện nghe',
              description: '${lesson.listeningExercises.length} hội thoại',
              color: AppTheme.accentBlue,
              onTap: () => context.push('/listening/${lesson.id}'),
            )),
            const SizedBox(width: 12),
            Expanded(child: _ActivityCard(
              icon: '🗣️', label: 'Luyện nói',
              description: '${lesson.speakingExercises.length} bài nói',
              color: AppTheme.accentGold,
              onTap: () => context.push('/speaking/${lesson.id}'),
            )),
            const SizedBox(width: 12),
            Expanded(child: _ActivityCard(
              icon: '📖', label: 'Từ vựng',
              description: '${lesson.vocabulary.length} từ',
              color: AppTheme.n5Color,
              onTap: () => context.push('/vocabulary/${lesson.id}'),
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildGrammar(BuildContext context, Lesson lesson) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ngữ pháp', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 14),
        ...lesson.grammarPoints.map((g) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.accentGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(g.pattern, style: AppTheme.japaneseStyle(fontSize: 15, color: AppTheme.accentGold)),
              ),
              const SizedBox(height: 10),
              Text(g.explanationVi, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 10),
              ...g.examples.map((ex) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: AppTheme.accentGold)),
                    Expanded(child: Text(ex, style: AppTheme.japaneseStyle(fontSize: 14, color: AppTheme.textSecondary))),
                  ],
                ),
              )),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildVocabPreview(BuildContext context, Lesson lesson) {
    final preview = lesson.vocabulary.take(4).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text('Từ vựng chính', style: Theme.of(context).textTheme.headlineLarge),
          const Spacer(),
          TextButton(
            onPressed: () => context.push('/vocabulary/${lesson.id}'),
            child: const Text('Xem tất cả', style: TextStyle(color: AppTheme.accentGold)),
          ),
        ]),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2.2,
          ),
          itemCount: preview.length,
          itemBuilder: (context, i) {
            final v = preview[i];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(v.japanese, style: AppTheme.japaneseStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  Text(v.meaningVi, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String icon, label, description;
  final Color color;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.icon, required this.label, required this.description,
    required this.color, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12), textAlign: TextAlign.center),
            const SizedBox(height: 2),
            Text(description, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
