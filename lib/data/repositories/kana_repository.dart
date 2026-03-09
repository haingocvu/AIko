import '../models/kana_model.dart';

class KanaRepository {
  // --- HIRAGANA ---
  
  static final List<KanaModel> _hiraganaGojuon = [
    // a i u e o
    const KanaModel(id: 'h_a', japanese: 'あ', romaji: 'a', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_i', japanese: 'い', romaji: 'i', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_u', japanese: 'う', romaji: 'u', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_e', japanese: 'え', romaji: 'e', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_o', japanese: 'お', romaji: 'o', type: KanaType.gojuon, isHiragana: true),
    
    // ka ki ku ke ko
    const KanaModel(id: 'h_ka', japanese: 'か', romaji: 'ka', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_ki', japanese: 'き', romaji: 'ki', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_ku', japanese: 'く', romaji: 'ku', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_ke', japanese: 'け', romaji: 'ke', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_ko', japanese: 'こ', romaji: 'ko', type: KanaType.gojuon, isHiragana: true),
    
    // sa shi su se so
    const KanaModel(id: 'h_sa', japanese: 'さ', romaji: 'sa', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_shi', japanese: 'し', romaji: 'shi', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_su', japanese: 'す', romaji: 'su', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_se', japanese: 'せ', romaji: 'se', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_so', japanese: 'そ', romaji: 'so', type: KanaType.gojuon, isHiragana: true),
    
    // ta chi tsu te to
    const KanaModel(id: 'h_ta', japanese: 'た', romaji: 'ta', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_chi', japanese: 'ち', romaji: 'chi', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_tsu', japanese: 'つ', romaji: 'tsu', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_te', japanese: 'て', romaji: 'te', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_to', japanese: 'と', romaji: 'to', type: KanaType.gojuon, isHiragana: true),
    
    // na ni nu ne no
    const KanaModel(id: 'h_na', japanese: 'な', romaji: 'na', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_ni', japanese: 'に', romaji: 'ni', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_nu', japanese: 'ぬ', romaji: 'nu', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_ne', japanese: 'ね', romaji: 'ne', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_no', japanese: 'の', romaji: 'no', type: KanaType.gojuon, isHiragana: true),
    
    // ha hi fu he ho
    const KanaModel(id: 'h_ha', japanese: 'は', romaji: 'ha', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_hi', japanese: 'ひ', romaji: 'hi', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_fu', japanese: 'ふ', romaji: 'fu', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_he', japanese: 'へ', romaji: 'he', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_ho', japanese: 'ほ', romaji: 'ho', type: KanaType.gojuon, isHiragana: true),
    
    // ma mi mu me mo
    const KanaModel(id: 'h_ma', japanese: 'ま', romaji: 'ma', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_mi', japanese: 'み', romaji: 'mi', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_mu', japanese: 'む', romaji: 'mu', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_me', japanese: 'め', romaji: 'me', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_mo', japanese: 'も', romaji: 'mo', type: KanaType.gojuon, isHiragana: true),
    
    // ya (empty) yu (empty) yo
    const KanaModel(id: 'h_ya', japanese: 'や', romaji: 'ya', type: KanaType.gojuon, isHiragana: true),
    KanaModel.empty(),
    const KanaModel(id: 'h_yu', japanese: 'ゆ', romaji: 'yu', type: KanaType.gojuon, isHiragana: true),
    KanaModel.empty(),
    const KanaModel(id: 'h_yo', japanese: 'よ', romaji: 'yo', type: KanaType.gojuon, isHiragana: true),
    
    // ra ri ru re ro
    const KanaModel(id: 'h_ra', japanese: 'ら', romaji: 'ra', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_ri', japanese: 'り', romaji: 'ri', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_ru', japanese: 'る', romaji: 'ru', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_re', japanese: 'れ', romaji: 're', type: KanaType.gojuon, isHiragana: true),
    const KanaModel(id: 'h_ro', japanese: 'ろ', romaji: 'ro', type: KanaType.gojuon, isHiragana: true),
    
    // wa (empty, empty, empty) wo
    const KanaModel(id: 'h_wa', japanese: 'わ', romaji: 'wa', type: KanaType.gojuon, isHiragana: true),
    KanaModel.empty(),
    KanaModel.empty(),
    KanaModel.empty(),
    const KanaModel(id: 'h_wo', japanese: 'を', romaji: 'wo', type: KanaType.gojuon, isHiragana: true),
    
    // n (empty x 4)
    const KanaModel(id: 'h_n', japanese: 'ん', romaji: 'n', type: KanaType.gojuon, isHiragana: true),
    KanaModel.empty(),
    KanaModel.empty(),
    KanaModel.empty(),
    KanaModel.empty(),
  ];

  static final List<KanaModel> _hiraganaDakuon = [
    // ga gi gu ge go
    const KanaModel(id: 'h_ga', japanese: 'が', romaji: 'ga', type: KanaType.dakuon, isHiragana: true),
    const KanaModel(id: 'h_gi', japanese: 'ぎ', romaji: 'gi', type: KanaType.dakuon, isHiragana: true),
    const KanaModel(id: 'h_gu', japanese: 'ぐ', romaji: 'gu', type: KanaType.dakuon, isHiragana: true),
    const KanaModel(id: 'h_ge', japanese: 'げ', romaji: 'ge', type: KanaType.dakuon, isHiragana: true),
    const KanaModel(id: 'h_go', japanese: 'ご', romaji: 'go', type: KanaType.dakuon, isHiragana: true),

    // za ji zu ze zo
    const KanaModel(id: 'h_za', japanese: 'ざ', romaji: 'za', type: KanaType.dakuon, isHiragana: true),
    const KanaModel(id: 'h_ji', japanese: 'じ', romaji: 'ji', type: KanaType.dakuon, isHiragana: true),
    const KanaModel(id: 'h_zu', japanese: 'ず', romaji: 'zu', type: KanaType.dakuon, isHiragana: true),
    const KanaModel(id: 'h_ze', japanese: 'ぜ', romaji: 'ze', type: KanaType.dakuon, isHiragana: true),
    const KanaModel(id: 'h_zo', japanese: 'ぞ', romaji: 'zo', type: KanaType.dakuon, isHiragana: true),

    // da ji zu de do
    const KanaModel(id: 'h_da', japanese: 'だ', romaji: 'da', type: KanaType.dakuon, isHiragana: true),
    const KanaModel(id: 'h_dji', japanese: 'ぢ', romaji: 'ji', type: KanaType.dakuon, isHiragana: true), // Often pronounced ji
    const KanaModel(id: 'h_dzu', japanese: 'づ', romaji: 'zu', type: KanaType.dakuon, isHiragana: true), // Often pronounced zu
    const KanaModel(id: 'h_de', japanese: 'で', romaji: 'de', type: KanaType.dakuon, isHiragana: true),
    const KanaModel(id: 'h_do', japanese: 'ど', romaji: 'do', type: KanaType.dakuon, isHiragana: true),

    // ba bi bu be bo
    const KanaModel(id: 'h_ba', japanese: 'ば', romaji: 'ba', type: KanaType.dakuon, isHiragana: true),
    const KanaModel(id: 'h_bi', japanese: 'び', romaji: 'bi', type: KanaType.dakuon, isHiragana: true),
    const KanaModel(id: 'h_bu', japanese: 'ぶ', romaji: 'bu', type: KanaType.dakuon, isHiragana: true),
    const KanaModel(id: 'h_be', japanese: 'べ', romaji: 'be', type: KanaType.dakuon, isHiragana: true),
    const KanaModel(id: 'h_bo', japanese: 'ぼ', romaji: 'bo', type: KanaType.dakuon, isHiragana: true),

    // pa pi pu pe po (handakuon included here for simplicity as layout is similar)
    const KanaModel(id: 'h_pa', japanese: 'ぱ', romaji: 'pa', type: KanaType.dakuon, isHiragana: true),
    const KanaModel(id: 'h_pi', japanese: 'ぴ', romaji: 'pi', type: KanaType.dakuon, isHiragana: true),
    const KanaModel(id: 'h_pu', japanese: 'ぷ', romaji: 'pu', type: KanaType.dakuon, isHiragana: true),
    const KanaModel(id: 'h_pe', japanese: 'ぺ', romaji: 'pe', type: KanaType.dakuon, isHiragana: true),
    const KanaModel(id: 'h_po', japanese: 'ぽ', romaji: 'po', type: KanaType.dakuon, isHiragana: true),
  ];
  
  // --- KATAKANA ---
  static final List<KanaModel> _katakanaGojuon = [
    // a i u e o
    const KanaModel(id: 'k_a', japanese: 'ア', romaji: 'a', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_i', japanese: 'イ', romaji: 'i', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_u', japanese: 'ウ', romaji: 'u', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_e', japanese: 'エ', romaji: 'e', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_o', japanese: 'オ', romaji: 'o', type: KanaType.gojuon, isHiragana: false),
    
    // ka ki ku ke ko
    const KanaModel(id: 'k_ka', japanese: 'カ', romaji: 'ka', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_ki', japanese: 'キ', romaji: 'ki', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_ku', japanese: 'ク', romaji: 'ku', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_ke', japanese: 'ケ', romaji: 'ke', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_ko', japanese: 'コ', romaji: 'ko', type: KanaType.gojuon, isHiragana: false),
    
    // sa shi su se so
    const KanaModel(id: 'k_sa', japanese: 'サ', romaji: 'sa', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_shi', japanese: 'シ', romaji: 'shi', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_su', japanese: 'ス', romaji: 'su', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_se', japanese: 'セ', romaji: 'se', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_so', japanese: 'ソ', romaji: 'so', type: KanaType.gojuon, isHiragana: false),
    
    // ta chi tsu te to
    const KanaModel(id: 'k_ta', japanese: 'タ', romaji: 'ta', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_chi', japanese: 'チ', romaji: 'chi', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_tsu', japanese: 'ツ', romaji: 'tsu', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_te', japanese: 'テ', romaji: 'te', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_to', japanese: 'ト', romaji: 'to', type: KanaType.gojuon, isHiragana: false),
    
    // na ni nu ne no
    const KanaModel(id: 'k_na', japanese: 'ナ', romaji: 'na', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_ni', japanese: 'ニ', romaji: 'ni', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_nu', japanese: 'ヌ', romaji: 'nu', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_ne', japanese: 'ネ', romaji: 'ne', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_no', japanese: 'ノ', romaji: 'no', type: KanaType.gojuon, isHiragana: false),
    
    // ha hi fu he ho
    const KanaModel(id: 'k_ha', japanese: 'ハ', romaji: 'ha', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_hi', japanese: 'ヒ', romaji: 'hi', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_fu', japanese: 'フ', romaji: 'fu', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_he', japanese: 'ヘ', romaji: 'he', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_ho', japanese: 'ホ', romaji: 'ho', type: KanaType.gojuon, isHiragana: false),
    
    // ma mi mu me mo
    const KanaModel(id: 'k_ma', japanese: 'マ', romaji: 'ma', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_mi', japanese: 'ミ', romaji: 'mi', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_mu', japanese: 'ム', romaji: 'mu', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_me', japanese: 'メ', romaji: 'me', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_mo', japanese: 'モ', romaji: 'mo', type: KanaType.gojuon, isHiragana: false),
    
    // ya (empty) yu (empty) yo
    const KanaModel(id: 'k_ya', japanese: 'ヤ', romaji: 'ya', type: KanaType.gojuon, isHiragana: false),
    KanaModel.empty(),
    const KanaModel(id: 'k_yu', japanese: 'ユ', romaji: 'yu', type: KanaType.gojuon, isHiragana: false),
    KanaModel.empty(),
    const KanaModel(id: 'k_yo', japanese: 'ヨ', romaji: 'yo', type: KanaType.gojuon, isHiragana: false),
    
    // ra ri ru re ro
    const KanaModel(id: 'k_ra', japanese: 'ラ', romaji: 'ra', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_ri', japanese: 'リ', romaji: 'ri', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_ru', japanese: 'ル', romaji: 'ru', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_re', japanese: 'レ', romaji: 're', type: KanaType.gojuon, isHiragana: false),
    const KanaModel(id: 'k_ro', japanese: 'ロ', romaji: 'ro', type: KanaType.gojuon, isHiragana: false),
    
    // wa (empty, empty, empty) wo
    const KanaModel(id: 'k_wa', japanese: 'ワ', romaji: 'wa', type: KanaType.gojuon, isHiragana: false),
    KanaModel.empty(),
    KanaModel.empty(),
    KanaModel.empty(),
    const KanaModel(id: 'k_wo', japanese: 'ヲ', romaji: 'wo', type: KanaType.gojuon, isHiragana: false),
    
    // n (empty x 4)
    const KanaModel(id: 'k_n', japanese: 'ン', romaji: 'n', type: KanaType.gojuon, isHiragana: false),
    KanaModel.empty(),
    KanaModel.empty(),
    KanaModel.empty(),
    KanaModel.empty(),
  ];

  static final List<KanaModel> _katakanaDakuon = [
    // ga gi gu ge go
    const KanaModel(id: 'k_ga', japanese: 'ガ', romaji: 'ga', type: KanaType.dakuon, isHiragana: false),
    const KanaModel(id: 'k_gi', japanese: 'ギ', romaji: 'gi', type: KanaType.dakuon, isHiragana: false),
    const KanaModel(id: 'k_gu', japanese: 'グ', romaji: 'gu', type: KanaType.dakuon, isHiragana: false),
    const KanaModel(id: 'k_ge', japanese: 'ゲ', romaji: 'ge', type: KanaType.dakuon, isHiragana: false),
    const KanaModel(id: 'k_go', japanese: 'ゴ', romaji: 'go', type: KanaType.dakuon, isHiragana: false),

    // za ji zu ze zo
    const KanaModel(id: 'k_za', japanese: 'ザ', romaji: 'za', type: KanaType.dakuon, isHiragana: false),
    const KanaModel(id: 'k_ji', japanese: 'ジ', romaji: 'ji', type: KanaType.dakuon, isHiragana: false),
    const KanaModel(id: 'k_zu', japanese: 'ズ', romaji: 'zu', type: KanaType.dakuon, isHiragana: false),
    const KanaModel(id: 'k_ze', japanese: 'ゼ', romaji: 'ze', type: KanaType.dakuon, isHiragana: false),
    const KanaModel(id: 'k_zo', japanese: 'ゾ', romaji: 'zo', type: KanaType.dakuon, isHiragana: false),

    // da ji zu de do
    const KanaModel(id: 'k_da', japanese: 'ダ', romaji: 'da', type: KanaType.dakuon, isHiragana: false),
    const KanaModel(id: 'k_dji', japanese: 'ヂ', romaji: 'ji', type: KanaType.dakuon, isHiragana: false), 
    const KanaModel(id: 'k_dzu', japanese: 'ヅ', romaji: 'zu', type: KanaType.dakuon, isHiragana: false), 
    const KanaModel(id: 'k_de', japanese: 'デ', romaji: 'de', type: KanaType.dakuon, isHiragana: false),
    const KanaModel(id: 'k_do', japanese: 'ド', romaji: 'do', type: KanaType.dakuon, isHiragana: false),

    // ba bi bu be bo
    const KanaModel(id: 'k_ba', japanese: 'バ', romaji: 'ba', type: KanaType.dakuon, isHiragana: false),
    const KanaModel(id: 'k_bi', japanese: 'ビ', romaji: 'bi', type: KanaType.dakuon, isHiragana: false),
    const KanaModel(id: 'k_bu', japanese: 'ブ', romaji: 'bu', type: KanaType.dakuon, isHiragana: false),
    const KanaModel(id: 'k_be', japanese: 'ベ', romaji: 'be', type: KanaType.dakuon, isHiragana: false),
    const KanaModel(id: 'k_bo', japanese: 'ボ', romaji: 'bo', type: KanaType.dakuon, isHiragana: false),

    // pa pi pu pe po 
    const KanaModel(id: 'k_pa', japanese: 'パ', romaji: 'pa', type: KanaType.dakuon, isHiragana: false),
    const KanaModel(id: 'k_pi', japanese: 'ピ', romaji: 'pi', type: KanaType.dakuon, isHiragana: false),
    const KanaModel(id: 'k_pu', japanese: 'プ', romaji: 'pu', type: KanaType.dakuon, isHiragana: false),
    const KanaModel(id: 'k_pe', japanese: 'ペ', romaji: 'pe', type: KanaType.dakuon, isHiragana: false),
    const KanaModel(id: 'k_po', japanese: 'ポ', romaji: 'po', type: KanaType.dakuon, isHiragana: false),
  ];

  static List<KanaModel> getHiraganaGojuon() => _hiraganaGojuon;
  static List<KanaModel> getHiraganaDakuon() => _hiraganaDakuon;
  static List<KanaModel> getKatakanaGojuon() => _katakanaGojuon;
  static List<KanaModel> getKatakanaDakuon() => _katakanaDakuon;

  static List<KanaModel> getAllKana() {
    return [
      ..._hiraganaGojuon.where((k) => !k.isEmpty),
      ..._hiraganaDakuon.where((k) => !k.isEmpty),
      ..._katakanaGojuon.where((k) => !k.isEmpty),
      ..._katakanaDakuon.where((k) => !k.isEmpty),
    ];
  }
}
