import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/lesson_model.dart';

class LessonRepository {
  static final LessonRepository _instance = LessonRepository._internal();
  factory LessonRepository() => _instance;
  LessonRepository._internal();

  List<Lesson>? _n5Lessons;

  Future<List<Lesson>> getLessons(String level) async {
    if (level == 'N5') {
      _n5Lessons ??= await _loadLessons('assets/data/lessons_n5.json');
      return _n5Lessons!;
    }
    return [];
  }

  Future<Lesson?> getLessonById(String id) async {
    final n5 = await getLessons('N5');
    try {
      return n5.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<Lesson>> _loadLessons(String assetPath) async {
    try {
      final String jsonStr = await rootBundle.loadString(assetPath);
      final Map<String, dynamic> data = json.decode(jsonStr);
      final List<dynamic> lessonList = data['lessons'] as List<dynamic>;
      return lessonList
          .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
