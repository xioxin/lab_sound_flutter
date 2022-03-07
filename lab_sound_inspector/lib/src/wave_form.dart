import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lab_sound_ffi/lab_sound_ffi.dart';

class WaveForm extends StatefulWidget {
  final AudioBus audioBus;
  const WaveForm(this.audioBus, {Key? key}) : super(key: key);
  @override
  _WaveFormState createState() => _WaveFormState();
}

class _WaveFormState extends State<WaveForm>
    with SingleTickerProviderStateMixin {
  // late AnimationController controller;
  List<double> rough = [];

  @override
  void initState() {
    final channel = widget.audioBus.channel(1);
    final data = channel?.getData().toList() ?? [];
    rough = resample(data, 5000);
    // // TODO: implement initState
    // controller =
    //     AnimationController(duration: const Duration(days: 365), vsync: this);
    // controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    // controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WaveFormPainter(rough),
    );
  }
}

class WaveFormPainter extends CustomPainter {
  WaveFormPainter(this.rough, {Listenable? repaint}) : super(repaint: repaint);

  List<double> rough = [];
  List<double> waveData = [];

  List<double> getWave(int width) {
    if (rough.isEmpty) return [];
    if (waveData.length == width) return waveData;
    waveData = resample(rough, width);
    return waveData;
  }

  // Paint mPaint = Paint()..color = Colors.deepOrange;
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width.ceil();
    final wave = getWave(width * 5);
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;
    double w = 1 / 5;
    double h = size.height;
    int n = 0;

    for (var val in wave) {
      canvas.drawRect(
          Rect.fromLTWH(
              n * w, size.height / 2 - (val * h) / 2, w, max(0.5, val * h)),
          paint);
      n++;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is WaveFormPainter) {
      if (oldDelegate.waveData.isNotEmpty) {
        return false;
      }
    }
    return true;
  }
}

List<double> resample(List<double> list, int size) {
  if (list.isEmpty) {
    return [];
  }
  final int length = list.length;
  final binSize = length ~/ size;
  final List<double> wave = [];
  for (int i = 0; i < size; i += 1) {
    final subList = list.sublist(i * binSize, i * binSize + binSize).toList();
    final maxValue =
        subList.reduce((value, element) => max(element.abs(), value));
    wave.add(maxValue);
  }
  return wave;
}
