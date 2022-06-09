import 'dart:async';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:lab_sound_flutter_example/lab808/tone/tone.dart';

class HiHet extends Tone {
  @override
  String get name => "HiHet";

  HiHet(AudioContext context, AudioNode destination): super(context, destination);

  @override
  trigger(double when) {

    final double fundamental = 40;
    final List<double> ratios = [2, 3, 4.16, 5.43, 6.79, 8.21];

    var gain = context.createGain();

    // Bandpass
    var bandpass = context.createBiquadFilter();
    bandpass.type = FilterType.bandpass;
    bandpass.frequency.value = 10000;

    // Highpass
    var highpass = context.createBiquadFilter();
    highpass.type = FilterType.highPass;
    highpass.frequency.value = 7000;

    // Connect the graph
    bandpass.connect(highpass);
    highpass.connect(gain);
    gain.connect(destination);

    // Create the oscillators
    ratios.forEach((ratio) {
      final osc = context.createOscillator();
      osc.type = OscillatorType.square;
      // Frequency is the fundamental * this oscillator's ratio
      osc.frequency.value = fundamental * ratio;
      osc.connect(bandpass);
      osc.start(when);
      osc.stop(when + 0.3);
    });

    // Define the volume envelope
    gain.gain.setValueAtTime(0.00001, when);
    gain.gain.exponentialRampToValueAtTime(1, when + 0.02);
    gain.gain.exponentialRampToValueAtTime(0.3, when + 0.03);
    gain.gain.exponentialRampToValueAtTime(0.00001, when + 0.3);

  }

}