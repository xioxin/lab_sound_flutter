import 'dart:ffi';
import 'dart:io';

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

  @override
  void initState() {
    super.initState();
    initPath();
  }

  Future<String> loadAsset(String path) async {
    final tempDir = await getTemporaryDirectory();
    final file = File(tempDir.path + '/' + path);
    await file.writeAsBytes(
        (await rootBundle.load('assets/' + path)).buffer.asUint8List());
    return file.path;
  }

  initPath() async {
    this.stereoMusicClipPath = await loadAsset('stereo-music-clip.wav');
    this.music1Path = await loadAsset('music1.mp3');
    this.music2Path = await loadAsset('music2.mp3');
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                  child: Text("TEST"),
                  onPressed: () async {
                    // lab.labTest();
                  }),
              ElevatedButton(
                  child: Text("Play"),
                  onPressed: () async {
                    final audioBus = await AudioBus.async(this.music1Path);
                    final audioNode = AudioSampleNode(audioContext, resource: audioBus);
                    final analyserNode = AnalyserNode(audioContext);
                    analyserNode.connect(audioContext.destination);
                    audioNode.connect(analyserNode);
                    audioNode.start();
                    Timer.periodic(Duration(milliseconds: 200), (Timer timer) {
                      analyserNode.getFloatFrequencyData();
                    });
                  }),
              ElevatedButton(
                  child: Text("重新链接设备"),
                  onPressed: () async {
                    audioContext.resetDevice();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
