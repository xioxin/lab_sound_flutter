import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  late String stereoMusicClipPath;
  late String music1Path;
  late String music2Path;
  AudioContext audioContext = AudioContext();
  late AudioBus audioBus;
  late AudioSampleNode audioNode;
  late AnalyserNode analyserNode;
  late OscillatorNode oscillatorNode;
  late BiquadFilterNode biquadFilterNode;
  late GainNode gainA;
  late GainNode gainB;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    initPath().then((v) {
      initPlayer();
    });
  }

  Future<String> loadAsset(String path) async {
    final tempDir = await getTemporaryDirectory();
    final file = File(tempDir.path + '/' + path);
    await file.writeAsBytes(
        (await rootBundle.load('assets/' + path)).buffer.asUint8List());
    return file.path;
  }

  Future initPath() async {
    this.stereoMusicClipPath = await loadAsset('stereo-music-clip.wav');
    this.music1Path = await loadAsset('music1.mp3');
    this.music2Path = await loadAsset('music2.mp3');
  }

  initPlayer() async {
    var rng = new Random();
    audioBus = await AudioBus.async(
        rng.nextInt(1) == 1 ? this.music2Path : this.music1Path);
    audioNode = AudioSampleNode(audioContext, resource: audioBus);
    analyserNode = AnalyserNode(audioContext, fftSize: 2080);
    oscillatorNode = OscillatorNode(audioContext);
    biquadFilterNode = BiquadFilterNode(audioContext);


    gainA = GainNode(audioContext);
    gainB = GainNode(audioContext);
    analyserNode.connect(audioContext.destination);
    audioNode.connect(gainA);
    gainA.connect(biquadFilterNode);
    oscillatorNode.connect(gainB);
    gainB.connect(biquadFilterNode);
    biquadFilterNode.connect(analyserNode);
    setState(() {
      loaded = true;
    });
  }

  AnalyserBuffer<int>? testAnalyser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: loaded
            ? ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  Text("音乐: ${audioContext.currentTime}"),
                  ElevatedButton(
                      child: Text("Play Music"),
                      onPressed: () async {
                        audioNode.schedule(when: 0);
                      }),
                  ElevatedButton(
                      child: Text("Stop Music"),
                      onPressed: () async {
                        audioNode.clearSchedules();
                        audioNode.stop();
                      }),

                  ElevatedButton(
                      child: Text("淡入"),
                      onPressed: () async {
                        gainA.gain.setValueAtTime(0, audioContext.currentTime + 0.1);
                        gainA.gain.linearRampToValueAtTime(1.0, audioContext.currentTime + 1.0);
                        audioNode.schedule(when: audioContext.currentTime + 0.1);
                      }),
                  ElevatedButton(
                      child: Text("淡出"),
                      onPressed: () async {
                        gainA.gain.setValueAtTime(gainA.gain.value, audioContext.currentTime + 0.1);
                        gainA.gain.linearRampToValueAtTime(0.0, audioContext.currentTime + 1.0);
                        audioNode.stop(when: audioContext.currentTime + 1.0);
                        // audioNode.clearSchedules();
                      }),

                  Slider(
                    value: gainA.gain.value,
                    onChanged: (v) {
                      setState(() {
                        gainA.gain.setValue(v);
                      });
                    },
                    label: "音量:${gainA.gain.value}",
                    max: 1.0,
                    min: 0.0,
                  ),




                  Text("频率发生器"),
                  ElevatedButton(
                      child: Text("Play Oscillator"),
                      onPressed: () async {
                        oscillatorNode.start();
                      }),
                  ElevatedButton(
                      child: Text("Stop Oscillator"),
                      onPressed: () async {
                        oscillatorNode.stop();
                      }),
                  Slider(
                    value: gainB.gain.value,
                    onChanged: (v) {
                      setState(() {
                        gainB.gain.setValue(v);
                      });
                    },
                    label: "音量:${gainB.gain.value}",
                    max: 1.0,
                    min: 0.0,
                  ),
                  Row(
                    children: [
                      Container(
                          width: 100.0,
                          child: Text(
                              "频率：\n${oscillatorNode.frequency.value.toStringAsFixed(2)}")),
                      Expanded(
                        child: Slider(
                          value: oscillatorNode.frequency.value,
                          onChanged: (v) {
                            setState(() {
                              oscillatorNode.frequency.setValue(v);
                            });
                          },
                          max: 12000.0,
                          min: 0.0,
                        ),
                      ),
                    ],
                  ),
                  DropdownButton<OscillatorType>(
                    value: oscillatorNode.type,
                      items: OscillatorType.values
                          .map((e) => DropdownMenuItem(
                                child: Text("$e"),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) oscillatorNode.setType(val);
                      }),

                  Text("滤波器"),

                  DropdownButton<FilterType>(
                      value: biquadFilterNode.type,
                      items: FilterType.values
                          .map((e) => DropdownMenuItem(
                        child: Text("$e"),
                        value: e,
                      ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) biquadFilterNode.setType(val);
                      }),

                  Row(
                    children: [
                      Container(
                          width: 100.0,
                          child: Text(
                              "frequency：\n${biquadFilterNode.frequency.value.toStringAsFixed(2)}")),
                      Expanded(
                        child: Slider(
                          value: biquadFilterNode.frequency.value,
                          onChanged: (v) {
                            setState(() {
                              biquadFilterNode.frequency.setValue(v);
                            });
                          },
                          max: 12000.0,
                          min: 0.0,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                          width: 100.0,
                          child: Text(
                              "detune：\n${biquadFilterNode.detune.value.toStringAsFixed(2)}")),
                      Expanded(
                        child: Slider(
                          value: biquadFilterNode.detune.value,
                          onChanged: (v) {
                            setState(() {
                              biquadFilterNode.detune.setValue(v);
                            });
                          },
                          max: 12000.0,
                          min: 0.0,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                          width: 100.0,
                          child: Text(
                              "Q：\n${biquadFilterNode.q.value.toStringAsFixed(2)}")),
                      Expanded(
                        child: Slider(
                          value: biquadFilterNode.q.value,
                          onChanged: (v) {
                            setState(() {
                              biquadFilterNode.q.setValue(v);
                            });
                          },
                          max: 1000.0,
                          min: 0.0,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                          width: 100.0,
                          child: Text(
                              "gain：\n${biquadFilterNode.gain.value.toStringAsFixed(2)}")),
                      Expanded(
                        child: Slider(
                          value: biquadFilterNode.gain.value,
                          onChanged: (v) {
                            setState(() {
                              biquadFilterNode.gain.setValue(v);
                            });
                          },
                          max: 1.0,
                          min: 0.0,
                        ),
                      ),
                    ],
                  ),


                  Text("其他"),
                  ElevatedButton(
                      child: Text("重新链接设备"),
                      onPressed: () async {
                        audioContext.resetDevice();
                      }),
                  Container(height: 50, child: DrawTimeDomain(analyserNode)),
                  Container(height: 200, child: DrawFrequency(analyserNode))
                ],
              )
            : Center(child: Text("LOADING")),
      ),
    );
  }
}

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
