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
            'This is a handwritten Japanese character. The target character is "$targetChar". '
            'Please analyze the image and respond in JSON format with two fields: '
            '"isCorrect" (boolean) and "score" (integer 0-100 representing the quality/accuracy of the writing). '
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
