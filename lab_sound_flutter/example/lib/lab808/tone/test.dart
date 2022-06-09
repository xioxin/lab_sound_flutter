import 'dart:async';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:lab_sound_flutter_example/lab808/tone/tone.dart';

class Test extends Tone {

  @override
  String get name => "TEST";

  Test(AudioContext context, AudioNode destination): super(context, destination);

  @override
  trigger(double time) {
    final osc = context.createOscillator();
    final adsr = ADSRNode(context);
    adsr.set(0.1, 1, 0.1, 0, 0.5, 0.5);
    final gain = context.createGain();
    osc.connect(gain);
    gain.connect(destination);
    osc.start(time);
    adsr.connectParam(gain.gain);

    osc.frequency.setValueAtTime(150, time);
    adsr.gate.setValueAtTime(1, time);
    adsr.gate.setValueAtTime(0, time + 0.01);

    Timer(Duration(seconds: 1), () {
      osc.dispose();
      gain.dispose();
    });
  }
}