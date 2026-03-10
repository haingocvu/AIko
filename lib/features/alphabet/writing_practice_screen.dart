import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';
import '../../core/providers/settings_provider.dart';
import '../../data/models/kana_model.dart';
import 'widgets/writing_canvas.dart';
import '../../l10n/app_localizations.dart';

import 'dart:math';
import '../../core/services/digital_ink_service.dart';
import '../../data/repositories/kana_repository.dart';
import '../../core/providers/practice_provider.dart';

class WritingPracticeScreen extends StatefulWidget {
  final KanaModel? kana;
  final bool isRandomMode;

  const WritingPracticeScreen({
    super.key, 
    this.kana,
    this.isRandomMode = false,
  });

  @override
  State<WritingPracticeScreen> createState() => _WritingPracticeScreenState();
}

class _WritingPracticeScreenState extends State<WritingPracticeScreen> {
  final GlobalKey<WritingCanvasState> _canvasKey = GlobalKey();
  final DigitalInkService _inkService = DigitalInkService();
  late KanaModel _currentKana;
  bool _isValidating = false;
  int? _aiScore; // We'll use 100 for correct, 0 for incorrect or top candidate index
  bool? _isCorrect;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.isRandomMode) {
      _loadNextRandomKana();
    } else {
      _currentKana = widget.kana!;
    }
    _initMLKit();
  }

  Future<void> _initMLKit() async {
    await _inkService.checkAndDownloadModel();
  }

  @override
  void dispose() {
    _inkService.dispose();
    super.dispose();
  }

  void _loadNextRandomKana() {
    final allKana = KanaRepository.getAllKana();
    final practice = context.read<PracticeProvider>();
    final pending = practice.getPendingKanaIds(allKana.map((k) => k.id).toList());
    
    final sourceList = pending.isNotEmpty ? pending : allKana.map((k) => k.id).toList();
    final randomId = sourceList[Random().nextInt(sourceList.length)];
    
    setState(() {
      _currentKana = allKana.firstWhere((k) => k.id == randomId);
      _canvasKey.currentState?.clear();
      _aiScore = null;
      _isCorrect = null;
      _errorMessage = null;
    });
  }

  Future<void> _handleVerify() async {
    final strokes = _canvasKey.currentState?.getStrokes();
    if (strokes == null || strokes.isEmpty) return;

    setState(() {
      _isValidating = true;
      _errorMessage = null;
    });

    if (!_inkService.isSupported) {
      // Simulation for development on macOS/Web
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _isCorrect = true;
        _aiScore = 100;
        _isValidating = false;
      });
      if (mounted) {
        await context.read<PracticeProvider>().incrementCount(_currentKana.id, 100);
      }
      return;
    }

    try {
      final candidates = await _inkService.recognize(strokes);
      
      if (candidates != null && candidates.isNotEmpty) {
        // Check if the target character is in the top candidates
        bool isCorrect = false;
        int score = 0;

        // We check top 3 candidates for a better user experience
        for (int i = 0; i < min(3, candidates.length); i++) {
          if (candidates[i].text == _currentKana.japanese) {
            isCorrect = true;
            // Map index to a pseudo-score: 100, 90, 80
            score = 100 - (i * 10);
            break;
          }
        }

        setState(() {
          _isCorrect = isCorrect;
          _aiScore = score;
          if (!isCorrect) {
            _errorMessage = 'Recognized as: ${candidates.first.text}';
          }
        });

        if (isCorrect && score >= 75) {
          if (mounted) {
            await context.read<PracticeProvider>().incrementCount(_currentKana.id, score);
          }
        }
      } else {
        setState(() => _errorMessage = 'Could not recognize. Try drawing clearly.');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Recognition Error: $e');
    } finally {
      setState(() => _isValidating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final practice = context.watch<PracticeProvider>();
    
    final isDark = settings.isDarkMode;
    final l10n = AppLocalizations.of(context)!;
    final accentColor = _currentKana.isHiragana ? AppTheme.accentCyan : AppTheme.accentMagenta;
    
    final currentLevel = practice.getLevel(_currentKana.id);
    final currentCount = practice.getCount(_currentKana.id);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(widget.isRandomMode ? 'Mixed Practice' : l10n.writingPractice),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.premiumGradient(isDark)),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildProgressHeader(isDark, accentColor, currentLevel, currentCount),
              if (!_inkService.isSupported) _buildPlatformWarning(accentColor),
              const SizedBox(height: 10),
              _buildTargetCharacterCard(isDark, accentColor),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: WritingCanvas(
                      key: _canvasKey,
                      referenceChar: _currentKana.japanese,
                      level: currentLevel,
                      strokeColor: isDark ? Colors.white : AppTheme.textPrimaryLight,
                    ),
                  ),
                ),
              ),
              _buildActions(l10n, accentColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressHeader(bool isDark, Color accentColor, int level, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('LEVEL $level', style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              Text('$count / 50', style: TextStyle(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.6))),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: count / 50,
              backgroundColor: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            level == 1 ? 'Tracing Mode' : level == 2 ? 'Partial Mask Mode' : 'Blind Recall Mode',
            style: TextStyle(fontSize: 12, color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetCharacterCard(bool isDark, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _currentKana.japanese,
            style: AppTheme.japaneseStyle(fontSize: 48, color: isDark ? Colors.white : AppTheme.textPrimaryLight),
          ),
          const SizedBox(width: 16),
          Text(
            _currentKana.romaji,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: accentColor),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(AppLocalizations l10n, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          if (_aiScore != null) 
            _buildScoreFeedback(accentColor)
          else if (_errorMessage != null)
            Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _canvasKey.currentState?.clear(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(l10n.clear),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: widget.isRandomMode && _aiScore != null ? 1 : 2,
                child: ElevatedButton(
                  onPressed: _isValidating ? null : _handleVerify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: _isValidating 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('VERIFY', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              if (widget.isRandomMode && _aiScore != null) ...[
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _loadNextRandomKana,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Icon(Icons.skip_next_rounded, color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreFeedback(Color accentColor) {
    String suffix = _inkService.isSupported ? '' : ' (Simulated)';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          _isCorrect == true ? Icons.check_circle_rounded : Icons.info_outline_rounded,
          color: _isCorrect == true ? Colors.green : Colors.orange,
        ),
        const SizedBox(width: 8),
        Text(
          'Score: $_aiScore%$suffix',
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold,
            color: _isCorrect == true ? Colors.green : Colors.orange,
          ),
        ),
      ],
    ).animate().fadeIn().scale();
  }

  Widget _buildPlatformWarning(Color accentColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.orange, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'ML Kit Not Supported on this platform. Verification will be simulated.',
              style: TextStyle(color: Colors.orange.shade200, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
