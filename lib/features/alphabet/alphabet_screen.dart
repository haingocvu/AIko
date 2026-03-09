import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';
import '../../data/models/kana_model.dart';
import '../../data/repositories/kana_repository.dart';
import 'widgets/kana_grid.dart';

class AlphabetScreen extends StatefulWidget {
  const AlphabetScreen({super.key});

  @override
  State<AlphabetScreen> createState() => _AlphabetScreenState();
}

class _AlphabetScreenState extends State<AlphabetScreen> {
  bool _isHiragana = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.premiumGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildToggle(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _buildKanaContent(
                    key: ValueKey(_isHiragana),
                    gojuon: _isHiragana ? KanaRepository.getHiraganaGojuon() : KanaRepository.getKatakanaGojuon(),
                    dakuon: _isHiragana ? KanaRepository.getHiraganaDakuon() : KanaRepository.getKatakanaDakuon(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/alphabet/learn'),
        backgroundColor: AppTheme.accentGold,
        elevation: 8,
        icon: const Icon(Icons.psychology_rounded, color: Colors.white, size: 28),
        label: const Text(
          'LUYỆN TẬP',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
      ).animate().scale(delay: 600.ms, duration: 400.ms, curve: Curves.easeOutBack),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => AppTheme.accentGradient.createShader(bounds),
                  child: Text(
                    'AIko',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Trợ lý học bảng chữ cái',
                  style: TextStyle(
                    color: AppTheme.accentCyan.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentCyan.withOpacity(0.1),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentCyan.withOpacity(0.15),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: AppTheme.accentCyan, size: 28),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .scale(duration: 2.seconds, begin: const Offset(1, 1), end: const Offset(1.15, 1.15), curve: Curves.easeInOut)
           .shimmer(duration: 3.seconds, color: AppTheme.accentCyan.withOpacity(0.5)),
        ],
      ),
    );
  }

  Widget _buildToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      height: 56,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
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
                gradient: AppTheme.accentGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: AppTheme.accentGold.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4)),
                ],
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
                      'Hiragana',
                      style: TextStyle(
                        color: _isHiragana ? Colors.white : AppTheme.textSecondary,
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
                      'Katakana',
                      style: TextStyle(
                        color: !_isHiragana ? Colors.white : AppTheme.textSecondary,
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
  }) {
    return CustomScrollView(
      key: key,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildSectionTitle('Âm cơ bản', 'Gojuon'),
              const SizedBox(height: 16),
              KanaGrid(items: gojuon),
              const SizedBox(height: 48),
              _buildSectionTitle('Âm đục & Bán đục', 'Dakuon'),
              const SizedBox(height: 16),
              KanaGrid(items: dakuon),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String main, String sub) {
    return Row(
      children: [
        Text(main, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(width: 8),
        Text('($sub)', style: const TextStyle(fontSize: 14, color: AppTheme.accentCyan, fontWeight: FontWeight.w500)),
        const SizedBox(width: 12),
        Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
      ],
    );
  }
}
