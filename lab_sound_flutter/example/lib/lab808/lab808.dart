import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:lab_sound_flutter_example/lab808/tone/hi-hat.dart';
import 'package:lab_sound_flutter_example/lab808/tone/kick.dart';
import 'package:lab_sound_flutter_example/lab808/tone/snare.dart';
import 'package:lab_sound_flutter_example/lab808/tone/tone.dart';
import 'package:lab_sound_inspector/lab_sound_inspector.dart';
import 'package:path_provider/path_provider.dart';

import 'tone/test.dart';

class Lab808 extends StatefulWidget {
  @override
  _Lab808State createState() => _Lab808State();
}

class _Lab808State extends State<Lab808> {
  AudioContext audioContext = AudioContext();
  AnalyserNode? analyserNode;
  AudioNode get destination => analyserNode!;

  @override
  void initState() {
    analyserNode = AnalyserNode(audioContext);
    analyserNode!.connect(audioContext.destination);
    tones.add(Test(audioContext, destination));
    tones.add(Kick(audioContext, destination));
    tones.add(Snare(audioContext, destination));
    tones.add(HiHet(audioContext, destination));

    super.initState();
  }

  List<Tone> tones = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Strike pad'),
      ),
      body: ListView(
        children: [
          if(analyserNode != null)Container(height: 50, child: DrawTimeDomain(analyserNode!)),
          if(analyserNode != null)Container(height: 200, child: DrawFrequency(analyserNode!)),
          for(final tone in tones) GestureDetector(
            onPanDown: (details) {
              tone.trigger(audioContext.currentTime);
            },
            child: Container(
              margin: EdgeInsets.all(4),
              width: 200,
              height: 100,
              color: Colors.blueGrey,
              child: Center(child: Text(tone.name)),
            ),
          ),

        ],
      ),
    );
  }
}
