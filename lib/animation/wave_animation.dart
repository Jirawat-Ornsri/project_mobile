import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaveProgress extends StatefulWidget {
  final double progress;
  final double width;
  final double height;
  final Color color;
  final double waterLevel;

  const WaveProgress({
    Key? key,
    required this.progress,
    required this.width,
    required this.height,
    required this.color,
    required this.waterLevel,
  }) : super(key: key);

  @override
  _WaveProgressState createState() => _WaveProgressState();
}

class _WaveProgressState extends State<WaveProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(widget.width, widget.height),
      painter: WaveProgressPainter(
        progress: widget.progress,
        color: widget.color,
        waterLevel: widget.waterLevel,
        animation: _animationController,
      ),
    );
  }
}

class WaveProgressPainter extends CustomPainter {
  final double progress;
  final double waterLevel;
  final Color color;
  final Animation<double> animation;

  WaveProgressPainter({
    required this.progress,
    required this.color,
    required this.waterLevel,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final wavePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw water
    final waterPath = Path();
    waterPath.moveTo(0, size.height * waterLevel);

    final double baseHeight = size.height * (1 - progress);
    final double amplitude = 10;
    final double frequency = 1.5;
    for (double i = 0; i < size.width; i++) {
      final y = baseHeight +
          amplitude *
              math.sin(frequency * math.pi * i / size.width + animation.value * 2 * math.pi);
      waterPath.lineTo(i, y);
    }

    waterPath.lineTo(size.width, size.height);
    waterPath.lineTo(0, size.height);
    waterPath.close();
    canvas.drawPath(waterPath, wavePaint);
  }

  @override
  bool shouldRepaint(WaveProgressPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      waterLevel != oldDelegate.waterLevel ||
      color != oldDelegate.color;
}
