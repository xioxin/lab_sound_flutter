// Simulating zelda music with Oscillator
// reference:
// https://codepen.io/gregh/post/recreating-legendary-8-bit-games-music-with-web-audio-api
// https://codepen.io/gregh/project/editor/aAexRX
// https://github.com/Tonejs/Tone.js

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:lab_sound_flutter_example/draw_time_domain.dart';

import 'zelda_data.dart';

const double A4 = 440;
final Map<String, int> noteToScaleIndex = {
  "cbb": -2, "cb": -1, "c": 0,  "c#": 1,  "cx": 2,
  "dbb": 0,  "db": 1,  "d": 2,  "d#": 3,  "dx": 4,
  "ebb": 2,  "eb": 3,  "e": 4,  "e#": 5,  "ex": 6,
  "fbb": 3,  "fb": 4,  "f": 5,  "f#": 6,  "fx": 7,
  "gbb": 5,  "gb": 6,  "g": 7,  "g#": 8,  "gx": 9,
  "abb": 7,  "ab": 8,  "a": 9,  "a#": 10, "ax": 11,
  "bbb": 9,  "bb": 10, "b": 11, "b#": 12, "bx": 13,
};

double noteFrequency(String note) {
  final RegExp noteRegExp = new RegExp(r"^([a-g](?:b|#|x|bb)?)(-?[0-9]+)", caseSensitive: false);
  final match = noteRegExp.firstMatch(note);
  if(match != null) {
    final index = noteToScaleIndex[(match[1] ?? '').toLowerCase()]!;
    final noteNumber = index + (int.parse(match[2] ?? '0') + 1) * 12;
    return A4 * pow(2, (noteNumber - 69) / 12);
  }
  return 0.0;
}



class Zelda extends StatefulWidget {
  @override
  _ZeldaState createState() => _ZeldaState();
}

class _ZeldaState extends State<Zelda> {
  late AudioContext ctx;
  late OscillatorNode triangle;
  late NoiseNode noise;
  late GainNode noiseGain;
  late OscillatorNode pulse;
  late OscillatorNode square;

  late AnalyserNode analyser1;
  late AnalyserNode analyser2;
  late AnalyserNode analyser3;
  late AnalyserNode analyser4;
  late AnalyserNode analyser5;

  late DynamicsCompressorNode dynamicsCompressor;


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

  init() {
    ctx = AudioContext();
    // final adsr = ADSRNode(ctx);
    // print("ADSRNode: ${adsr.attackLevel} ${adsr.attackTime} ${adsr.oneShot}");
    analyser1 = AnalyserNode(ctx);
    analyser2 = AnalyserNode(ctx);
    analyser3 = AnalyserNode(ctx);
    analyser4 = AnalyserNode(ctx);
    analyser5 = AnalyserNode(ctx);
    dynamicsCompressor = DynamicsCompressorNode(ctx);

    ctx.suspend();
    triangle = OscillatorNode(ctx);
    triangle.setType(OscillatorType.triangle);
    noise = NoiseNode(ctx);
    noiseGain = GainNode(ctx);
    noise.type = NoiseType.PINK;
    pulse = OscillatorNode(ctx);
    pulse.setType(OscillatorType.sawtooth);

    final List<double> pulseCurve = List.generate(256, (i) => 0.0);
    for(var i=0;i<128;i++) {
      pulseCurve[i]= -1.0;
      pulseCurve[i+128]=1.0;
    }

    final List<double> constantOneCurve= [0.5, 0.5];

    final pulseShaper = WaveShaperNode(ctx);
    pulseShaper.setCurve(pulseCurve);
    pulse.connect(pulseShaper);

    final constantOneShaper= WaveShaperNode(ctx);
    constantOneShaper.setCurve(constantOneCurve);
    pulse.connect(constantOneShaper);

    constantOneShaper.connect(pulseShaper);

    // pulseShaper.connect(ctx.device);

    square = OscillatorNode(ctx);
    square.setType(OscillatorType.square);

    square >> analyser1 >> dynamicsCompressor;
    pulseShaper >> analyser2 >> dynamicsCompressor;
    triangle >> analyser3 >> dynamicsCompressor;
    noise >> noiseGain >> analyser4 >> dynamicsCompressor;

    dynamicsCompressor >> analyser5 >> ctx.device;
  }

