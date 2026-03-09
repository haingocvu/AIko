import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';
import '../../data/models/lesson_model.dart';
import '../../data/repositories/lesson_repository.dart';

class ListeningScreen extends StatefulWidget {
  final String lessonId;
  const ListeningScreen({super.key, required this.lessonId});

  @override
  State<ListeningScreen> createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  Lesson? _lesson;
  FlutterTts? _tts;
  bool _loading = true;
  bool _isPlaying = false;
  bool _showTranscript = true;
  int _currentLineIndex = -1;
  int _currentExerciseIndex = 0;
  int? _selectedAnswer;
  bool _answerSubmitted = false;
  int _currentQuestionIndex = 0;
  bool _quizMode = false;

  @override
  void initState() {
    super.initState();
    _initTts();
    _load();
  }

  Future<void> _initTts() async {
    _tts = FlutterTts();
    await _tts?.setLanguage('ja-JP');
    await _tts?.setSpeechRate(0.7);
    await _tts?.setPitch(1.0);
    _tts?.setCompletionHandler(() {
      if (mounted) setState(() { _isPlaying = false; _currentLineIndex = -1; });
    });
  }

  Future<void> _load() async {
    final lesson = await LessonRepository().getLessonById(widget.lessonId);
    if (mounted) setState(() { _lesson = lesson; _loading = false; });
  }

  Future<void> _playDialogue() async {
    if (_lesson == null || _isPlaying) { await _tts?.stop(); setState(() { _isPlaying = false; _currentLineIndex = -1; }); return; }
    final exercise = _lesson!.listeningExercises[_currentExerciseIndex];
    setState(() { _isPlaying = true; });
    for (int i = 0; i < exercise.transcript.length; i++) {
      if (!mounted || !_isPlaying) break;
      setState(() { _currentLineIndex = i; });
      await _tts?.speak(exercise.transcript[i].text);
      await Future.delayed(const Duration(milliseconds: 800));
    }
    if (mounted) setState(() { _isPlaying = false; _currentLineIndex = -1; });
  }

  Future<void> _speakLine(String text) async {
    await _tts?.stop();
    await _tts?.speak(text);
  }

