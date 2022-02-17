import 'dart:ffi';
import 'dart:io';

import 'package:lab_sound_ffi/lab_sound_ffi.dart';

void main() async {

  // Get the binary library and store it in the pwd directory.
  // if you are a flutter project please use lab_sound_flutter, which already contains the binary library
  // https://github.com/xioxin/lab_sound_bridge
  // Actions -> Select latest workflow -> Artifacts -> Download the platform you need
  // You can also compile your own.
  // reference: https://github.com/xioxin/lab_sound_bridge/blob/main/.github/workflows/cmake.yml


  // Override DynamicLibrary load.
  // LabSound is a lazy-loading singleton class, You need to make the changes before executing the other methods.
  LabSound.overrideDynamicLibrary(() => DynamicLibrary.open("LabSoundBridge.framework/LabSoundBridge"), OperatingSystem.macOS);

  final context = AudioContext();

  final musicClip = await AudioBus.fromFile('./assets/stereo-music-clip.wav');
  final musicClipNode = AudioSampleNode(context);
  musicClipNode.setBus(musicClip);
  context.connect(context.device, musicClipNode);
  musicClipNode.start();

  musicClipNode.onEnded.listen((event) {
    musicClipNode.dispose();
    context.dispose();
    musicClip.dispose();
  });

}
