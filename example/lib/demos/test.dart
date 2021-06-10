import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../draw_frequency.dart';
import '../draw_time_domain.dart';

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
          // StreamBuilder(
          //     stream: audioNode.onPosition,
          //     initialData: audioNode.position,
          //     builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {
          //       return Row(
          //         children: [
          //           Text("${snapshot.data}/${audioNode.resource!.duration}"),
          //           Expanded(
          //             child: Slider(
          //               value: userPosition != null ? userPosition! : snapshot.data!.inMilliseconds.toDouble(),
          //               onChangeStart: (v) {
          //                 print('onChangeStart $v');
          //                 userPosition = v;
          //               },
          //               onChangeEnd: (v) async {
          //                 print('onChangeEnd $v');
          //                 userPosition = null;
          //                 audioNode.clearSchedules();
          //                 Timer(Duration(milliseconds: 10), () {
          //                   audioNode.start(when: 0, offset: v / 1000);
          //                 });
          //               },
          //               onChanged: (v) {
          //                 print('onChanged $v');
          //                 setState(() {
          //                   userPosition = v;
          //                 });
          //               },
          //               max: audioNode.resource!.duration.inMilliseconds.toDouble(),
          //               min: 0.0,
          //             ),
          //           ),
          //         ],
          //       );
          //     }),
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
          // ElevatedButton(
          //     child: Text("淡入"),
          //     onPressed: () async {
          //       gain.gain.setValueAtTime(0, audioContext.currentTime);
          //       gain.gain.linearRampToValueAtTime(
          //           1.0, audioContext.currentTime + 1.0);
          //       // audioNode.clearSchedules();
          //       audioNode.start(when: audioContext.currentTime);
          //     }),
          // ElevatedButton(
          //     child: Text("淡出"),
          //     onPressed: () async {
          //       gain.gain.setValueAtTime(
          //           gain.gain.value, audioContext.currentTime);
          //       gain.gain.linearRampToValueAtTime(
          //           0.0, audioContext.currentTime + 1.0);
          //       audioNode.stop(when: audioContext.currentTime + 1.0);
          //     }),
          // Row(
          //   children: [
          //     Text("音量:${gain.gain.value.toStringAsFixed(2)}"),
          //     Expanded(
          //       child: Slider(
          //         value: gain.gain.value,
          //         onChanged: (v) {
          //           setState(() {
          //             gain.gain.cancelScheduledValues(0.0);
          //             gain.gain.setValue(v);
          //           });
          //         },
          //         max: 1.0,
          //         min: 0.0,
          //       ),
          //     ),
          //   ],
          // ),
          // Text("其他"),
          // ElevatedButton(
          //     child: Text("重新链接设备"),
          //     onPressed: () async {
          //       audioContext.device.reset();
          //     }),
          // Container(height: 50, child: DrawTimeDomain(analyserNode)),
          // Container(height: 200, child: DrawFrequency(analyserNode))
        ],
      )
          : Center(child: Text("LOADING")),
    );
  }
}
