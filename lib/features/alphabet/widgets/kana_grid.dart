import 'package:flutter/material.dart';
import '../../../data/models/kana_model.dart';
import 'kana_card.dart';

class KanaGrid extends StatelessWidget {
  final List<KanaModel> items;

  const KanaGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 5 columns
        final crossAxisCount = 5;
        final spacing = 12.0;
        final availableWidth = constraints.maxWidth - (spacing * (crossAxisCount - 1));
        final itemWidth = availableWidth / crossAxisCount;
        
        // height slightly taller than width
        final itemHeight = itemWidth * 1.2;
        
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: items.map((kana) {
            return SizedBox(
              width: itemWidth,
              height: itemHeight,
              child: KanaCard(kana: kana),
            );
          }).toList(),
        );
      },
    );
  }
}
