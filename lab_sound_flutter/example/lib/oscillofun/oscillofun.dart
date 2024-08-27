import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:lab_sound_inspector/lab_sound_inspector.dart';

class Oscillofun extends StatefulWidget {
  final String path;

  Oscillofun({
    this.path = "./assets/oscillofun.wav",
    Key? key,
  }) : super(key: key);

  @override
  _OscillofunState createState() => _OscillofunState();
}

class _OscillofunState extends State<Oscillofun> {
  AudioContext? audioContext;
  AnalyserNode? analyserNodeL;
  AnalyserNode? analyserNodeR;
  late AudioBus audioBus;
  late AudioSampleNode audioSample;

  @override
  void initState() {
    super.initState();
    initAudioEngine();
  }

  initAudioEngine() async {
    audioContext = AudioContext();

    if (audioContext == null) return;
    audioBus = await audioBusFromAsset(widget.path);

    analyserNodeL = AnalyserNode(audioContext!, fftSize: pow(2, 15).toInt());
    analyserNodeR = AnalyserNode(audioContext!, fftSize: pow(2, 15).toInt());

    audioSample = AudioSampleNode(audioContext!);

    final channelsCount = 2;

    final splitter =
        ChannelSplitterNode(audioContext!, numberOfOutputs: channelsCount);

    final merger =
        ChannelMergerNode(audioContext!, numberOfInputs: channelsCount);
    merger.setOutputChannelCount(2);

    audioSample.connect(splitter);

    splitter.connect(analyserNodeL!, 0, 0);
    splitter.connect(analyserNodeR!, 0, 1);

    analyserNodeL!.connect(merger, 0, 0);
    analyserNodeR!.connect(merger, 1, 0);

    merger.connect(audioContext!.destination);

    audioSample.setBus(audioBus);

    audioSample.start();

    audioSample.onEnded.listen((event) {
      print("audioSample ended");
    });

    setState(() {});
  }

  @override
  void dispose() {
    audioSample.stop();
    audioContext?.dispose();
    super.dispose();
  }

  Widget body() {
    return ListView(
      children: [
        if (analyserNodeL != null && analyserNodeR != null)
          Container(
              height: 500, child: Oscilloscope(analyserNodeL!, analyserNodeR!)),
        Text("Left:"),
        if (analyserNodeL != null)
          Container(height: 25, child: DrawTimeDomain(analyserNodeL!)),
        if (analyserNodeL != null)
          Container(height: 25, child: DrawFrequency(analyserNodeL!)),
        Text("Right:"),
        if (analyserNodeR != null)
          Container(height: 25, child: DrawTimeDomain(analyserNodeR!)),
        if (analyserNodeR != null)
          Container(height: 25, child: DrawFrequency(analyserNodeR!)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oscillofun'),
      ),
      body: body(),
    );
  }
}

class Oscilloscope extends StatefulWidget {
  final AnalyserNode l;
  final AnalyserNode r;

  const Oscilloscope(this.l, this.r, {Key? key}) : super(key: key);

  @override
  _OscilloscopeState createState() => _OscilloscopeState();
}

class _OscilloscopeState extends State<Oscilloscope>
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

  final List<List<Offset>> spotList = [];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, snapshot) {
          final l = widget.l.getFloatTimeDomainData();
          final r = widget.r.getFloatTimeDomainData();
          final spot = List.generate(
              l.length, (index) => Offset(0 - l[index] / 2, (r[index]) / 2));
          spotList.add(spot);
          if (spotList.length > 2) {
            spotList.removeAt(0);
          }
          return Container(
            color: Colors.black,
            child: CustomPaint(
              painter: OscilloscopePainter(spotList),
            ),
          );
        });
  }
}

class OscilloscopePainter extends CustomPainter {
  final List<List<Offset>> spotList;

  OscilloscopePainter(this.spotList) : super() {
    strokePaintList = List.generate(100, (index) {
      final o = index / 99;
      return Paint()
        ..color = Colors.green.withOpacity(o / 2)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
    });
  }

  List<Paint> strokePaintList = [];

  @override
  void paint(Canvas canvas, Size size) {
    final double boxSize = min(size.width, size.height);
    final double top = (size.height - boxSize) / 2;
    final double left = (size.width - boxSize) / 2;
    final padding = Offset(left + boxSize / 2, top + boxSize / 2);
    int n = 0;
    Offset? prevSpot;
    spotList.forEach((spots) {
      n += 1;
      double op = n / spotList.length;
      if (op != 1.0) op = op / 2;
      spots.forEach((element) {
        final offset = padding + element * boxSize;
        double opacity = 1.0;
        if (prevSpot != null) {
          final o = prevSpot! - offset;
          final distance = o.distance.abs();
          opacity = 1 - (distance / 60);
          if (opacity <= 0.05) opacity = 0.05;
          if (opacity >= 1) opacity = 1;
          opacity = opacity * op;
          canvas.drawLine(
              prevSpot!,
              offset,
              strokePaintList[
                  ((strokePaintList.length - 1) * opacity).toInt()]);
        }
        prevSpot = offset;
      });
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
