class VocabularyItem {
  final String id;
  final String japanese;
  final String reading;
  final String romaji;
  final String meaningVi;
  final String exampleJa;
  final String exampleVi;
  final String wordType;

  const VocabularyItem({
    required this.id,
    required this.japanese,
    required this.reading,
    required this.romaji,
    required this.meaningVi,
    required this.exampleJa,
    required this.exampleVi,
    required this.wordType,
  });

  factory VocabularyItem.fromJson(Map<String, dynamic> json) {
    return VocabularyItem(
      id: json['id'] as String,
      japanese: json['japanese'] as String,
      reading: json['reading'] as String,
      romaji: json['romaji'] as String,
      meaningVi: json['meaning_vi'] as String,
      exampleJa: json['example_ja'] as String? ?? '',
      exampleVi: json['example_vi'] as String? ?? '',
      wordType: json['word_type'] as String? ?? '',
    );
  }
}

class GrammarPoint {
  final String pattern;
  final String explanationVi;
  final List<String> examples;

  const GrammarPoint({
    required this.pattern,
    required this.explanationVi,
    required this.examples,
  });

  factory GrammarPoint.fromJson(Map<String, dynamic> json) {
    return GrammarPoint(
      pattern: json['pattern'] as String,
      explanationVi: json['explanation_vi'] as String,
      examples: List<String>.from(json['examples'] as List),
    );
  }
}

class TranscriptLine {
  final String speaker;
  final String text;

  const TranscriptLine({required this.speaker, required this.text});

  factory TranscriptLine.fromJson(Map<String, dynamic> json) {
    return TranscriptLine(
      speaker: json['speaker'] as String,
      text: json['text'] as String,
    );
  }
}

class ListeningQuestion {
  final String questionVi;
  final List<String> optionsVi;
  final int correctIndex;

  const ListeningQuestion({
    required this.questionVi,
    required this.optionsVi,
    required this.correctIndex,
  });

  factory ListeningQuestion.fromJson(Map<String, dynamic> json) {
    return ListeningQuestion(
      questionVi: json['question_vi'] as String,
      optionsVi: List<String>.from(json['options_vi'] as List),
      correctIndex: json['correct_index'] as int,
    );
  }
}

class ListeningExercise {
  final String id;
  final String title;
  final List<TranscriptLine> transcript;
  final List<ListeningQuestion> questions;

  const ListeningExercise({
    required this.id,
    required this.title,
    required this.transcript,
    required this.questions,
  });

  factory ListeningExercise.fromJson(Map<String, dynamic> json) {
    return ListeningExercise(
      id: json['id'] as String,
      title: json['title'] as String,
      transcript: (json['transcript'] as List)
          .map((e) => TranscriptLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      questions: (json['questions'] as List)
          .map((e) => ListeningQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SpeakingExercise {
  final String id;
  final String instructionVi;
  final String template;
  final String exampleText;
  final String exampleRomaji;
  final String exampleVi;

  const SpeakingExercise({
    required this.id,
    required this.instructionVi,
    required this.template,
    required this.exampleText,
    required this.exampleRomaji,
    required this.exampleVi,
  });

  factory SpeakingExercise.fromJson(Map<String, dynamic> json) {
    return SpeakingExercise(
      id: json['id'] as String,
      instructionVi: json['instruction_vi'] as String,
      template: json['template'] as String,
      exampleText: json['example_text'] as String,
      exampleRomaji: json['example_romaji'] as String,
      exampleVi: json['example_vi'] as String,
    );
  }
}

class Lesson {
  final String id;
  final int lessonNumber;
  final String level;
  final String title;
  final String titleVi;
  final String grammarFocus;
  final List<VocabularyItem> vocabulary;
  final List<GrammarPoint> grammarPoints;
  final List<ListeningExercise> listeningExercises;
  final List<SpeakingExercise> speakingExercises;

  const Lesson({
    required this.id,
    required this.lessonNumber,
    required this.level,
    required this.title,
    required this.titleVi,
    required this.grammarFocus,
    required this.vocabulary,
    required this.grammarPoints,
    required this.listeningExercises,
    required this.speakingExercises,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      lessonNumber: json['lesson_number'] as int,
      level: json['level'] as String,
      title: json['title'] as String,
      titleVi: json['title_vi'] as String,
      grammarFocus: json['grammar_focus'] as String,
      vocabulary: (json['vocabulary'] as List)
          .map((e) => VocabularyItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      grammarPoints: (json['grammar_points'] as List)
          .map((e) => GrammarPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      listeningExercises: (json['listening_exercises'] as List)
          .map((e) => ListeningExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      speakingExercises: (json['speaking_exercises'] as List)
          .map((e) => SpeakingExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
