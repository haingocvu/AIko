import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart' as ml;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class DigitalInkService {
  static const String _languageCode = 'ja';
  
  late final ml.DigitalInkRecognizer _recognizer;
  late final ml.DigitalInkRecognizerModelManager _manager;
  
  bool get isSupported => !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

  DigitalInkService() {
    if (isSupported) {
      _recognizer = ml.DigitalInkRecognizer(languageCode: _languageCode);
      _manager = ml.DigitalInkRecognizerModelManager();
    }
  }

  Future<void> checkAndDownloadModel() async {
    if (!isSupported) return;
    
    final bool isDownloaded = await _manager.isModelDownloaded(_languageCode);
    if (!isDownloaded) {
      debugPrint('Downloading Japanese ML Kit model...');
      await _manager.downloadModel(_languageCode);
      debugPrint('Model downloaded successfully.');
    }
  }

  Future<List<ml.RecognitionCandidate>?> recognize(List<List<Offset>> strokes) async {
    if (!isSupported) return null;
    if (strokes.isEmpty) return null;

    final ink = ml.Ink();
    for (final stroke in strokes) {
      final inkStroke = ml.Stroke();
      for (final point in stroke) {
        inkStroke.points.add(ml.StrokePoint(
          x: point.dx,
          y: point.dy,
          t: DateTime.now().millisecondsSinceEpoch,
        ));
      }
      ink.strokes.add(inkStroke);
    }

    try {
      final candidates = await _recognizer.recognize(ink);
      return candidates;
    } catch (e) {
      debugPrint('Error recognizing ink: $e');
      return null;
    }
  }

  void dispose() {
    if (isSupported) {
      _recognizer.close();
    }
  }
}
