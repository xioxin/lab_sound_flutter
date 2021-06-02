import 'dart:io';
import 'package:lab_sound_flutter_example/demos/music-time.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:path_provider/path_provider.dart';

class RenderAudioPage extends StatefulWidget {
  @override
  _RenderAudioPageState createState() => _RenderAudioPageState();
}

class _RenderAudioPageState extends State<RenderAudioPage> {
  bool rendering = false;

  String statusText = 'Ready to go';

  Future<String> loadAsset(String path) async {
    final tempDir = await getTemporaryDirectory();
    final file = File(tempDir.path + '/' + path);
    await file.writeAsBytes(
        (await rootBundle.load('assets/' + path)).buffer.asUint8List());
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(statusText),
            if (!rendering)
              OutlinedButton(
                  child: Text("Start rendering"),
                  onPressed: () async {
                    setState(() {
                      rendering = true;
                      statusText = "Loading files";
                    });
                    final outputConfig = AudioStreamConfig(
                        desiredChannels: 2, desiredSampleRate: 44100.0);
                    final musicBus =
                        await AudioBus.async(await loadAsset('music3.mp3'));

                    setState(() {
                      statusText = "Rendering";
                    });

                    final audioContext = AudioContext.offline(
                        outputConfig: outputConfig,
                        duration: musicBus.duration);
                    final audioSample =
                        AudioSampleNode(audioContext, resource: musicBus);
                    final recorder = RecorderNode(audioContext);
                    final dynamicsCompressorNode = DynamicsCompressorNode(audioContext);

                    final oscillator = OscillatorNode(audioContext);
                    oscillator.start();
                    oscillator.amplitude.setValue(0.0);

                    dynamicsCompressorNode.connect(recorder);
                    oscillator.connect(dynamicsCompressorNode);
                    audioSample.connect(dynamicsCompressorNode);
                    audioSample.schedule();
                    int i = 0;
                    musicTime.forEach((time) {
                      final high = i++ % 4 == 0;
                      oscillator.frequency
                          .setValueAtTime(high ? 1760.0 : 880.0, time / 1000);
                      oscillator.amplitude
                          .setValueAtTime(high ? 0.8 : 0.6, time / 1000);
                      oscillator.amplitude
                          .linearRampToValueAtTime(0.0, time / 1000 + 0.1);
                    });

                    audioContext.addAutomaticPullNode(recorder);
                    recorder.startRecording();
                    await audioContext.startOfflineRendering();
                    recorder.stopRecording();
                    audioContext.removeAutomaticPullNode(recorder);

                    final tempDir = await getTemporaryDirectory();
                    final savePath = tempDir.path + '/test.wav';

                    recorder.writeRecordingToWav(savePath);
                    print("savePath: $savePath ");

                    OpenFile.open(savePath);

                    musicBus.dispose();
                    audioSample.dispose();
                    oscillator.dispose();
                    recorder.dispose();
                    audioContext.dispose();

                    setState(() {
                      rendering = false;
                      statusText = "Recorded";
                    });
                  }),
          ],
        ),
      ),
    );
  }
}
