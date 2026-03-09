import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../core/providers/settings_provider.dart';
import '../../data/models/kana_model.dart';
import '../../data/repositories/kana_repository.dart';
import 'widgets/kana_grid.dart';
import '../../l10n/app_localizations.dart';

class AlphabetScreen extends StatefulWidget {
  const AlphabetScreen({super.key});

  @override
  State<AlphabetScreen> createState() => _AlphabetScreenState();
}

class _AlphabetScreenState extends State<AlphabetScreen> {
  bool _isHiragana = true;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.premiumGradient(isDark)),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(isDark, l10n),
              _buildToggle(isDark, l10n),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _buildKanaContent(
                    key: ValueKey(_isHiragana),
                    gojuon: _isHiragana ? KanaRepository.getHiraganaGojuon() : KanaRepository.getKatakanaGojuon(),
                    dakuon: _isHiragana ? KanaRepository.getHiraganaDakuon() : KanaRepository.getKatakanaDakuon(),
                    isDark: isDark,
                    l10n: l10n,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/alphabet/learn'),
        backgroundColor: isDark ? AppTheme.accentCyan : AppTheme.accentBlue,
        elevation: 8,
        icon: Icon(Icons.psychology_rounded, color: isDark ? AppTheme.primaryDeep : Colors.white, size: 28),
        label: Text(
          l10n.practice,
          style: TextStyle(
            color: isDark ? AppTheme.primaryDeep : Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
      ).animate().scale(delay: 600.ms, duration: 400.ms, curve: Curves.easeOutBack),
    );
  }

  Widget _buildHeader(bool isDark, AppLocalizations l10n) {
    final iconColor = isDark ? AppTheme.accentCyan : AppTheme.accentBlue;
    final secondaryTextColor = isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 12, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => (isDark 
                    ? AppTheme.accentGradient 
                    : LinearGradient(colors: [AppTheme.accentBlue, AppTheme.accentBlue.withOpacity(0.8)])
                  ).createShader(bounds),
                  child: Text(
                    l10n.appTitle,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.alphabetSubtitle,
                  style: TextStyle(
                    color: (isDark ? AppTheme.accentCyan : AppTheme.accentBlue).withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.settings_outlined, color: secondaryTextColor),
                onPressed: () => context.push('/settings'),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withOpacity(0.15),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(Icons.auto_awesome_rounded, color: iconColor, size: 28),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
               .scale(duration: 2.seconds, begin: const Offset(1, 1), end: const Offset(1.15, 1.15), curve: Curves.easeInOut)
               .shimmer(duration: 3.seconds, color: iconColor.withOpacity(0.5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(bool isDark, AppLocalizations l10n) {
    final bgColor = (isDark ? Colors.black : Colors.black).withOpacity(isDark ? 0.2 : 0.05);
    final borderColor = (isDark ? Colors.white : Colors.black).withOpacity(0.1);
    final indicatorColor = isDark ? AppTheme.accentCyan : AppTheme.accentBlue;
    final secondaryTextColor = isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      height: 56,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutExpo,
            alignment: _isHiragana ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.43,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: isDark ? AppTheme.accentGradient : LinearGradient(colors: [AppTheme.accentBlue, AppTheme.accentBlue.withOpacity(0.8)]),
                borderRadius: BorderRadius.circular(24),
                boxShadow: isDark ? [
                  BoxShadow(color: AppTheme.accentCyan.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                ] : null,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isHiragana = true),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      l10n.hiragana,
                      style: TextStyle(
                        color: _isHiragana ? Colors.white : secondaryTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isHiragana = false),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      l10n.katakana,
                      style: TextStyle(
                        color: !_isHiragana ? Colors.white : secondaryTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKanaContent({
    required Key key,
    required List<KanaModel> gojuon,
    required List<KanaModel> dakuon,
    required bool isDark,
    required AppLocalizations l10n,
  }) {
    return CustomScrollView(
      key: key,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildSectionTitle(l10n.basicSounds, 'Gojuon', isDark),
              const SizedBox(height: 16),
              KanaGrid(items: gojuon),
              const SizedBox(height: 48),
              _buildSectionTitle(l10n.dakuonSounds, 'Dakuon', isDark),
              const SizedBox(height: 16),
              KanaGrid(items: dakuon),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String main, String sub, bool isDark) {
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;
    final accentColor = isDark ? AppTheme.accentCyan : AppTheme.accentBlue;

    return Row(
      children: [
        Text(main, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(width: 8),
        Text('($sub)', style: TextStyle(fontSize: 14, color: accentColor.withOpacity(0.7), fontWeight: FontWeight.w500)),
        const SizedBox(width: 12),
        Expanded(child: Divider(color: (isDark ? Colors.white : Colors.black).withOpacity(0.1))),
      ],
    );
  }
}
