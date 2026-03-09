import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';
import '../../data/models/kana_model.dart';
import '../../data/repositories/kana_repository.dart';

enum QuestionType {
  audioToRomaji,
  kanaToRomaji,
  romajiToKana,
}

class KanaQuestion {
  final KanaModel correctKana;
  final List<KanaModel> options;
  final QuestionType type;

  KanaQuestion({
    required this.correctKana,
    required this.options,
    required this.type,
  });
}

class KanaLearningScreen extends StatefulWidget {
  const KanaLearningScreen({super.key});

  @override
  State<KanaLearningScreen> createState() => _KanaLearningScreenState();
}

class _KanaLearningScreenState extends State<KanaLearningScreen> {
  final List<KanaQuestion> _questions = [];
  int _currentIndex = 0;
  KanaModel? _selectedAnswer;
  bool _hasAnswered = false;
  bool _isCorrect = false;
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
    _generateQuestions();
  }
  
  Future<void> _initTts() async {
    await _tts.setLanguage("ja-JP");
    await _tts.setSpeechRate(0.3);
  }

  void _generateQuestions() {
    final allKana = KanaRepository.getAllKana();
    final random = Random();
    
    for (int i = 0; i < 10; i++) {
      final target = allKana[random.nextInt(allKana.length)];
      final options = <KanaModel>{target};
      while (options.length < 4) {
        options.add(allKana[random.nextInt(allKana.length)]);
      }
      final type = QuestionType.values[random.nextInt(QuestionType.values.length)];
      
      final shuffledOptions = options.toList()..shuffle();
      _questions.add(KanaQuestion(
        correctKana: target,
        options: shuffledOptions,
        type: type,
      ));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_questions[_currentIndex].type == QuestionType.audioToRomaji) {
         _playAudio(_questions[_currentIndex].correctKana.japanese);
      }
    });
  }

  Future<void> _playAudio(String text) async {
    await _tts.speak(text);
  }

  void _submitAnswer() {
    if (_selectedAnswer == null) return;
    
    setState(() {
      _hasAnswered = true;
      _isCorrect = _selectedAnswer!.id == _questions[_currentIndex].correctKana.id;
    });
    
    if (!_isCorrect && _questions[_currentIndex].type != QuestionType.audioToRomaji) {
      _playAudio(_questions[_currentIndex].correctKana.japanese);
    }
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _hasAnswered = false;
        _isCorrect = false;
      });
      if (_questions[_currentIndex].type == QuestionType.audioToRomaji) {
         _playAudio(_questions[_currentIndex].correctKana.japanese);
      }
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final question = _questions[_currentIndex];
    final progress = (_currentIndex) / _questions.length;

    return Scaffold(
      backgroundColor: Colors.transparent, // Let the background container show
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation(AppTheme.accentCyan),
              minHeight: 12,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.premiumGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        _getQuestionTitle(question.type),
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: 24,
                          color: AppTheme.accentCyan,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      _buildQuestionContent(question),
                      const SizedBox(height: 56),
                      _buildOptionsGrid(question),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  String _getQuestionTitle(QuestionType type) {
    switch (type) {
      case QuestionType.audioToRomaji:
        return 'Nghe và chọn đáp án đúng';
      case QuestionType.kanaToRomaji:
        return 'Chọn cách đọc đúng';
      case QuestionType.romajiToKana:
        return 'Chọn chữ cái đúng';
    }
  }

  Widget _buildQuestionContent(KanaQuestion question) {
    switch (question.type) {
      case QuestionType.audioToRomaji:
        return Center(
          child: GestureDetector(
            onTap: () => _playAudio(question.correctKana.japanese),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.accentCyan.withOpacity(0.15),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppTheme.accentCyan.withOpacity(0.2), blurRadius: 20, spreadRadius: 2),
                ],
              ),
              child: const Icon(Icons.volume_up_rounded, size: 64, color: AppTheme.accentCyan),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(duration: 2.seconds).scale(duration: 300.ms, curve: Curves.easeOutBack),
        );
      case QuestionType.kanaToRomaji:
        return Center(
          child: Text(
            question.correctKana.japanese,
            style: AppTheme.japaneseStyle(fontSize: 80, fontWeight: FontWeight.bold, color: AppTheme.accentCyan),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
        );
      case QuestionType.romajiToKana:
        return Center(
          child: Text(
            question.correctKana.romaji,
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
        );
    }
  }

  Widget _buildOptionsGrid(KanaQuestion question) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: question.options.map((option) {
        final isSelected = _selectedAnswer?.id == option.id;
        final isCorrectOption = option.id == question.correctKana.id;
        
        Color borderColor = AppTheme.primaryLight;
        Color bgColor = AppTheme.surfaceCard;
        
        if (_hasAnswered) {
          if (isCorrectOption) {
            borderColor = Colors.green;
            bgColor = Colors.green.withOpacity(0.1);
          } else if (isSelected && !isCorrectOption) {
            borderColor = Colors.red;
            bgColor = Colors.red.withOpacity(0.1);
          }
        } else if (isSelected) {
          borderColor = AppTheme.accentCyan;
          bgColor = AppTheme.accentCyan.withOpacity(0.1);
        }

        String displayText = '';
        if (question.type == QuestionType.romajiToKana) {
          displayText = option.japanese;
        } else {
          displayText = option.romaji;
        }

        return GestureDetector(
          onTap: _hasAnswered ? null : () {
            setState(() {
              _selectedAnswer = option;
            });
            if (question.type == QuestionType.romajiToKana || question.type == QuestionType.audioToRomaji) {
               _playAudio(option.japanese);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: isSelected || (_hasAnswered && isCorrectOption) ? 3 : 2),
            ),
            child: Center(
              child: Text(
                displayText,
                style: question.type == QuestionType.romajiToKana
                    ? AppTheme.japaneseStyle(fontSize: 32, color: Colors.white)
                    : const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomBar() {
    final question = _questions[_currentIndex];
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _hasAnswered
            ? (_isCorrect ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1))
            : Colors.transparent,
        border: Border(top: BorderSide(color: AppTheme.primaryLight.withOpacity(0.3))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_hasAnswered) ...[
            Row(
              children: [
                Icon(
                  _isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: _isCorrect ? Colors.green : Colors.red,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  _isCorrect ? 'Chính xác!' : 'Sai rồi. Đáp án: ${question.type != QuestionType.romajiToKana ? question.correctKana.romaji : question.correctKana.japanese}',
                  style: TextStyle(
                    color: _isCorrect ? Colors.green : Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
          ElevatedButton(
            onPressed: (_selectedAnswer == null)
                ? null
                : (!_hasAnswered ? _submitAnswer : _nextQuestion),
            style: ElevatedButton.styleFrom(
              backgroundColor: _hasAnswered
                  ? (_isCorrect ? Colors.green : Colors.red)
                  : AppTheme.accentCyan,
              disabledBackgroundColor: Colors.white.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(
              !_hasAnswered ? 'KIỂM TRA' : 'TIẾP TỤC',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: (_selectedAnswer == null) ? AppTheme.textHint : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
