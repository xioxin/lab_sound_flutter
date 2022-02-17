import 'package:flutter/material.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:lab_sound_flutter_example/draw_frequency.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Recorder extends StatefulWidget {

  @override
  _RecorderState createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {

  AnalyserNode? analyser;


  bool recording = false;

  @override
  void initState() {
    super.initState();
  }

  Future startRecording() async {
    if (!await Permission.microphone.request().isGranted) return;

    final AudioContext audioContext = AudioContext(outputConfig: AudioStreamConfig(deviceIndex: -1, desiredSampleRate: 44100.0), inputConfig: AudioStreamConfig(deviceIndex: 22, desiredChannels: 1, desiredSampleRate: 44100.0));
    final AudioNode inputNode = audioContext.makeAudioHardwareInputNode();

    setState(() {
      analyser = AnalyserNode(audioContext);
    });
    final RecorderNode recorder = RecorderNode(audioContext, 1);

    inputNode.connect(analyser!);
    analyser!.connect(recorder);

    audioContext.addAutomaticPullNode(recorder);
    recorder.startRecording();

    await Future.delayed(Duration(seconds: 5));

    recorder.stopRecording();
    audioContext.removeAutomaticPullNode(recorder);

    final tempDir = await getTemporaryDirectory();
    final savePath = tempDir.path + '/test.wav';

    recorder.writeRecordingToWav(savePath);
    print("savePath: $savePath ");

    OpenFile.open(savePath);
    audioContext.dispose();
    setState(() {
      analyser = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          if(analyser != null) Container(height: 300, child: DrawFrequency(analyser!)),
          ElevatedButton(
              child: Text("录音"),
              onPressed: () async {
                startRecording();
              }),
        ],
      ),
    );
  }
}