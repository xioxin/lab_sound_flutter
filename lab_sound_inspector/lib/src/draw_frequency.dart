import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lab_sound_ffi/lab_sound_ffi.dart';

class DrawFrequency extends StatefulWidget {
  final AnalyserNode analyserNode;

  DrawFrequency(this.analyserNode, {Key? key}) : super(key: key);

  @override
  _DrawFrequencyState createState() => _DrawFrequencyState();
}

class _DrawFrequencyState extends State<DrawFrequency>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    controller =
        AnimationController(duration: const Duration(days: 365), vsync: this);
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, snapshot) {
          return CustomPaint(
            painter: DrawFrequencyPainter(widget.analyserNode),
          );
        });
  }
}

class DrawFrequencyPainter extends CustomPainter {
  final AnalyserNode analyserNode;

  DrawFrequencyPainter(this.analyserNode);

  // Paint mPaint = Paint()..color = Colors.deepOrange;
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;
    double w = size.width / this.analyserNode.frequencyBinCount;
    double h = size.height / 256.0;
    int n = 0;
    this.analyserNode.getByteFrequencyData().forEach((val) {
      canvas.drawRect(
          Rect.fromLTWH(n * w, size.height - val * h,
              max(w.ceil().toDouble(), 1.0), val * h),
          paint);
      n++;
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
