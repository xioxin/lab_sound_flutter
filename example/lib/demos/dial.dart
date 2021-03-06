import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';

import '../draw_frequency.dart';
import '../draw_time_domain.dart';

class Dial extends StatefulWidget {
  @override
  _DialState createState() => _DialState();
}

class _DialState extends State<Dial> {
  late AudioContext audioContext;
  late AnalyserNode analyserNode;
  late DynamicsCompressorNode dynamicsCompressorNode;
  Map<double, OscillatorNode> oscillatorMap = {};

  @override
  void initState() {
    audioContext = AudioContext();
    analyserNode = AnalyserNode(audioContext);
    dynamicsCompressorNode = DynamicsCompressorNode(audioContext);
    dynamicsCompressorNode.connect(analyserNode);
    analyserNode.connect(audioContext.destination);
    super.initState();
  }

  @override
  void dispose() {
    audioContext.dispose();
    super.dispose();
  }

  List<double> xHz = [1209, 1336, 1477, 1633];
  List<double> yHz = [697, 770, 852, 941];
  List<List<String>> buttons = [
    ['1', '2', '3', 'A'],
    ['4', '5', '6', 'B'],
    ['7', '8', '9', 'C'],
    ['*', '0', '#', 'D'],
  ];

  Widget button(String name, int x, int y) {

    OscillatorNode? oscillatorLow;
    OscillatorNode? oscillatorHigh;

    return Flexible(
      flex: 1,
      child: GestureDetector(
          onTapDown: (TapDownDetails details) {
            oscillatorLow = OscillatorNode(audioContext);
            oscillatorLow?.frequency.setValue(xHz[x]);
            oscillatorLow?.frequency.resetSmoothedValue();
            oscillatorLow?.connect(dynamicsCompressorNode);
            oscillatorLow?.start();
            oscillatorHigh = OscillatorNode(audioContext);
            oscillatorHigh?.frequency.setValue(yHz[y]);
            oscillatorHigh?.frequency.resetSmoothedValue();
            oscillatorHigh?.connect(dynamicsCompressorNode);
            oscillatorHigh?.start();
          },
          onTapCancel: () {
            oscillatorLow?.stop();
            oscillatorLow?.dispose();
            oscillatorHigh?.stop();
            oscillatorHigh?.dispose();
          },
          onTapUp: (TapUpDetails details) {
            oscillatorLow?.stop();
            oscillatorLow?.dispose();
            oscillatorHigh?.stop();
            oscillatorHigh?.dispose();
          },
          child: AspectRatio(
              aspectRatio: 1.0,
              child: RawMaterialButton(
                  onPressed: () {}, child: Center(child: Text(name))))),
    );
  }

  @override
  Widget build(BuildContext context) {
    int y = 0;

    List<Widget> buttonWidgets = [];
    buttons.forEach((element) {
      List<Widget> buttonLine = [];
      int x = 0;
      element.forEach((name) {
        buttonLine.add(button(name, x, y));
        x++;
      });
      buttonWidgets.add(
        Row(
          children: buttonLine,
        )
      );
      y++;
    });


    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 50, child: DrawTimeDomain(analyserNode)),
          Container(height: 200, child: DrawFrequency(analyserNode)),
          ...buttonWidgets,
        ],
      ),
    );
  }
}
