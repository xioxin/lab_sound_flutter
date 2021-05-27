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
  AudioContext audioContext = AudioContext();
  late OscillatorNode oscillatorHigh;
  late OscillatorNode oscillatorLow;
  late AnalyserNode analyserNode;

  Map<double, OscillatorNode> oscillatorMap = {};

  @override
  void initState() {
    analyserNode = AnalyserNode(audioContext);
    analyserNode.connect(audioContext.destination);
    [...xHz, ...yHz].forEach((hz) {
      oscillatorMap[hz] = OscillatorNode(audioContext);
      oscillatorMap[hz]!.frequency.setValue(hz);
      oscillatorMap[hz]!.frequency.resetSmoothedValue();
      oscillatorMap[hz]!.connect(analyserNode);
    });
    super.initState();
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
    return Flexible(
      flex: 1,
      child: GestureDetector(
          onTapDown: (TapDownDetails details) {
            print('onTapDown');
            oscillatorMap[yHz[y]]!.start();
            oscillatorMap[xHz[x]]!.start();
          },
          onTapCancel: () {
            print('onTapCancel');
            oscillatorMap.values.forEach((e) { e.stop(); });
          },
          onTapUp: (TapUpDetails details) {
            print('onTapUp');
            oscillatorMap.values.forEach((e) { e.stop(); });
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
