// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AIko';

  @override
  String get appSubtitle => 'Japanese Assistant';

  @override
  String get alphabetTitle => 'Alphabet';

  @override
  String get alphabetSubtitle => 'Alphabet Learning Assistant';

  @override
  String get practice => 'PRACTICE';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark Mode (AIko Standard)';

  @override
  String get darkModeDesc => 'Neon colors on Cyber Navy background';

  @override
  String get language => 'Language';

  @override
  String get vietnamese => 'Vietnamese';

  @override
  String get english => 'English';

  @override
  String get hiragana => 'Hiragana';

  @override
  String get katakana => 'Katakana';

  @override
  String get writingPractice => 'Writing Practice';

  @override
  String get clear => 'Clear';

  @override
  String get basicSounds => 'Basic Sounds';

  @override
  String get dakuonSounds => 'Dakuon & Handakuon';

  @override
  String get check => 'CHECK';

  @override
  String get continueText => 'CONTINUE';

  @override
  String get correct => 'Correct!';

  @override
  String incorrect(String answer) {
    return 'Wrong. Answer: $answer';
  }

  @override
  String get listenAndChoose => 'Listen and choose correct answer';

  @override
  String get chooseCorrectReading => 'Choose correct reading';

  @override
  String get chooseCorrectKana => 'Choose correct character';

  @override
  String get mixedPractice => 'MIXED PRACTICE';

  @override
  String level(int level) {
    return 'Level $level';
  }

  @override
  String get tracingMode => 'Tracing Mode';

  @override
  String get maskMode => 'Partial Mask Mode';

  @override
  String get blindMode => 'Blind Recall Mode';

  @override
  String practiceProgress(Object count) {
    return 'Progress: $count/50';
  }
}
