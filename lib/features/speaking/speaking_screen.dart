import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';
import '../../data/models/lesson_model.dart';
import '../../data/repositories/lesson_repository.dart';

class SpeakingScreen extends StatefulWidget {
  final String lessonId;
  const SpeakingScreen({super.key, required this.lessonId});

  @override
  State<SpeakingScreen> createState() => _SpeakingScreenState();
}

class _SpeakingScreenState extends State<SpeakingScreen> with SingleTickerProviderStateMixin {
  Lesson? _lesson;
  FlutterTts _tts = FlutterTts();
  SpeechToText _stt = SpeechToText();
  bool _loading = true;
  bool _isRecording = false;
  bool _sttAvailable = false;
  String _recognizedText = '';
  int _currentIndex = 0;
  double? _score;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat(reverse: true);
    _initServices();
    _load();
  }

  Future<void> _initServices() async {
    await _tts.setLanguage('ja-JP');
    await _tts.setSpeechRate(0.7);
    _sttAvailable = await _stt.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _load() async {
    final lesson = await LessonRepository().getLessonById(widget.lessonId);
    if (mounted) setState(() { _lesson = lesson; _loading = false; });
  }

  Future<void> _playExample(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> _toggleRecording(SpeakingExercise exercise) async {
    if (_isRecording) {
      await _stt.stop();
      setState(() { _isRecording = false; });
      _computeScore(exercise.exampleText);
    } else {
      setState(() { _recognizedText = ''; _score = null; });
      if (_sttAvailable) {
        setState(() { _isRecording = true; });
        await _stt.listen(
          localeId: 'ja_JP',
          onResult: (result) {
            if (mounted) setState(() { _recognizedText = result.recognizedWords; });
          },
          cancelOnError: true,
        );
      } else {
        // Demo mode - simulate recognition
        setState(() { _isRecording = true; });
        await Future.delayed(const Duration(seconds: 2));
        setState(() { _isRecording = false; _recognizedText = exercise.exampleText; });
        _computeScore(exercise.exampleText);
      }
    }
  }

  void _computeScore(String target) {
    if (_recognizedText.isEmpty) { setState(() { _score = 0; }); return; }
    // Simple Levenshtein-inspired similarity score
    final a = _normalizeText(target);
    final b = _normalizeText(_recognizedText);
    int matches = 0;
    final minLen = a.length < b.length ? a.length : b.length;
    for (int i = 0; i < minLen; i++) {
      if (a[i] == b[i]) matches++;
    }
    final score = (matches / (a.length > 0 ? a.length : 1)).clamp(0.0, 1.0);
    setState(() { _score = score; });
  }

  String _normalizeText(String t) => t.replaceAll(' ', '').replaceAll('。', '').replaceAll('、', '').toLowerCase();

  Color get _scoreColor {
    if (_score == null) return AppTheme.textHint;
    if (_score! >= 0.8) return AppTheme.n5Color;
    if (_score! >= 0.5) return AppTheme.accentGold;
    return AppTheme.accentGold;
  }

  String get _scoreFeedback {
    if (_score == null) return '';
    if (_score! >= 0.8) return '🎉 Tuyệt vời! Phát âm rất tốt!';
    if (_score! >= 0.5) return '👍 Khá tốt! Hãy thử lại một lần nữa!';
    return '💪 Cần luyện thêm! Nghe lại mẫu rồi thử nhé!';
  }

  @override
  void dispose() {
    _tts.stop();
    _stt.stop();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_lesson == null || _lesson!.speakingExercises.isEmpty) {
      return Scaffold(appBar: AppBar(title: const Text('Luyện nói')), body: const Center(child: Text('Chưa có bài tập')));
    }
    final exercises = _lesson!.speakingExercises;
    final exercise = exercises[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Luyện nói • Bài ${_lesson!.lessonNumber}'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Progress indicator
            Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(exercises.length, (i) =>
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _currentIndex ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == _currentIndex ? AppTheme.accentGold : AppTheme.textHint.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            )),
            const SizedBox(height: 24),

            // Instruction
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppTheme.surfaceCard, borderRadius: BorderRadius.circular(14)),
              child: Text(exercise.instructionVi, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
            ),
            const SizedBox(height: 20),

            // Example card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF1A3A5C), Color(0xFF0F3460)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.accentGold.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text(exercise.exampleText, style: AppTheme.japaneseStyle(fontSize: 22, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(exercise.exampleRomaji, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14), textAlign: TextAlign.center),
                  const SizedBox(height: 6),
                  Text(exercise.exampleVi, style: const TextStyle(color: AppTheme.textHint, fontSize: 13, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _playExample(exercise.exampleText),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.accentGold.withOpacity(0.4)),
                      ),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.volume_up_rounded, color: AppTheme.accentGold, size: 18),
                        SizedBox(width: 8),
                        Text('Nghe mẫu', style: TextStyle(color: AppTheme.accentGold, fontWeight: FontWeight.w600, fontSize: 13)),
                      ]),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 32),

            // Record button
            GestureDetector(
              onTap: () => _toggleRecording(exercise),
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isRecording ? AppTheme.accentGold.withOpacity(0.9) : AppTheme.primaryLight,
                      boxShadow: _isRecording ? [
                        BoxShadow(color: AppTheme.accentGold.withOpacity(0.3 + 0.2 * _pulseController.value), blurRadius: 20 + 10 * _pulseController.value, spreadRadius: 4),
                      ] : [
                        BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 12),
                      ],
                    ),
                    child: Icon(_isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                        color: _isRecording ? AppTheme.primaryDeep : AppTheme.accentGold, size: 40),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Text(_isRecording ? 'Đang ghi âm... Nhấn để dừng' : 'Nhấn để nói',
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
            const SizedBox(height: 24),

            // Recognized text & score
            if (_recognizedText.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppTheme.surfaceCard, borderRadius: BorderRadius.circular(14)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Bạn đã nói:', style: TextStyle(color: AppTheme.textHint, fontSize: 12)),
                  const SizedBox(height: 6),
                  Text(_recognizedText, style: AppTheme.japaneseStyle(fontSize: 18)),
                ]),
              ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 16),
            ],
            if (_score != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _scoreColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _scoreColor.withOpacity(0.3)),
                ),
                child: Column(children: [
                  Text(_scoreFeedback, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary), textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(value: _score, backgroundColor: _scoreColor.withOpacity(0.1), valueColor: AlwaysStoppedAnimation(_scoreColor), minHeight: 10),
                  ),
                  const SizedBox(height: 4),
                  Text('${(_score! * 100).toInt()}%', style: TextStyle(color: _scoreColor, fontWeight: FontWeight.w700, fontSize: 18)),
                ]),
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 20),
            ],

            // Navigation
            Row(children: [
              if (_currentIndex > 0)
                Expanded(child: OutlinedButton(
                  onPressed: () => setState(() { _currentIndex--; _score = null; _recognizedText = ''; }),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.textHint), foregroundColor: AppTheme.textSecondary),
                  child: const Text('Bài trước'),
                )),
              if (_currentIndex > 0) const SizedBox(width: 12),
              if (_currentIndex < exercises.length - 1)
                Expanded(child: ElevatedButton(
                  onPressed: () => setState(() { _currentIndex++; _score = null; _recognizedText = ''; }),
                  child: const Text('Bài tiếp theo'),
                ))
              else
                Expanded(child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hoàn thành 🎉'),
                )),
            ]),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
