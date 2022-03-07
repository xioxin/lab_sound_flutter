import '../generated_bindings.dart' as bind;
import 'lab_sound.dart';

class AudioStreamConfig {
  final bind.AudioStreamConfig ffiValue;

  AudioStreamConfig(
      {int deviceIndex = 0,
      int desiredChannels = 0,
      double desiredSampleRate = 0.0})
      : ffiValue = LabSound().createAudioStreamConfig(
            deviceIndex, desiredChannels, desiredSampleRate);

  AudioStreamConfig.value(bind.AudioStreamConfig value) : ffiValue = value;

  // static defaultInput() => AudioStreamConfig.value(LabSound().labSound_GetDefaultInputAudioDeviceConfiguration());
  // static defaultOutput() => AudioStreamConfig.value(LabSound().labSound_GetDefaultOutputAudioDeviceConfiguration());

  int get deviceIndex => ffiValue.device_index;

  double get desiredSampleRate => ffiValue.desired_samplerate;

  int get desiredChannels => ffiValue.desired_channels;

  static disable() => AudioStreamConfig(deviceIndex: -1);

  @override
  String toString() =>
      "AudioStreamConfig<$deviceIndex, $desiredChannels, $desiredSampleRate>";
}
