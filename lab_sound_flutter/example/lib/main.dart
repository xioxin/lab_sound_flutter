import 'package:flutter/material.dart';

import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:lab_sound_flutter_example/demos/dial.dart';
import 'package:lab_sound_flutter_example/demos/recorder.dart';
import 'package:lab_sound_flutter_example/demos/zelda.dart' as zelda;

import 'demos/audio_device.dart';
import 'demos/render-audio.dart';
import 'demos/wave_form.dart';
import 'demos/zelda.dart';
import 'labsound/ex_simple.dart';
import 'labsound/labsound_examples.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: [
            IconButton(
                onPressed: () {
                  LabSound().printSurvivingNodes();
                },
                icon: Icon(Icons.bug_report))
          ],
        ),
        body: ListView(
          children: [
            ListTile(
                title: Text("Dialpad"),
                subtitle: Text("OscillatorNode Demo"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dial()),
                  );
                }),
            ListTile(
                title: Text("Render Demo"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RenderAudioPage()),
                  );
                }),
            ListTile(
                title: Text("Microphone recorder"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Recorder()),
                  );
                }),
            ListTile(
                title: Text("zelda"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Zelda()),
                  );
                }),
            ListTile(
                title: Text("LabSoundExamples"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LabSoundExamples()),
                  );
                }),

            ListTile(
                title: Text("Print device"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AudioDeviceList()),
                  );
                }),
            ListTile(
                title: Text("WaveFormPage"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WaveFormPage()),
                  );
                })
          ],
        ));
  }
}