  @override
  void dispose() {
    _tts?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_lesson == null || _lesson!.listeningExercises.isEmpty) {
      return Scaffold(appBar: AppBar(title: const Text('Luyện nghe')), body: const Center(child: Text('Không có bài tập')));
    }
    final exercise = _lesson!.listeningExercises[_currentExerciseIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('Luyện nghe • Bài ${_lesson!.lessonNumber}'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => Navigator.pop(context)),
        actions: [
          TextButton.icon(
            onPressed: () => setState(() { _quizMode = !_quizMode; _answerSubmitted = false; _selectedAnswer = null; }),
            icon: Icon(_quizMode ? Icons.headphones_rounded : Icons.quiz_rounded, color: AppTheme.accentGold, size: 18),
            label: Text(_quizMode ? 'Nghe' : 'Quiz', style: const TextStyle(color: AppTheme.accentGold)),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildPlayerCard(exercise),
          if (!_quizMode) Expanded(child: _buildTranscript(exercise))
          else Expanded(child: _buildQuiz(exercise)),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(ListeningExercise exercise) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryLight, Color(0xFF1A3A60)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accentBlue.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(children: [
            const Icon(Icons.headphones_rounded, color: AppTheme.accentBlue, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(exercise.title, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600))),
          ]),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _playDialogue,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    color: _isPlaying ? AppTheme.accentGold : AppTheme.accentBlue,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: (_isPlaying ? AppTheme.accentGold : AppTheme.accentBlue).withOpacity(0.4), blurRadius: 20, spreadRadius: 2)],
                  ),
                  child: Icon(_isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded, color: AppTheme.primaryDeep, size: 32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSpeedBtn('0.5x', 0.5),
              const SizedBox(width: 0),
              _buildSpeedBtn('1x', 1.0),
              const SizedBox(width: 0),
              _buildSpeedBtn('1.5x', 1.5),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => setState(() { _showTranscript = !_showTranscript; }),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(_showTranscript ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                  color: AppTheme.textHint, size: 16),
              const SizedBox(width: 6),
              Text(_showTranscript ? 'Ẩn transcript (Shadowing)' : 'Hiện transcript',
                  style: const TextStyle(color: AppTheme.textHint, fontSize: 13)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedBtn(String label, double speed) {
    return TextButton(
      onPressed: () async { await _tts?.setSpeechRate(speed * 0.7); },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        backgroundColor: AppTheme.primaryDeep.withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, style: const TextStyle(color: AppTheme.accentBlue, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildTranscript(ListeningExercise exercise) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: exercise.transcript.length,
      itemBuilder: (context, i) {
        final line = exercise.transcript[i];
        final isActive = i == _currentLineIndex;
        final isHidden = !_showTranscript;
        return GestureDetector(
          onTap: () => _speakLine(line.text),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isActive ? AppTheme.accentBlue.withOpacity(0.15) : AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isActive ? AppTheme.accentBlue.withOpacity(0.5) : Colors.transparent),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(5)),
                    child: Text(line.speaker, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                  ),
                  const Spacer(),
                  Icon(Icons.volume_up_rounded, size: 14, color: isActive ? AppTheme.accentBlue : AppTheme.textHint),
                ]),
                const SizedBox(height: 8),
                isHidden
                    ? Container(height: 20, decoration: BoxDecoration(color: AppTheme.textHint.withOpacity(0.3), borderRadius: BorderRadius.circular(4)))
                    : Text(line.text, style: AppTheme.japaneseStyle(fontSize: 16, color: isActive ? AppTheme.textPrimary : AppTheme.textSecondary)),
              ],
            ),
          ).animate(target: isActive ? 1 : 0).shimmer(duration: 1000.ms, color: AppTheme.accentBlue.withOpacity(0.1)),
        );
      },
    );
  }

  Widget _buildQuiz(ListeningExercise exercise) {
    if (exercise.questions.isEmpty) return const Center(child: Text('Chưa có câu hỏi'));
    final q = exercise.questions[_currentQuestionIndex];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Câu ${_currentQuestionIndex + 1}/${exercise.questions.length}',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppTheme.surfaceCard, borderRadius: BorderRadius.circular(14)),
            child: Text(q.questionVi, style: Theme.of(context).textTheme.headlineMedium),
          ),
          const SizedBox(height: 16),
          ...List.generate(q.optionsVi.length, (i) {
            Color optionColor = AppTheme.surfaceCard;
            if (_answerSubmitted) {
              if (i == q.correctIndex) optionColor = AppTheme.n5Color.withOpacity(0.2);
              else if (i == _selectedAnswer) optionColor = AppTheme.accentGold.withOpacity(0.1);
            } else if (i == _selectedAnswer) {
              optionColor = AppTheme.accentBlue.withOpacity(0.15);
            }
            return GestureDetector(
              onTap: _answerSubmitted ? null : () => setState(() { _selectedAnswer = i; }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: optionColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _selectedAnswer == i ? AppTheme.accentBlue : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(children: [
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _selectedAnswer == i ? AppTheme.accentBlue.withOpacity(0.3) : AppTheme.primaryLight,
                    ),
                    child: Center(child: Text(String.fromCharCode(65 + i), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _selectedAnswer == i ? AppTheme.accentBlue : AppTheme.textSecondary))),
                  ),
                  const SizedBox(width: 12),
                  Text(q.optionsVi[i], style: const TextStyle(fontSize: 15, color: AppTheme.textPrimary)),
                  if (_answerSubmitted && i == q.correctIndex) ...[
                    const Spacer(),
                    const Icon(Icons.check_circle_rounded, color: AppTheme.n5Color, size: 20),
                  ],
                ]),
              ),
            );
          }),
          const Spacer(),
          if (!_answerSubmitted)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedAnswer == null ? null : () => setState(() { _answerSubmitted = true; }),
                child: const Text('Kiểm tra'),
              ),
            )
          else if (_currentQuestionIndex < exercise.questions.length - 1)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => setState(() { _currentQuestionIndex++; _answerSubmitted = false; _selectedAnswer = null; }),
                child: const Text('Câu tiếp theo'),
              ),
            )
          else
            Column(children: [
              Text(_selectedAnswer == q.correctIndex ? '🎉 Hoàn thành bài quiz!' : '📚 Ôn lại nhé!',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => setState(() { _quizMode = false; _currentQuestionIndex = 0; _answerSubmitted = false; _selectedAnswer = null; }),
                  child: const Text('Nghe lại'),
                ),
              ),
            ]),
        ],
      ),
    );
  }
}
