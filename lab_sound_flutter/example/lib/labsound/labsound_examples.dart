import 'package:flutter/material.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';

import 'ex_simple.dart';

class LabSoundExamples extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('LabSound example app'),
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
                title: Text("ExSimple"),
                onTap: () {
                  ExSimple().play();
                }),
            ListTile(
                title: Text("ExOscPop"),
                onTap: () {
                  ExOscPop().play();
                }),
            ListTile(
                title: Text("ExPlaybackEvents"),
                onTap: () {
                  ExPlaybackEvents().play();
                }),
            ListTile(
                title: Text("ExOfflineRendering"),
                onTap: () {
                  ExOfflineRendering().play();
                }),
            ListTile(
                title: Text("ExTremolo"),
                onTap: () {
                  ExTremolo().play();
                }),
            ListTile(
                title: Text("ExFrequencyModulation"),
                onTap: () {
                  ExFrequencyModulation().play();
                }),
            ListTile(
                title: Text("ExRuntimeGraphUpdate"),
                onTap: () {
                  ExRuntimeGraphUpdate().play();
                }),
            ListTile(
                title: Text("ExMicrophoneLoopback"),
                onTap: () {
                  ExMicrophoneLoopback().play();
                }),
            ListTile(
                title: Text("ExMicrophone"),
                onTap: () {
                  ExMicrophone().play();
                }),
            ListTile(
                title: Text("ExRedalertSynthesis"),
                onTap: () {
                  RedalertSynthesis().play();
                }),
          ],
        ));
  }
}
