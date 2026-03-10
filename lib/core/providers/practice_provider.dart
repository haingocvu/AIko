import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PracticeProvider with ChangeNotifier {
  static const String _levelPrefix = 'level_';
  static const String _countPrefix = 'count_';
  static const int _threshold = 50;

  final SharedPreferences _prefs;

  PracticeProvider(this._prefs);

  int getLevel(String kanaId) {
    return _prefs.getInt('$_levelPrefix$kanaId') ?? 1;
  }

  int getCount(String kanaId) {
    return _prefs.getInt('$_countPrefix$kanaId') ?? 0;
  }

  Future<void> incrementCount(String kanaId, int score) async {
    // Only count if AI score is high enough (e.g., > 75%)
    if (score < 75) return;

    final currentCount = getCount(kanaId);
    final newCount = currentCount + 1;
    await _prefs.setInt('$_countPrefix$kanaId', newCount);

    final currentLevel = getLevel(kanaId);
    if (newCount >= _threshold && currentLevel < 3) {
      await _prefs.setInt('$_levelPrefix$kanaId', currentLevel + 1);
      await _prefs.setInt('$_countPrefix$kanaId', 0); // Reset count for next level
    }
    
    notifyListeners();
  }

  // Helper for Random Practice: Find kana that aren't at Level 3 yet
  List<String> getPendingKanaIds(List<String> allIds) {
    return allIds.where((id) => getLevel(id) < 3).toList();
  }
}
