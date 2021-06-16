import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:path_provider/path_provider.dart';

List<AudioStreamConfig?> getDefaultAudioDeviceConfiguration(
    [bool withInput = false]) {
  final audioDevices = Lab.makeAudioDeviceList();
  final defaultOutputDevice = Lab.getDefaultOutputAudioDeviceIndex();
  final defaultInputDevice = Lab.getDefaultInputAudioDeviceIndex();

  AudioStreamConfig? inputConfig;
  AudioStreamConfig? outputConfig;

  AudioDeviceInfo? defaultOutputInfo, defaultInputInfo;

  for (final info in audioDevices) {
    if (info.index == defaultOutputDevice.index)
      defaultOutputInfo = info;
    else if (info.index == defaultInputDevice.index) defaultInputInfo = info;
  }
  if (defaultOutputInfo != null && defaultOutputInfo.index != -1) {
    outputConfig = AudioStreamConfig(
        deviceIndex: defaultOutputInfo.index,
        desiredChannels: min(2, defaultOutputInfo.numOutputChannels!),
        desiredSampleRate: defaultOutputInfo.nominalSampleRate!);
  }

  if (withInput) {
    if (defaultInputInfo != null && defaultInputInfo.index != -1) {
      inputConfig = AudioStreamConfig(
          deviceIndex: defaultInputInfo.index,
          desiredChannels: min(1, defaultInputInfo.numOutputChannels!),
          desiredSampleRate: defaultInputInfo.nominalSampleRate!);
    } else {
      throw ArgumentError(
          "the default audio input device was requested but none were found");
    }
  }
  return [inputConfig, outputConfig];
}


Future<AudioBus> makeBusFromSampleFile(String path) async{
  final tempDir = await getTemporaryDirectory();
  final file = File(tempDir.path + '/' + path);
  await file.writeAsBytes(
      (await rootBundle.load('assets/' + path)).buffer.asUint8List());
  return await AudioBus.fromFile(file.path);
}


class ExSimple {
  play() async {
    final defaultAudioDeviceConfigurations =
        getDefaultAudioDeviceConfiguration();
    final context = AudioContext(
        outputConfig: defaultAudioDeviceConfigurations.last,
        inputConfig: defaultAudioDeviceConfigurations.first);
    final musicClip = await makeBusFromSampleFile("stereo-music-clip.wav");

    final oscillator = OscillatorNode(context);
    final musicClipNode = AudioSampleNode(context);
    final gain = GainNode(context);
    gain.gain.setValue(0.5);
    musicClipNode.setBus(musicClip);
    context.connect(context.device, musicClipNode);
    musicClipNode.schedule(relativeWhen: 0);
    context.connect(gain, oscillator);
    context.connect(context.device, gain);

    oscillator.frequency.setValue(440);
    oscillator.setType(OscillatorType.sine);
    oscillator.start(when: 0);

    await Future.delayed(Duration(seconds: 6));

    context.dispose();
  }
}

class ExSimple2 {
  play() async {
    final defaultAudioDeviceConfigurations =
    getDefaultAudioDeviceConfiguration();
    final context = AudioContext(
        outputConfig: defaultAudioDeviceConfigurations.last,
        inputConfig: defaultAudioDeviceConfigurations.first);
    final musicClip = await makeBusFromSampleFile("stereo-music-clip.wav");

    final oscillator = OscillatorNode(context);
    final musicClipNode = AudioSampleNode(context);
    final gain = GainNode(context);
    gain.gain.value = 0.5;
    musicClipNode.setBus(musicClip);
    musicClipNode.connect(context.device);
    musicClipNode.schedule(relativeWhen: 0);
    oscillator.connect(gain);
    gain.connect(context.device);

    oscillator.frequency.value = 440;
    oscillator.type = OscillatorType.sine;
    oscillator.start(when: 0);

    await Future.delayed(Duration(seconds: 6));

    context.dispose();
  }
}

