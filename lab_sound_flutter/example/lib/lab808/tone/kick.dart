import 'dart:async';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:lab_sound_flutter_example/lab808/tone/tone.dart';

class Kick extends Tone {
  @override
  String get name => "Kick";

  Kick(AudioContext context, AudioNode destination): super(context, destination);

  @override
  trigger(double time) {
    final osc = context.createOscillator();
    final gain = context.createGain();
    osc.connect(gain);
    gain.connect(destination);
    osc.frequency.setValueAtTime(150, time);
    gain.gain.setValueAtTime(1, time);
    osc.frequency.exponentialRampToValueAtTime(0.01, time + 0.5);
    gain.gain.exponentialRampToValueAtTime(0.01, time + 0.5);
    osc.start(time);
    osc.stop(time + 0.5);
    Timer(Duration(seconds: 1), () {
      osc.dispose();
      gain.dispose();
    });
  }
}