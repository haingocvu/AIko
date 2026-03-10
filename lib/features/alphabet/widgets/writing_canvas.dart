import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';

class WritingCanvas extends StatefulWidget {
  final String referenceChar;
  final Color strokeColor;
  final double strokeWidth;

  const WritingCanvas({
    super.key,
    required this.referenceChar,
    this.strokeColor = Colors.white,
    this.strokeWidth = 8.0,
  });

  @override
  State<WritingCanvas> createState() => WritingCanvasState();
}

class WritingCanvasState extends State<WritingCanvas> {
  final List<List<Offset>> _strokes = [];
  final GlobalKey _canvasKey = GlobalKey();

  void clear() {
    setState(() {
      _strokes.clear();
    });
  }

  void undo() {
    if (_strokes.isNotEmpty) {
      setState(() {
        _strokes.removeLast();
      });
    }
  }

  Future<Uint8List?> captureImage() async {
    try {
      final boundary = _canvasKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      
      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing canvas: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Reference Character Background (Outside RepaintBoundary)
        Center(
          child: Opacity(
            opacity: 0.1,
            child: Text(
              widget.referenceChar,
              style: const TextStyle(
                fontSize: 200,
                fontFamily: 'NotoSansJP',
                color: Colors.white,
              ),
            ),
          ),
        ),
        // Drawing Layer (Inside RepaintBoundary)
        RepaintBoundary(
          key: _canvasKey,
          child: GestureDetector(
            onPanStart: (details) {
              setState(() {
                _strokes.add([details.localPosition]);
              });
            },
            onPanUpdate: (details) {
              if (_strokes.isNotEmpty) {
                setState(() {
                  _strokes.last.add(details.localPosition);
                });
              }
            },
            child: Container(
              color: Colors.transparent, // Interactive area
              child: CustomPaint(
                painter: _CanvasPainter(_strokes, widget.strokeColor, widget.strokeWidth),
                size: Size.infinite,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CanvasPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Color strokeColor;
  final double strokeWidth;

  _CanvasPainter(this.strokes, this.strokeColor, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    // Fill background with solid black for AI to see white strokes clearly
    final bgPaint = Paint()..color = Colors.black;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.isEmpty) continue;
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CanvasPainter oldDelegate) => true;
}
