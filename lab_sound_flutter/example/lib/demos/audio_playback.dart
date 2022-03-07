import 'package:flutter/material.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:lab_sound_inspector/lab_sound_inspector.dart';

class AudioPlayback extends StatefulWidget {
  @override
  _AudioPlaybackState createState() => _AudioPlaybackState();
}

class _AudioPlaybackState extends State<AudioPlayback> {
  late AudioContext ctx;
  late AudioSampleNode audioSample;
  AudioBus? audioBus;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    ctx.dispose();
    super.dispose();
  }

  init() async {
    ctx = AudioContext();
    audioSample = AudioSampleNode(ctx);
    audioSample.connect(ctx.destination);

    audioBus = await audioBusFromAsset('assets/stereo-music-clip.wav');
    audioSample.setBus(audioBus!);

    audioSample.onEnded.listen((event) {
      print("audioSample ended");
    });

    setState(() {});
  }

  play() {
    audioSample.start();
  }

  stop() {
    audioSample.stop();
  }

  @override
  Widget build(BuildContext context) {
    return DebugScaffold(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('AudioPlayback'),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (audioBus == null) Text("loading"),
              if (audioBus != null)
                TextButton(onPressed: play, child: Text('Play')),
              if (audioBus != null)
                TextButton(onPressed: stop, child: Text('Stop')),
            ],
          )),
    );
  }
}
