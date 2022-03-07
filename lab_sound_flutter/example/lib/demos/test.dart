import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:lab_sound_inspector/lab_sound_inspector.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late String stereoMusicClipPath;
  late String music1Path;
  late String music2Path;
  AudioContext audioContext = AudioContext();
  late AudioBus audioBus;
  late AudioSampleNode audioNode;
  // late AnalyserNode analyserNode;
  // late GainNode gain;
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
    audioBus = await AudioBus.fromFile(this.stereoMusicClipPath);
    audioNode = AudioSampleNode(audioContext, resource: audioBus);
    // analyserNode = AnalyserNode(audioContext, fftSize: 2080);
    // gain = GainNode(audioContext);
    audioNode.connect(audioContext.destination);
    // gain.connect(analyserNode);
    // analyserNode.connect(audioContext.destination);
    setState(() {
      loaded = true;
    });
  }

  AnalyserBuffer<int>? testAnalyser;

  double? userPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: loaded
          ? ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Text("音乐: "),
                ElevatedButton(
                    child: Text("Play Music"),
                    onPressed: () async {
                      // audioNode.clearSchedules();
                      audioNode.schedule();
                    }),
                ElevatedButton(
                    child: Text("Stop Music"),
                    onPressed: () async {
                      audioNode.clearSchedules();
                      audioNode.stop();
                    }),
              ],
            )
          : Center(child: Text("LOADING")),
    );
  }
}
