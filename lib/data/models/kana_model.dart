enum KanaType { gojuon, dakuon, yoon }

class KanaModel {
  final String id;
  final String japanese;
  final String romaji;
  final KanaType type;
  final bool isHiragana;
  final bool isEmpty;

  const KanaModel({
    required this.id,
    required this.japanese,
    required this.romaji,
    required this.type,
    required this.isHiragana,
    this.isEmpty = false,
  });

  factory KanaModel.empty() {
    return const KanaModel(
      id: 'empty',
      japanese: '',
      romaji: '',
      type: KanaType.gojuon,
      isHiragana: true,
      isEmpty: true,
    );
  }
}
