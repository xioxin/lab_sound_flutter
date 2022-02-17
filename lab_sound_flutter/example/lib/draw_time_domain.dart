import 'package:flutter/material.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';

class DrawTimeDomain extends StatefulWidget {
  final AnalyserNode analyserNode;

  DrawTimeDomain(this.analyserNode, {Key? key}) : super(key: key);

  @override
  _DrawTimeDomainState createState() => _DrawTimeDomainState();
}

class _DrawTimeDomainState extends State<DrawTimeDomain>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller =
        AnimationController(duration: const Duration(days: 365), vsync: this);
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, snapshot) {
          return CustomPaint(
            painter: TimeDomainPainter(widget.analyserNode),
          );
        });
  }
}

class TimeDomainPainter extends CustomPainter {
  final AnalyserNode analyserNode;

  TimeDomainPainter(this.analyserNode);

  // Paint mPaint = Paint()..color = Colors.deepOrange;
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    double w = size.width / this.analyserNode.frequencyBinCount;
    double h = size.height / 256.0;
    var path = Path();
    path.moveTo(0, h * 128);
    int n = 0;
    this.analyserNode.getByteTimeDomainData().forEach((val) {
      if (n == 0) {
        path.moveTo(0, h * val);
      } else {
        path.lineTo(n * w, h * val);
      }
      n++;
    });
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
