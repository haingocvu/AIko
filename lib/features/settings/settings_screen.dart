import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';
import '../../core/providers/settings_provider.dart';

import '../../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
              _buildHeader(context, isDark, l10n),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    _buildSectionTitle(l10n.appearance, isDark),
                    const SizedBox(height: 16),
                    _buildSettingCard(
                      title: l10n.darkMode,
                      subtitle: l10n.darkModeDesc,
                      trailing: Switch(
                        value: isDark,
                        onChanged: (_) => settings.toggleTheme(),
                        activeColor: AppTheme.accentCyan,
                      ),
                      isDark: isDark,
                    ),
                    const SizedBox(height: 32),
                    _buildSectionTitle(l10n.language, isDark),
                    const SizedBox(height: 16),
                    _buildLanguageCard(settings, isDark, l10n),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, AppLocalizations l10n) {
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 24, 10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 8),
          Text(
            l10n.settings,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    final textColor = isDark ? AppTheme.accentCyan : AppTheme.accentBlue;
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: textColor,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required Widget trailing,
    required bool isDark,
  }) {
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;
    final subColor = isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: subColor,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0);
  }

  Widget _buildLanguageCard(SettingsProvider settings, bool isDark, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _buildLanguageOption(
            title: l10n.vietnamese,
            isSelected: settings.locale.languageCode == 'vi',
            onTap: () => settings.setLocale(const Locale('vi')),
            isDark: isDark,
            isFirst: true,
          ),
          Divider(height: 1, color: (isDark ? Colors.white : Colors.black).withOpacity(0.1)),
          _buildLanguageOption(
            title: l10n.english,
            isSelected: settings.locale.languageCode == 'en',
            onTap: () => settings.setLocale(const Locale('en')),
            isDark: isDark,
            isLast: true,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideX(begin: 0.1, end: 0);
  }

  Widget _buildLanguageOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(20) : Radius.zero,
        bottom: isLast ? const Radius.circular(20) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: textColor,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: isDark ? AppTheme.accentCyan : AppTheme.accentBlue,
              ),
          ],
        ),
      ),
    );
  }
}
