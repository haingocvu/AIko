import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/app_theme.dart';
import '../../../core/providers/settings_provider.dart';
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
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;

    if (kana.isEmpty) {
      return const SizedBox.shrink();
    }

    final accentColor = kana.isHiragana ? AppTheme.accentCyan : AppTheme.accentMagenta;
    final cardBg = (isDark ? Colors.white : Colors.black).withOpacity(0.08);
    final borderColor = (isDark ? Colors.white : Colors.black).withOpacity(0.12);
    final textColor = isDark ? Colors.white : AppTheme.textPrimaryLight;
    final subTextColor = isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight;

    return GestureDetector(
      onTap: _speak,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: isDark ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ] : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor.withOpacity(0.1),
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
                          color: textColor,
                        ).copyWith(
                          shadows: isDark ? [
                            Shadow(
                              color: accentColor.withOpacity(0.5),
                              blurRadius: 10,
                            ),
                          ] : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        kana.romaji,
                        style: TextStyle(
                          fontSize: 13,
                          color: subTextColor.withOpacity(0.8),
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
     .shimmer(duration: 4.seconds, color: accentColor.withOpacity(0.1))
     .animate(target: 1)
     .scale(duration: 200.ms, curve: Curves.easeOut);
  }
}
