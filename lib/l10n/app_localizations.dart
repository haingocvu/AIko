import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In vi, this message translates to:
  /// **'AIko'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Trợ lý học tiếng Nhật'**
  String get appSubtitle;

  /// No description provided for @alphabetTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bảng chữ cái'**
  String get alphabetTitle;

  /// No description provided for @alphabetSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Trợ lý học bảng chữ cái'**
  String get alphabetSubtitle;

  /// No description provided for @practice.
  ///
  /// In vi, this message translates to:
  /// **'LUYỆN TẬP'**
  String get practice;

  /// No description provided for @settings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ tối (AIko Standard)'**
  String get darkMode;

  /// No description provided for @darkModeDesc.
  ///
  /// In vi, this message translates to:
  /// **'Sử dụng màu sắc neon trên nền tối Cyber Navy'**
  String get darkModeDesc;

  /// No description provided for @language.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get language;

  /// No description provided for @vietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @english.
  ///
  /// In vi, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hiragana.
  ///
  /// In vi, this message translates to:
  /// **'Hiragana'**
  String get hiragana;

  /// No description provided for @katakana.
  ///
  /// In vi, this message translates to:
  /// **'Katakana'**
  String get katakana;

  /// No description provided for @basicSounds.
  ///
  /// In vi, this message translates to:
  /// **'Âm cơ bản'**
  String get basicSounds;

  /// No description provided for @dakuonSounds.
  ///
  /// In vi, this message translates to:
  /// **'Âm đục & Bán đục'**
  String get dakuonSounds;

  /// No description provided for @check.
  ///
  /// In vi, this message translates to:
  /// **'KIỂM TRA'**
  String get check;

  /// No description provided for @continueText.
  ///
  /// In vi, this message translates to:
  /// **'TIẾP TỤC'**
  String get continueText;

  /// No description provided for @correct.
  ///
  /// In vi, this message translates to:
  /// **'Chính xác!'**
  String get correct;

  /// No description provided for @incorrect.
  ///
  /// In vi, this message translates to:
  /// **'Sai rồi. Đáp án: {answer}'**
  String incorrect(String answer);

  /// No description provided for @listenAndChoose.
  ///
  /// In vi, this message translates to:
  /// **'Nghe và chọn đáp án đúng'**
  String get listenAndChoose;

  /// No description provided for @chooseCorrectReading.
  ///
  /// In vi, this message translates to:
  /// **'Chọn cách đọc đúng'**
  String get chooseCorrectReading;

  /// No description provided for @chooseCorrectKana.
  ///
  /// In vi, this message translates to:
  /// **'Chọn chữ cái đúng'**
  String get chooseCorrectKana;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
