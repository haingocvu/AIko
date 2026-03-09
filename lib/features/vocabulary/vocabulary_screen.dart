import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';
import '../../data/models/lesson_model.dart';
import '../../data/repositories/lesson_repository.dart';

enum VocabMode { flashcard, quiz }
enum CardSide { front, back }

class VocabularyScreen extends StatefulWidget {
  final String lessonId;
  const VocabularyScreen({super.key, required this.lessonId});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen>
    with SingleTickerProviderStateMixin {
  Lesson? _lesson;
  bool _loading = true;
  FlutterTts _tts = FlutterTts();
  VocabMode _mode = VocabMode.flashcard;
  int _currentIndex = 0;
  CardSide _cardSide = CardSide.front;
  bool _showRomaji = true;

  // Quiz state
  int? _selectedAnswer;
  bool _answerSubmitted = false;
  int _correctCount = 0;
  bool _quizComplete = false;
  List<VocabularyItem>? _shuffledVocab;

  @override
  void initState() {
    super.initState();
    _initTts();
    _load();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('ja-JP');
    await _tts.setSpeechRate(0.7);
  }

  Future<void> _load() async {
    final lesson = await LessonRepository().getLessonById(widget.lessonId);
    if (mounted) {
      setState(() {
        _lesson = lesson;
        _loading = false;
        if (lesson != null) {
          _shuffledVocab = [...lesson.vocabulary]..shuffle();
        }
      });
    }
  }

  Future<void> _speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  void _nextCard() {
    if (_lesson == null) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % _lesson!.vocabulary.length;
      _cardSide = CardSide.front;
    });
  }

  void _prevCard() {
    if (_lesson == null) return;
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + _lesson!.vocabulary.length) % _lesson!.vocabulary.length;
      _cardSide = CardSide.front;
    });
  }

  void _flipCard() {
    setState(() {
      _cardSide = _cardSide == CardSide.front ? CardSide.back : CardSide.front;
    });
  }

  List<String> _generateOptions(VocabularyItem correct) {
    final all = _lesson!.vocabulary.where((v) => v.id != correct.id).toList()..shuffle();
    final options = all.take(3).map((v) => v.meaningVi).toList();
    options.add(correct.meaningVi);
    options.shuffle();
    return options;
  }

  void _startQuiz() {
    setState(() {
      _mode = VocabMode.quiz;
      _currentIndex = 0;
      _selectedAnswer = null;
      _answerSubmitted = false;
      _correctCount = 0;
      _quizComplete = false;
      _shuffledVocab = [..._lesson!.vocabulary]..shuffle();
    });
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_lesson == null || _lesson!.vocabulary.isEmpty) {
      return Scaffold(
          appBar: AppBar(title: const Text('Từ vựng')),
          body: const Center(child: Text('Chưa có từ vựng')));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Từ vựng • Bài ${_lesson!.lessonNumber}'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.pop(context)),
        actions: [
          TextButton(
            onPressed: () => setState(() {
              _mode = _mode == VocabMode.flashcard
                  ? VocabMode.quiz
                  : VocabMode.flashcard;
              if (_mode == VocabMode.quiz) _startQuiz();
              else { _currentIndex = 0; _cardSide = CardSide.front; }
            }),
            child: Text(
              _mode == VocabMode.flashcard ? 'Quiz' : 'Flashcard',
              style: const TextStyle(color: AppTheme.accentGold),
            ),
          ),
        ],
      ),
      body: _mode == VocabMode.flashcard ? _buildFlashcard() : _buildQuiz(),
    );
  }

  Widget _buildFlashcard() {
    final vocab = _lesson!.vocabulary;
    final item = vocab[_currentIndex];
    final isFront = _cardSide == CardSide.front;

    return Column(
      children: [
        // Counter
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${_currentIndex + 1} / ${vocab.length}',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => setState(() => _showRomaji = !_showRomaji),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(_showRomaji ? Icons.abc : Icons.abc_outlined, color: AppTheme.textHint, size: 18),
                  const SizedBox(width: 4),
                  Text(_showRomaji ? 'Ẩn Romaji' : 'Hiện Romaji',
                      style: const TextStyle(color: AppTheme.textHint, fontSize: 12)),
                ]),
              ),
            ],
          ),
        ),

        // Progress dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(vocab.length, (i) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: i == _currentIndex ? 16 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == _currentIndex ? AppTheme.n5Color : AppTheme.textHint.withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          )),
        ),
        const SizedBox(height: 24),

        // Card
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GestureDetector(
              onTap: _flipCard,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                child: Container(
                  key: ValueKey('${_currentIndex}_${_cardSide.name}'),
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isFront
                          ? [const Color(0xFF1A3A5C), AppTheme.primaryLight]
                          : [const Color(0xFF1A3C2A), const Color(0xFF0D2B1A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isFront
                          ? AppTheme.accentBlue.withOpacity(0.3)
                          : AppTheme.n5Color.withOpacity(0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isFront ? AppTheme.accentBlue : AppTheme.n5Color).withOpacity(0.15),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isFront ? '日本語' : 'Tiếng Việt',
                        style: TextStyle(
                          color: isFront ? AppTheme.accentBlue : AppTheme.n5Color,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (isFront) ...[
                        Text(item.japanese,
                            style: AppTheme.japaneseStyle(fontSize: 44, fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        if (_showRomaji) ...[
                          Text(item.reading,
                              style: AppTheme.japaneseStyle(fontSize: 22, color: AppTheme.textSecondary),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 4),
                          Text('(${item.romaji})',
                              style: const TextStyle(color: AppTheme.textHint, fontSize: 14),
                              textAlign: TextAlign.center),
                        ],
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryDeep.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(item.wordType,
                              style: const TextStyle(color: AppTheme.textHint, fontSize: 12)),
                        ),
                      ] else ...[
                        Text(item.meaningVi,
                            style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 32,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        if (item.exampleJa.isNotEmpty) ...[
                          Divider(color: AppTheme.n5Color.withOpacity(0.2)),
                          const SizedBox(height: 12),
                          const Text('Ví dụ:', style: TextStyle(color: AppTheme.textHint, fontSize: 12)),
                          const SizedBox(height: 6),
                          Text(item.exampleJa,
                              style: AppTheme.japaneseStyle(fontSize: 15, color: AppTheme.textSecondary),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 4),
                          Text(item.exampleVi,
                              style: const TextStyle(color: AppTheme.textHint, fontSize: 13, fontStyle: FontStyle.italic),
                              textAlign: TextAlign.center),
                        ],
                      ],
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () => _speak(item.japanese),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: const Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.volume_up_rounded, size: 16, color: AppTheme.textSecondary),
                            SizedBox(width: 6),
                            Text('Nghe phát âm', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),
        const Text('Nhấn vào thẻ để lật', style: TextStyle(color: AppTheme.textHint, fontSize: 12)),
        const SizedBox(height: 16),

        // Navigation buttons
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _prevCard,
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Trước'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.textHint),
                    foregroundColor: AppTheme.textSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _nextCard,
                  label: const Text('Tiếp theo'),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuiz() {
    if (_quizComplete) return _buildQuizResult();
    final vocab = _shuffledVocab!;
    final item = vocab[_currentIndex];
    final options = _generateOptions(item);
    final correctIndex = options.indexOf(item.meaningVi);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(children: [
            Text('${_currentIndex + 1} / ${vocab.length}',
                style: const TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(width: 12),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / vocab.length,
                  backgroundColor: AppTheme.n5Color.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation(AppTheme.n5Color),
                  minHeight: 6,
                ),
              ),
            ),
          ]),
        ),

        // Question card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF1A3A5C), AppTheme.primaryLight],
                  begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.accentBlue.withOpacity(0.3)),
            ),
            child: Column(children: [
              const Text('Nghĩa của từ này là gì?', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
              const SizedBox(height: 16),
              Text(item.japanese, style: AppTheme.japaneseStyle(fontSize: 42, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('(${item.romaji})', style: const TextStyle(color: AppTheme.textHint, fontSize: 14)),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _speak(item.japanese),
                child: const Icon(Icons.volume_up_rounded, color: AppTheme.accentBlue, size: 28),
              ),
            ]),
          ),
        ).animate().fadeIn(duration: 300.ms),

        const SizedBox(height: 24),

        // Options
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: List.generate(options.length, (i) {
                Color color = AppTheme.surfaceCard;
                Color borderColor = Colors.transparent;
                Widget? trailing;
                if (_answerSubmitted) {
                  if (i == correctIndex) {
                    color = AppTheme.n5Color.withOpacity(0.15);
                    borderColor = AppTheme.n5Color;
                    trailing = const Icon(Icons.check_circle_rounded, color: AppTheme.n5Color, size: 20);
                  } else if (i == _selectedAnswer) {
                    color = AppTheme.accentGold.withOpacity(0.08);
                    borderColor = AppTheme.accentGold.withOpacity(0.3);
                    trailing = const Icon(Icons.cancel_rounded, color: AppTheme.accentGold, size: 20);
                  }
                } else if (i == _selectedAnswer) {
                  color = AppTheme.accentBlue.withOpacity(0.15);
                  borderColor = AppTheme.accentBlue;
                }
                return GestureDetector(
                  onTap: _answerSubmitted ? null : () => setState(() => _selectedAnswer = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Row(children: [
                      Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _selectedAnswer == i && !_answerSubmitted
                              ? AppTheme.accentBlue.withOpacity(0.3)
                              : AppTheme.primaryLight,
                        ),
                        child: Center(child: Text(
                          String.fromCharCode(65 + i),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _selectedAnswer == i ? AppTheme.accentBlue : AppTheme.textSecondary),
                        )),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(options[i], style: const TextStyle(fontSize: 15, color: AppTheme.textPrimary))),
                      if (trailing != null) trailing,
                    ]),
                  ),
                );
              }),
            ),
          ),
        ),

        // Action button
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          child: SizedBox(
            width: double.infinity,
            child: _answerSubmitted
                ? ElevatedButton(
                    onPressed: () {
                      if (_currentIndex < _shuffledVocab!.length - 1) {
                        setState(() {
                          _currentIndex++;
                          _selectedAnswer = null;
                          _answerSubmitted = false;
                        });
                      } else {
                        setState(() => _quizComplete = true);
                      }
                    },
                    child: Text(_currentIndex < _shuffledVocab!.length - 1
                        ? 'Câu tiếp theo' : 'Xem kết quả'),
                  )
                : ElevatedButton(
                    onPressed: _selectedAnswer == null
                        ? null
                        : () {
                            if (_selectedAnswer == correctIndex) _correctCount++;
                            setState(() => _answerSubmitted = true);
                          },
                    child: const Text('Kiểm tra'),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuizResult() {
    final total = _shuffledVocab!.length;
    final score = _correctCount / total;
    final color = score >= 0.8 ? AppTheme.n5Color : score >= 0.5 ? AppTheme.accentGold : AppTheme.accentGold;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(score >= 0.8 ? '🎉' : score >= 0.5 ? '👍' : '💪',
                style: const TextStyle(fontSize: 64))
                .animate().scale(delay: 100.ms, duration: 400.ms),
            const SizedBox(height: 16),
            Text(
              score >= 0.8 ? 'Xuất sắc!' : score >= 0.5 ? 'Khá tốt!' : 'Cần ôn thêm!',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(color: color),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 16),
            Text('$_correctCount / $total câu đúng',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.textSecondary)),
            const SizedBox(height: 24),
            CircularProgressIndicator(
              value: score,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(color),
              strokeWidth: 10,
            ),
            const SizedBox(height: 8),
            Text('${(score * 100).toInt()}%',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 32),
            Row(children: [
              Expanded(child: OutlinedButton(
                onPressed: () => setState(() {
                  _mode = VocabMode.flashcard;
                  _currentIndex = 0;
                  _cardSide = CardSide.front;
                }),
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.textHint),
                    foregroundColor: AppTheme.textSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 14)),
                child: const Text('Ôn lại'),
              )),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(
                onPressed: _startQuiz,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                child: const Text('Làm lại'),
              )),
            ]),
          ],
        ),
      ),
    );
  }
}
