import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/app_theme.dart';
import '../../../data/models/kana_model.dart';

class KanaCard extends StatelessWidget {
  final KanaModel kana;

  const KanaCard({super.key, required this.kana});

  Future<void> _speak() async {
    if (kana.isEmpty) return;
    final tts = FlutterTts();
    await tts.setLanguage("ja-JP");
    await tts.setSpeechRate(0.3);
    await tts.speak(kana.japanese);
  }

  @override
  Widget build(BuildContext context) {
    if (kana.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: _speak,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Subtle background glow
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (kana.isHiragana ? AppTheme.accentCyan : AppTheme.accentMagenta).withOpacity(0.15),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        kana.japanese,
                        style: AppTheme.japaneseStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ).copyWith(
                          shadows: [
                            Shadow(
                              color: (kana.isHiragana ? AppTheme.accentCyan : AppTheme.accentMagenta).withOpacity(0.5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        kana.romaji,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary.withOpacity(0.8),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
     .shimmer(duration: 4.seconds, color: (kana.isHiragana ? AppTheme.accentCyan : AppTheme.accentMagenta).withOpacity(0.1))
     .animate(target: 1)
     .scale(duration: 200.ms, curve: Curves.easeOut);
  }
}
