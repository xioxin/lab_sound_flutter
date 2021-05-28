import 'package:lab_sound_flutter/lab_sound/lab.dart';

import '../generated_bindings.dart' as bind;

class AudioStreamConfig {
  final bind.AudioStreamConfig ffiValue;

  AudioStreamConfig({int deviceIndex = -1, int desiredChannels = 0, double desiredSampleRate = 0.0 }): ffiValue = LabSound().createAudioStreamConfig(deviceIndex, desiredChannels, desiredSampleRate);

  AudioStreamConfig.value(bind.AudioStreamConfig value): ffiValue = value;

  int get deviceIndex => ffiValue.device_index;

  double get desiredSampleRate => ffiValue.desired_samplerate;

  int get desiredChannels => ffiValue.desired_channels;

  @override
  String toString() => "AudioStreamConfig<${deviceIndex}, ${desiredChannels}, ${desiredSampleRate}>";

}