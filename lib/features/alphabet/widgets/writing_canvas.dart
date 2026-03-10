import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';

class WritingCanvas extends StatefulWidget {
  final String referenceChar;
  final Color strokeColor;
  final double strokeWidth;
  final int level;

  const WritingCanvas({
    super.key,
    required this.referenceChar,
    this.strokeColor = Colors.white,
    this.strokeWidth = 8.0,
    required this.level,
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

  List<List<Offset>> getStrokes() {
    return _strokes;
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
        if (widget.level < 3)
          Center(
            child: widget.level == 1 
              ? Opacity(
                  opacity: 0.3,
                  child: _buildRefText(),
                )
              : ShaderMask(
                  shaderCallback: (bounds) => const RadialGradient(
                    center: Alignment.center,
                    radius: 0.5,
                    colors: [Colors.white, Colors.transparent],
                    stops: [0.3, 0.7],
                  ).createShader(bounds),
                  blendMode: BlendMode.dstIn,
                  child: Opacity(
                    opacity: 0.3,
                    child: _buildRefText(),
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

  Widget _buildRefText() {
    return Text(
      widget.referenceChar,
      style: const TextStyle(
        fontSize: 200,
        fontFamily: 'NotoSansJP',
        color: Colors.white,
      ),
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
