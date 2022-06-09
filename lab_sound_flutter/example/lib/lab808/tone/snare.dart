import 'dart:async';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:lab_sound_flutter_example/lab808/tone/tone.dart';

class Snare extends Tone {

  @override
  String get name => "Snare";


  Snare(AudioContext context, AudioNode destination): super(context, destination);

  @override
  trigger(double time) {
    final noise = NoiseNode(context);
    final noiseFilter = context.createBiquadFilter();
    noiseFilter.type = FilterType.highPass;
    noiseFilter.frequency.value = 1000;
    noise.connect(noiseFilter);
    final noiseEnvelope = context.createGain();
    noiseFilter.connect(noiseEnvelope);
    noiseEnvelope.connect(destination);

    final osc = context.createOscillator();
    osc.type = OscillatorType.triangle;

    final oscEnvelope = context.createGain();
    osc.connect(oscEnvelope);
    oscEnvelope.connect(destination);

    noiseEnvelope.gain.setValueAtTime(1, time);
    noiseEnvelope.gain.exponentialRampToValueAtTime(0.01, time + 0.2);
    noise.start(time);

    osc.frequency.setValueAtTime(100, time);
    oscEnvelope.gain.setValueAtTime(0.7, time);
    oscEnvelope.gain.exponentialRampToValueAtTime(0.01, time + 0.1);
    osc.start(time);

    osc.stop(time + 0.2);
    noise.stop(time + 0.2);
  }
}