  play() {

    zeldaBass1.forEach((element) { addPlan(triangle, element); });
    zeldaBass2.forEach((element) { addPlan(noiseGain, element); });
    zeldaSynth1.forEach((element) { addPlan(pulse, element); });
    zeldaSynth2.forEach((element) { addPlan(square, element); });

    noiseGain.gain.setValue(0);
    noiseGain.gain.resetSmoothedValue();
    triangle.amplitude.setValue(0);
    triangle.amplitude.resetSmoothedValue();
    triangle.start();
    pulse.amplitude.setValue(0);
    pulse.amplitude.resetSmoothedValue();
    pulse.start();
    square.amplitude.setValue(0);
    square.amplitude.resetSmoothedValue();
    square.start();
    noise.start();
    ctx.resume();
  }

  stop() {
    triangle.stop();
    pulse.stop();
    square.stop();
    noise.stop();

    noiseGain.reset();
    triangle.reset();
    pulse.reset();
    square.reset();
    noise.reset();
    ctx.suspend();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zelda'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 100,
            child: DrawTimeDomain(analyser1),
          ),
          Container(
            height: 100,
            child: DrawTimeDomain(analyser2),
          ),
          Container(
            height: 100,
            child: DrawTimeDomain(analyser3),
          ),
          Container(
            height: 100,
            child: DrawTimeDomain(analyser4),
          ),
          Container(
            height: 100,
            child: DrawTimeDomain(analyser5),
          ),
          TextButton(onPressed: play, child: Text('Play')),
          TextButton(onPressed: stop, child: Text('Stop')),
        ],
      )
    );
  }
}



void play() {
  final ctx = AudioContext();
  ctx.suspend();
  final triangle = OscillatorNode(ctx);
  triangle.setType(OscillatorType.triangle);

  final noise = NoiseNode(ctx);
  final noiseGain = GainNode(ctx);

  noise.type = NoiseType.BROWN;


  // todo bass2 Add noise generator
  // todo PulseOscillator https://github.com/pendragon-andyh/WebAudio-PulseOscillator
  // todo Add ADSR
  // final pulse = OscillatorNode(ctx);
  // pulse.setType(OscillatorType.SQUARE);

  final pulse = PolyBLEPNode(ctx);
  pulse.type = PolyBLEPType.TRIANGULAR_PULSE;

  final square = OscillatorNode(ctx);
  square.setType(OscillatorType.square);

  noise.connect(noiseGain);
  noiseGain.connect(ctx.device);
  triangle.connect(ctx.device);
  pulse.connect(ctx.device);
  square.connect(ctx.device);

  zeldaBass1.forEach((element) { addPlan(triangle, element); });
  zeldaBass2.forEach((element) { addPlan(noiseGain, element); });
  zeldaSynth1.forEach((element) { addPlan(pulse, element); });
  zeldaSynth2.forEach((element) { addPlan(square, element); });

  noiseGain.gain.setValue(0);
  noiseGain.gain.resetSmoothedValue();

  triangle.amplitude.setValue(0);
  triangle.amplitude.resetSmoothedValue();
  triangle.start();
  pulse.amplitude.setValue(0);
  pulse.amplitude.resetSmoothedValue();
  pulse.start();
  square.amplitude.setValue(0);
  square.amplitude.resetSmoothedValue();
  square.start();
  noise.start();
  ctx.resume();
}

addPlan(AudioNode node, dynamic data) {
  final duration = safeDouble(data["duration"]);
  final time = safeDouble(data["time"]);
  final velocity = safeDouble(data["velocity"]);
  // todo Is velocity being used correctly?

  if(node is OscillatorNode) {
    final name = data["name"] as String;
    final hz = noteFrequency(name);
    node.frequency.setValueAtTime(hz, time);
    node.amplitude.setValueAtTime(velocity, time);
    node.amplitude.setValueAtTime(0.0, time + duration);
  } else if(node is PolyBLEPNode) {
    final name = data["name"] as String;
    final hz = noteFrequency(name);
    node.frequency.setValueAtTime(hz, time);
    node.amplitude.setValueAtTime(velocity, time);
    node.amplitude.setValueAtTime(0.0, time + duration);
  } else if(node is GainNode) {
    node.gain.setValueAtTime(velocity, time);
    node.gain.setValueAtTime(0.0, time + duration);
  }
}

double safeDouble (dynamic val) {
  if(val is double) return val;
  if(val is int) return val.toDouble();
  return 0.0;
}