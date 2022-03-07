import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:lab_sound_inspector/lab_sound_inspector.dart';

class ConvolverDemo extends StatefulWidget {
  const ConvolverDemo({Key? key}) : super(key: key);

  @override
  State<ConvolverDemo> createState() => _ConvolverDemoState();
}

class _ConvolverDemoState extends State<ConvolverDemo> {
  late AudioContext ctx;
  late AudioSampleNode audioSample;
  late ConvolverNode convolverNode;
  AudioBus? audioBus;
  List<AudioBus> filterBus = [];
  List<String> filterName = [
    "Telephone",
    "Muffler",
    "Spring feedback",
    "Crazy echo"
  ];

  int filterIndex = 0;

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
    ctx = AudioContext(
        outputConfig: AudioStreamConfig(
            deviceIndex: LabSound().getDefaultOutputAudioDeviceIndex().index,
            desiredSampleRate: 44100.0,
            desiredChannels: 2));
    audioSample = AudioSampleNode(ctx);
    convolverNode = ConvolverNode(ctx);
    audioSample.connect(convolverNode);
    convolverNode.connect(ctx.destination);

    filterBus = [
      await audioBusFromAsset('assets/impulse/telephone.wav'),
      await audioBusFromAsset('assets/impulse/echo.wav'),
      await audioBusFromAsset('assets/impulse/muffler.wav'),
      await audioBusFromAsset('assets/impulse/spring.wav'),
    ];
    audioBus = await audioBusFromAsset('assets/stereo-music-clip.wav');
    audioSample.setBus(audioBus!);
    convolverNode.setImpulse(filterBus[0]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: DebugScaffold(
          child: SingleChildScrollView(
            child: Container(
              child: audioBus == null
                  ? null
                  : CupertinoSlidingSegmentedControl<int>(
                      children: filterName
                          .asMap()
                          .map((key, value) => MapEntry(key, Text(value))),
                      onValueChanged: (value) {
                        setState(() {
                          filterIndex = value ?? 0;
                        });

                        convolverNode.setImpulse(filterBus[filterIndex]);
                        if (!audioSample.isPlayingOrScheduled) {
                          audioSample.start();
                        }
                      },
                      groupValue: filterIndex),
            ),
          ),
        ));
  }
}
