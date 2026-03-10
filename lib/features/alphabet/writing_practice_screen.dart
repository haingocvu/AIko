import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';
import '../../core/config.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/services/gemini_service.dart';
import '../../data/models/kana_model.dart';
import 'widgets/writing_canvas.dart';
import '../../l10n/app_localizations.dart';

class WritingPracticeScreen extends StatefulWidget {
  final KanaModel kana;

  const WritingPracticeScreen({super.key, required this.kana});

  @override
  State<WritingPracticeScreen> createState() => _WritingPracticeScreenState();
}

class _WritingPracticeScreenState extends State<WritingPracticeScreen> {
  final GlobalKey<WritingCanvasState> _canvasKey = GlobalKey();
  bool _isValidating = false;
  int? _aiScore;
  bool? _isCorrect;
  String? _errorMessage;

  // Key is now loaded from a file ignored by git
  static const String _tempApiKey = AppConfig.geminiApiKey; 

  Future<void> _handleVerify() async {
    final bytes = await _canvasKey.currentState?.captureImage();
    if (bytes == null) return;

    setState(() {
      _isValidating = true;
      _errorMessage = null;
    });

    try {
      final gemini = GeminiService(_tempApiKey);
      final responseText = await gemini.validateHandwriting(bytes, widget.kana.japanese);
      
      if (responseText != null) {
        if (responseText.startsWith('ERROR:')) {
          setState(() => _errorMessage = responseText);
        } else {
          // Clean the response text from Gemini (sometimes it wraps JSON in markdown)
          final cleanJson = responseText.replaceAll('```json', '').replaceAll('```', '').trim();
          final data = jsonDecode(cleanJson);
          
          setState(() {
            _isCorrect = data['isCorrect'] ?? false;
            _aiScore = data['score'] ?? 0;
          });
        }
      } else {
        setState(() => _errorMessage = 'Could not validate. Please try again.');
      }
    } catch (e) {
      setState(() => _errorMessage = 'AI Error: Check your API Key or connection.');
    } finally {
      setState(() => _isValidating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;
    final l10n = AppLocalizations.of(context)!;
    final accentColor = widget.kana.isHiragana ? AppTheme.accentCyan : AppTheme.accentMagenta;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.writingPractice),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.premiumGradient(isDark)),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildTargetCharacterCard(isDark, accentColor),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.white : Colors.black).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: (isDark ? Colors.white : Colors.black).withOpacity(0.1)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: WritingCanvas(
                      key: _canvasKey,
                      referenceChar: widget.kana.japanese,
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

  Widget _buildTargetCharacterCard(bool isDark, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.kana.japanese,
            style: AppTheme.japaneseStyle(fontSize: 48, color: isDark ? Colors.white : AppTheme.textPrimaryLight),
          ),
          const SizedBox(width: 16),
          Text(
            widget.kana.romaji,
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
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isValidating ? null : _handleVerify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: _isValidating 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('VERIFY WITH AI', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreFeedback(Color accentColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          _isCorrect == true ? Icons.check_circle_rounded : Icons.info_outline_rounded,
          color: _isCorrect == true ? Colors.green : Colors.orange,
        ),
        const SizedBox(width: 8),
        Text(
          'AI Score: $_aiScore%',
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold,
            color: _isCorrect == true ? Colors.green : Colors.orange,
          ),
        ),
      ],
    ).animate().fadeIn().scale();
  }
}
