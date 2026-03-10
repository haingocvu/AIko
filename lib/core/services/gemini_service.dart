import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';

class GeminiService {
  final String _apiKey;
  late final GenerativeModel _model;

  GeminiService(this._apiKey) {
    _model = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: _apiKey,
    );
  }

  Future<String?> validateHandwriting(Uint8List imageBytes, String targetChar) async {
    try {
      final prompt = [
        Content.multi([
          DataPart('image/png', imageBytes),
          TextPart(
            'Act as a strict Japanese calligraphy teacher. Analyze this handwritten character. '
            'The target character is "$targetChar". '
            'Evaluate based on: 1. Correctness of the shape, 2. Proportions and balance, 3. Stroke quality (smoothness). '
            'Be very strict: if it is messy or slightly off-balance, do not give a high score. '
            'Return your evaluation in JSON format with: '
            '"isCorrect" (boolean) and "score" (integer 0-100). '
            'Score guide: 90+ is near perfect, 70-89 is acceptable, 40-69 is poor, below 40 is incorrect. '
            'If the drawing is just scribbles or not the character at all, isCorrect should be false and score below 20. '
            'Only respond with the JSON.'
          ),
        ])
      ];

      final response = await _model.generateContent(prompt);
      return response.text;
    } catch (e) {
      debugPrint('Gemini Error: $e');
      return 'ERROR: $e';
    }
  }
}
