import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab_sound_flutter/lab_player.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:lab_sound_flutter_example/demos/music-time.dart';
import 'package:path_provider/path_provider.dart';
import 'package:lab_sound_flutter/player_node.dart';

import '../draw_frequency.dart';
import '../draw_time_domain.dart';

class PlayerPage extends StatefulWidget {
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage>
    with SingleTickerProviderStateMixin {
  late String stereoMusicClipPath;
  late String music1Path;
  late String music2Path;
  late String music3Path;
  late String synthesizerHighPath;
  late String synthesizerLowPath;

  late AudioBus stereoMusicClipBus;
  late AudioBus music1Bus;
  late AudioBus music2Bus;
  late AudioBus music3Bus;
  late AudioBus synthesizerHighBus;
  late AudioBus synthesizerLowBus;

  late AudioSampleNode synthesizerHighSample;
  late AudioSampleNode synthesizerLowSample;

  late PlayerNode player;
  late AudioContext audioContext;

  late AnalyserNode analyserNode;

  late AnimationController playButtonAnimationController;

  bool loaded = false;

  @override
  void dispose() {

    synthesizerHighSample.dispose();
    synthesizerLowSample.dispose();

    analyserNode.dispose();
    player.dispose();
    audioContext.dispose();

    stereoMusicClipBus.dispose();
    music1Bus.dispose();
    music2Bus.dispose();
    music3Bus.dispose();
    synthesizerHighBus.dispose();
    synthesizerLowBus.dispose();

    playButtonAnimationController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    playButtonAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350),
      reverseDuration: Duration(milliseconds: 350),
    );
    // audioContext = AudioContext(initSampleRate: 44100.0);
    audioContext = AudioContext(initSampleRate: 44100.0);
    player = PlayerNode(audioContext);
    analyserNode = AnalyserNode(audioContext);
    player.connect(analyserNode);
    analyserNode.connect(audioContext.destination);
    super.initState();
    init();
  }

  Future<String> loadAsset(String path) async {
    final tempDir = await getTemporaryDirectory();
    final file = File(tempDir.path + '/' + path);
    await file.writeAsBytes(
        (await rootBundle.load('assets/' + path)).buffer.asUint8List());
    return file.path;
  }

  Future init() async {
    int a = 0;
    this.stereoMusicClipPath = await loadAsset('stereo-music-clip.wav');
    this.music1Path = await loadAsset('music1.mp3');
    this.music2Path = await loadAsset('music2.mp3');
    this.music3Path = await loadAsset('music3.mp3');
    this.synthesizerHighPath = await loadAsset('synthesizer-high.wav');
    this.synthesizerLowPath = await loadAsset('synthesizer-low.wav');

    final p = [
      stereoMusicClipPath,
      music1Path,
      music2Path,
      music3Path,
      synthesizerHighPath,
      synthesizerLowPath
    ].map((e) => AudioBus.async(e));
    final data = (await Future.wait(p)).toList();

    stereoMusicClipBus = data[0];
    music1Bus = data[1];
    music2Bus = data[2];
    music3Bus = data[3];
    synthesizerHighBus = data[4];
    synthesizerLowBus = data[5];

    this.synthesizerHighSample =
        AudioSampleNode(audioContext, resource: synthesizerHighBus);
    this.synthesizerLowSample =
        AudioSampleNode(audioContext, resource: synthesizerLowBus);

    this.synthesizerHighSample.connect(audioContext.destination);
    this.synthesizerLowSample.connect(audioContext.destination);
    setState(() {
      loaded = true;
    });
  }

  String timeString(Duration time) {
    final m = time.inMinutes.toString().padLeft(2, '0');
    final s = (time.inSeconds % 60).toString().padLeft(2, '0');
    final ms = (time.inMilliseconds % 1000).toString().padLeft(2, '0');
    return "$m:$s.$ms";
  }

  double? userPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: loaded
          ? SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(height: 50, child: DrawTimeDomain(analyserNode)),
                  Container(height: 200, child: DrawFrequency(analyserNode)),
                  StreamBuilder<Duration>(
                      stream: player.onPosition,
                      initialData: player.position,
                      builder: (context, snapshot) {
                        Duration pos = snapshot.data ?? Duration.zero;
                        // print(pos);
                        final duration =
                            player.duration ?? Duration(minutes: 3);
                        // print(duration);
                        if(pos > duration) pos = duration;

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                "${timeString(userPosition == null ? pos : Duration(milliseconds: userPosition!.toInt()))} / ${timeString(duration)}"),
                            Slider(
                              value:
                                  userPosition ?? pos.inMilliseconds.toDouble(),
                              onChangeStart: (v) {
                                print('onChangeStart $v');
                                userPosition = v;
                              },
                              onChangeEnd: (v) async {
                                print('onChangeEnd $v');
                                userPosition = null;
                                player
                                    .seekTo(Duration(milliseconds: v.toInt()));
                              },
                              onChanged: (v) {
                                print('onChanged $v');
                                setState(() {
                                  userPosition = v;
                                });
                              },
                              max: duration.inMilliseconds.toDouble(),
                              min: 0.0,
                            ),
                          ],
                        );
                      }),
                  StreamBuilder<PlayerNodeStatus?>(
                      stream: player.onStatus,
                      initialData: null,
                      builder: (context, snapshot) {
                        if (snapshot.data == PlayerNodeStatus.playing) {
                          playButtonAnimationController.forward();
                        } else {
                          playButtonAnimationController.reverse();
                        }
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(snapshot.data?.toString() ?? 'null'),
                            IconButton(
                              icon: AnimatedIcon(
                                  icon: AnimatedIcons.play_pause,
                                  progress: playButtonAnimationController),
                              onPressed: () {
                                if (snapshot.data == PlayerNodeStatus.playing) {
                                  player.pause();
                                } else {
                                  player.resume();
                                }
                              },
                            ),
                          ],
                        );
                      }),

                  Text("PlaybackRate: ${player.playbackRate}"),
                  Slider(
                    value: player.playbackRate,
                    onChanged: (v) {
                      setState(() {
                        player.playbackRate = v;
                      });
                    },
                    max: 2.0,
                    min: 0.2,
                  ),

                  Text("Gain: ${player.gain.value}"),
                  Slider(
                    value: player.gain.value,
                    onChanged: (v) {
                      setState(() {
                        player.gain.setValue(v);
                      });
                    },
                    max: 1.0,
                    min: 0.0,
                  ),

                  ElevatedButton(
                      child: Text("File 1"),
                      onPressed: () {
                        player.play(music1Bus);
                      }),
                  ElevatedButton(
                      child: Text("File 2"),
                      onPressed: () {
                        player.play(music2Bus);
                      }),
                  ElevatedButton(
                      child: Text("File 3"),
                      onPressed: () {
                        player.play(stereoMusicClipBus);
                      }),
                  ElevatedButton(
                      child: Text("File 4"),
                      onPressed: () {
                        final startTime = audioContext.currentTime + 0.2;
                        player.play(music3Bus, when: startTime);
                        int i = 0;
                        musicTime.forEach((time) {
                          if (i++ % 4 == 0) {
                            this
                                .synthesizerHighSample
                                .start(when: startTime + (time / 1000));
                          } else {
                            this
                                .synthesizerLowSample
                                .start(when: startTime + (time / 1000));
                          }
                        });
                      }),
                  ElevatedButton(
                      child: Text("synthesizerHighSample"),
                      onPressed: () {
                        synthesizerHighSample.start();
                      }),
                  ElevatedButton(
                      child: Text("synthesizerLowSample"),
                      onPressed: () {
                        synthesizerLowSample.start();
                      }),
                  ElevatedButton(
                      child: Text("Stop"),
                      onPressed: () {
                        player.stop();
                        this
                            .synthesizerHighSample
                            .clearSchedules();
                        this
                            .synthesizerLowSample
                            .clearSchedules();
                      }),
                  ElevatedButton(
                      child: Text("Device reset"),
                      onPressed: () {

                        // audioContext.device.backendReinitialize();
                        audioContext.device.start();

                        // // audioContext.device.uninitialize();
                        // // audioContext.device.start();
                        // audioContext.suspend();
                        // final out = AudioStreamConfig(deviceIndex: 0, desiredSampleRate: 44100.0, desiredChannels: 2);
                        // final outDev = AudioHardwareDeviceNode(this.audioContext, outputConfig: out);
                        // audioContext.device.linked.forEach((element) {
                        //   element.connect(outDev);
                        // });
                        // audioContext.setDevice(outDev);
                        // outDev.reset();
                        // outDev.start();
                        // audioContext.resume();
                        // print("outDev.isRunning: ${outDev.isRunning}");



                      }),
                  ElevatedButton(
                      child: Text("audioContext resume"),
                      onPressed: () {
                        audioContext.resume();
                      }),
                  ElevatedButton(
                      child: Text("audioContext suspend"),
                      onPressed: () {
                        audioContext.suspend();
                      }),
                  ElevatedButton(
                      child: Text("print status"),
                      onPressed: () {
                        print("isRun: ${audioContext.device.getOutputConfig().deviceIndex}");
                        print("isRun: ${audioContext.device.getInputConfig().deviceIndex}");
                      }),
                ],
              )
            )
          : Center(child: Text("LOADING")),
    );
  }
}
