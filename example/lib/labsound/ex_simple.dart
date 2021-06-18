import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';


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

class ExOscPop {
  play() async {
    final defaultAudioDeviceConfigurations =
    getDefaultAudioDeviceConfiguration();
    final context = AudioContext(
        outputConfig: defaultAudioDeviceConfigurations.last,
        inputConfig: defaultAudioDeviceConfigurations.first);

    final oscillator = OscillatorNode(context);
    final recorder = RecorderNode.fromConfig(context, defaultAudioDeviceConfigurations.last!);
    final gain = GainNode(context);

    gain.gain.value = 1;
    oscillator.connect(gain);
    gain.connect(context.device);

    oscillator.frequency.value = 1000;
    oscillator.type = OscillatorType.sine;
    context.addAutomaticPullNode(recorder);
    recorder.startRecording();
    gain.connect(recorder);

    for (double i = 0; i < 5.0; i += 1.0)
    {
      oscillator.start(when: 0);
      oscillator.stop(when: 0.5);
      await Future.delayed(Duration(seconds: 1));
    }

    recorder.stopRecording();
    context.removeAutomaticPullNode(recorder);

    final tempDir = await getTemporaryDirectory();
    final file = File(tempDir.path + '/ex_osc_pop.wav');
    if(file.existsSync()) file.deleteSync();

    recorder.writeRecordingToWav(file.path);
    context.disconnectCompletely(context.device);
    await Future.delayed(Duration(milliseconds: 100));
    context.dispose();
  }
}


class ExPlaybackEvents {
  play() async {
    final defaultAudioDeviceConfigurations =
    getDefaultAudioDeviceConfiguration();
    final context = AudioContext(
        outputConfig: defaultAudioDeviceConfigurations.last,
        inputConfig: defaultAudioDeviceConfigurations.first);

    final musicClip = await makeBusFromSampleFile("stereo-music-clip.wav");

    final sampledAudio = AudioSampleNode(context);
    sampledAudio.setBus(musicClip);
    sampledAudio.connect(context.device);
    sampledAudio.schedule(relativeWhen: 0);

    sampledAudio.onEnded.listen((event) {
      print("sampledAudio finished...");
    });
    sampledAudio.schedule(relativeWhen: 0.0);
    await Future.delayed(Duration(seconds: 6));
    context.dispose();
  }
}


class ExOfflineRendering {
  play() async {

    final offlineConfig = AudioStreamConfig(deviceIndex: 0, desiredSampleRate: 48000, desiredChannels: 2);
    final double recordingTimeMs = 1000;

    final context = AudioContext.offline(outputConfig: offlineConfig);

    final oscillator = OscillatorNode(context);
    final musicClip = await makeBusFromSampleFile("stereo-music-clip.wav");
    final musicClipNode = AudioSampleNode(context);
    final gain = GainNode(context);

    final recorder = RecorderNode.fromConfig(context, offlineConfig);

    context.addAutomaticPullNode(recorder);

    recorder.startRecording();

    gain.gain.value = 0.125;

    oscillator.connect(gain);
    gain.connect(recorder);

    oscillator.frequency.value = 880;
    oscillator.type = OscillatorType.sine;
    oscillator.start();

    musicClipNode.connect(recorder);
    musicClipNode.setBus(musicClip);
    musicClipNode.schedule();

    await context.startOfflineRendering();

    recorder.stopRecording();
    context.removeAutomaticPullNode(recorder);


    final tempDir = await getTemporaryDirectory();
    final file = File(tempDir.path + '/ex_osc_pop.wav');
    if(file.existsSync()) file.deleteSync();

    recorder.writeRecordingToWav(file.path);

    OpenFile.open(file.path);

    context.dispose();
  }
}

// This demonstrates the use of `connectParam` as a way of modulating one node through another.
// Params are effectively control signals that operate at audio rate.
class ExTremolo {
  play() async {
    final defaultAudioDeviceConfigurations =
    getDefaultAudioDeviceConfiguration();
    final context = AudioContext(
        outputConfig: defaultAudioDeviceConfigurations.last,
        inputConfig: defaultAudioDeviceConfigurations.first);
    final modulator = OscillatorNode(context);
    final modulatorGain = GainNode(context);
    final osc = OscillatorNode(context);

    modulator.type = OscillatorType.sine;
    modulator.frequency.value = 8;
    modulator.start();

    modulatorGain.gain.value = 10;

    osc.type = OscillatorType.triangle;
    osc.frequency.value = 440;
    osc.start();

    context.connect(modulatorGain, modulator);
    context.connectParam(osc.detune, modulatorGain);
    context.connect(context.device, osc);

    await Future.delayed(Duration(seconds: 6));
    context.dispose();
  }
}


class ExFrequencyModulation {
  play() async {
    final defaultAudioDeviceConfigurations =
    getDefaultAudioDeviceConfiguration();
    final context = AudioContext(
        outputConfig: defaultAudioDeviceConfigurations.last,
        inputConfig: defaultAudioDeviceConfigurations.first);

    final modulator = OscillatorNode(context);
    final modulatorGain = GainNode(context);
    final osc = OscillatorNode(context);
    final trigger = ADSRNode(context);

    final signalGain = GainNode(context);
    final feedbackTap = GainNode(context);
    final chainDelay = DelayNode(context);


    modulator.type = OscillatorType.square;
    modulator.start();

    osc.type = OscillatorType.square;
    osc.frequency.value = 300;
    osc.start();

    signalGain.gain.value = 1;
    feedbackTap.gain.value = 0.5;

    chainDelay.delayTime.value = 0;


    // todo: connectParam miss;

  }
}

// In most examples, nodes are not disconnected during playback. This sample shows how nodes
// can be arbitrarily connected/disconnected during runtime while the graph is live.
class ExRuntimeGraphUpdate {
  play() async {

  }
}
