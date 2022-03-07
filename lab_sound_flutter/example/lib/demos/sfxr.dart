import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:lab_sound_inspector/lab_sound_inspector.dart';

class Sfxr extends StatefulWidget {
  @override
  State<Sfxr> createState() => _SfxrState();
}

class _SfxrState extends State<Sfxr> {
  late AudioContext ctx;
  late SfxrNode sfxr;
  late AnalyserNode analyser;

  Widget audioParamWidget(String name, AudioParam param, {double step = 1}) {
    final safeValue = max(param.minValue, min(param.maxValue, param.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name +
            ": ${param.value.toStringAsFixed(2)} (Range:${param.minValue.toStringAsFixed(2)} - ${param.maxValue.toStringAsFixed(2)})"),
        Row(
          children: [
            TextButton(
                onPressed: () {
                  setState(() {
                    param.setValue(param.value - step);
                  });
                },
                child: Text('-')),
            Slider(
                value: safeValue,
                min: param.minValue,
                max: param.maxValue,
                onChanged: (val) {
                  setState(() {
                    param.setValue(val);
                  });
                }),
            TextButton(
                onPressed: () {
                  setState(() {
                    param.setValue(param.value + step);
                  });
                },
                child: Text('+')),
          ],
        )
      ],
    );
  }

  @override
  void initState() {
    ctx = AudioContext();
    sfxr = SfxrNode(ctx);
    analyser = AnalyserNode(ctx);
    // sfxr.connect(analyser);
    // analyser.connect(ctx.destination);

    sfxr >> analyser >> ctx.destination;

    super.initState();
  }

  @override
  void dispose() {
    ctx.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DebugScaffold(
        child: Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    audioParamWidget("attackTime", sfxr.attackTime),
                    audioParamWidget("sustainTime", sfxr.sustainTime),
                    audioParamWidget("sustainPunch", sfxr.sustainPunch),
                    audioParamWidget("decayTime", sfxr.decayTime),
                    audioParamWidget("startFrequency", sfxr.startFrequency),
                    audioParamWidget("minFrequency", sfxr.minFrequency),
                    audioParamWidget("slide", sfxr.slide),
                    audioParamWidget("deltaSlide", sfxr.deltaSlide),
                    audioParamWidget("vibratoDepth", sfxr.vibratoDepth),
                    audioParamWidget("vibratoSpeed", sfxr.vibratoSpeed),
                    audioParamWidget("changeAmount", sfxr.changeAmount),
                    audioParamWidget("changeSpeed", sfxr.changeSpeed),
                    audioParamWidget("squareDuty", sfxr.squareDuty),
                    audioParamWidget("dutySweep", sfxr.dutySweep),
                    audioParamWidget("repeatSpeed", sfxr.repeatSpeed),
                    audioParamWidget("phaserOffset", sfxr.phaserOffset),
                    audioParamWidget("phaserSweep", sfxr.phaserSweep),
                    audioParamWidget("lpFilterCutoff", sfxr.lpFilterCutoff),
                    audioParamWidget(
                        "lpFilterCutoffSweep", sfxr.lpFilterCutoffSweep),
                    audioParamWidget("lpFiterResonance", sfxr.lpFiterResonance),
                    audioParamWidget("hpFilterCutoff", sfxr.hpFilterCutoff),
                    audioParamWidget(
                        "hpFilterCutoffSweep", sfxr.hpFilterCutoffSweep),
                  ],
                ),
              ),
            ),
          ),
          Divider(height: 1),
          Wrap(children: [
            TextButton(
                child: Text("setDefaultBeep"),
                onPressed: () => setState(sfxr.setDefaultBeep)),
            TextButton(
                child: Text("coin"), onPressed: () => setState(sfxr.coin)),
            TextButton(
                child: Text("laser"), onPressed: () => setState(sfxr.laser)),
            TextButton(
                child: Text("explosion"),
                onPressed: () => setState(sfxr.explosion)),
            TextButton(child: Text("hit"), onPressed: () => setState(sfxr.hit)),
            TextButton(
                child: Text("powerUp"),
                onPressed: () => setState(sfxr.powerUp)),
            TextButton(child: Text("hit"), onPressed: () => setState(sfxr.hit)),
            TextButton(
                child: Text("jump"), onPressed: () => setState(sfxr.jump)),
            TextButton(
                child: Text("select"), onPressed: () => setState(sfxr.select)),
            TextButton(
                child: Text("mutate"), onPressed: () => setState(sfxr.mutate)),
            TextButton(
                child: Text("randomize"),
                onPressed: () => setState(sfxr.randomize)),
          ]),
          Wrap(children: [
            IconButton(
                icon: Icon(Icons.play_circle_fill), onPressed: sfxr.start),
          ])
        ],
      ),
    ));
  }
}
