// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'AIko';

  @override
  String get appSubtitle => 'Trợ lý học tiếng Nhật';

  @override
  String get alphabetTitle => 'Bảng chữ cái';

  @override
  String get alphabetSubtitle => 'Trợ lý học bảng chữ cái';

  @override
  String get practice => 'LUYỆN TẬP';

  @override
  String get settings => 'Cài đặt';

  @override
  String get appearance => 'Giao diện';

  @override
  String get darkMode => 'Chế độ tối (AIko Standard)';

  @override
  String get darkModeDesc => 'Sử dụng màu sắc neon trên nền tối Cyber Navy';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'English';

  @override
  String get hiragana => 'Hiragana';

  @override
  String get katakana => 'Katakana';

  @override
  String get writingPractice => 'Luyện viết';

  @override
  String get clear => 'Xóa';

  @override
  String get basicSounds => 'Âm cơ bản';

  @override
  String get dakuonSounds => 'Âm đục & Bán đục';

  @override
  String get check => 'KIỂM TRA';

  @override
  String get continueText => 'TIẾP TỤC';

  @override
  String get correct => 'Chính xác!';

  @override
  String incorrect(String answer) {
    return 'Sai rồi. Đáp án: $answer';
  }

  @override
  String get listenAndChoose => 'Nghe và chọn đáp án đúng';

  @override
  String get chooseCorrectReading => 'Chọn cách đọc đúng';

  @override
  String get chooseCorrectKana => 'Chọn chữ cái đúng';
}
