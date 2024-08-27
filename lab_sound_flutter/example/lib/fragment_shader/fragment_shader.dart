import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:lab_sound_inspector/lab_sound_inspector.dart';

class FragmentShaderDemo extends StatefulWidget {
  final String path;
  final String shaderAssetKey;

  FragmentShaderDemo({
    this.path = "./assets/oscillofun.wav",
    this.shaderAssetKey = "shaders/audio_eclipse.frag",
    Key? key,
  }) : super(key: key);

  @override
  _FragmentShaderDemoState createState() => _FragmentShaderDemoState();
}

class _FragmentShaderDemoState extends State<FragmentShaderDemo> {
  AudioContext? audioContext;
  AnalyserNode? analyserNode;
  late AudioBus audioBus;
  late AudioSampleNode audioSample;
  late Ticker _ticker;
  Duration _elapsed = Duration.zero;
  ui.Image? audioTexture;

  @override
  void initState() {
    super.initState();
    initAudioEngine();
    _ticker = Ticker((elapsed) {
      if (analyserNode!= null) {
        createImageInfo(analyserNode!).then((v) {
          this.audioTexture = v;
        });
      }

      setState(() {
        _elapsed = elapsed;
      });
    });
    _ticker.start();
  }

  initAudioEngine() async {
    audioContext = AudioContext();
    if (audioContext == null) return;
    audioBus = await audioBusFromAsset(widget.path);
    analyserNode = AnalyserNode(audioContext!, fftSize: pow(2, 15).toInt());
    audioSample = AudioSampleNode(audioContext!);
    audioSample.connect(analyserNode!);
    analyserNode!.connect(audioContext!.destination);
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


  List<int> toRgbaList(List<int> list) {
    List<int> data = [];
    for (int i = 0; i < list.length; i++) {
      data.add(list[i]);
      data.addAll([0, 0, 255]);
    }
    return data;
  }

  Future<ui.Image> createImageInfo(AnalyserNode analyserNode) {
    Completer<ui.Image> completer = Completer<ui.Image>();
    final frequencyList = analyserNode.getByteFrequencyData().toList();
    final timeDomainList = analyserNode.getByteTimeDomainData().toList();
    final frequencyRgba = toRgbaList(timeDomainList);
    final timeDomainRgba = toRgbaList(frequencyList);
    int width = frequencyList.length;
    int height = 2;
    final oneLineSize = width * 4;
    final buffer = new Uint8List(height * oneLineSize);
    buffer.setAll(0, timeDomainRgba);
    buffer.setAll(oneLineSize, frequencyRgba);
    ui.PixelFormat pixelFormat = ui.PixelFormat.rgba8888;
    ui.decodeImageFromPixels(buffer, width, height, pixelFormat,
            (ui.Image image) {
          completer.complete(image);
        });
    return completer.future;
  }


  @override
  Widget build(BuildContext context) =>
      ShaderBuilder(
            (BuildContext context, FragmentShader shader, _) =>
            Scaffold(
              appBar: AppBar(
                  title: const Text('FragmentShaderDemo')
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (analyserNode != null)
                    Container(height: 25, child: DrawTimeDomain(analyserNode!)),
                  if (analyserNode != null)
                    Container(height: 25, child: DrawFrequency(analyserNode!)),
                  if (audioTexture != null)
                    Expanded(child: CustomPaint(
                        size: MediaQuery
                            .of(context)
                            .size,
                        painter: ShaderCustomPainter(
                            shader, _elapsed, audioTexture!)
                    ))
                ],
              ),
            ),
        assetKey: widget.shaderAssetKey,
      );

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: const Text('FragmentShader'),
//     ),
//     body: body(),
//   );
// }
}


class ShaderCustomPainter extends CustomPainter {
  final FragmentShader shader;
  final Duration currentTime;
  ui.Image image;

  ShaderCustomPainter(this.shader, this.currentTime, this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, currentTime.inMilliseconds.toDouble() / 1000.0);
    shader.setImageSampler(0, this.image);
    paint.shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
