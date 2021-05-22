import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as p;
import 'lab_sound.dart';
import '../extensions/ffi_string.dart';


class AudioContext {
  final Pointer<Int32> pointer;
  final double initSampleRate;
  final int channels;
  final bool offline;

  // double get correctionRate => initSampleRate / 24000.0;

  double correctionTime(double time) {
    // return time * correctionRate;
    return time;
  }

  AudioContext(
      {this.offline = false, this.initSampleRate = 24000.0, this.channels = 2, double? timeMills})
      : pointer = (offline
            ? LabSound().createOfflineAudioContext(channels, initSampleRate, timeMills!)
            : LabSound().createRealtimeAudioContext(channels, initSampleRate));

  double get currentTime {
    // return lab.currentTime(this.pointer) / correctionRate;
    return LabSound().AudioContext_currentTime(this.pointer);
  }

  double get predictedCurrentTime => LabSound().AudioContext_predictedCurrentTime(this.pointer);

  double get sampleRate {
    return LabSound().AudioContext_sampleRate(this.pointer);
  }

  int get currentSampleFrame {
    return LabSound().AudioContext_currentSampleFrame(this.pointer);
  }

  connect(AudioNode dst, AudioNode src) {
    LabSound().AudioContext_connect(this.pointer, dst.nodeId, src.nodeId);
  }

  disconnect(AudioNode dst, AudioNode src) {
    LabSound().AudioContext_disconnect(this.pointer, dst.nodeId, src.nodeId);
  }

  static AudioBus decodeAudioFile(String path, {audoDispose = true}) {
    return AudioBus(path, autoDispose: audoDispose);
  }

  // static Future<AudioBus> decodeAudioFileAsync(String path, {autoDispose = true, String? debugName}) {
  //   final bus = AudioBus.async(path, autoDispose: autoDispose);
  //   bus.debugName = debugName ?? p.basename(path);
  //   return bus.complete!;
  // }

  // static AudioBus decodeAudioFileAsyncNoWait(String path, {autoDispose = true, String? debugName}) {
  //   final bus = AudioBus.async(path, autoDispose: autoDispose);
  //   bus.debugName = debugName ?? p.basename(path);
  //   return bus;
  // }

  // AudioSampleNode createBufferSource(AudioBus audio) {
  //   return AudioSampleNode(this, audio);
  // }
  // SoundTouchNode createSoundTouch(AudioBus audio, {double maxRate = 2.0}) {
  //   return SoundTouchNode(this, audio, maxRate: maxRate);
  // }

  // RecorderNode createRecorderNode() {
  //   return RecorderNode(this, this.channels, this.sampleRate);
  // }

  // GainNode createGainNode() {
  //   return GainNode(this);
  // }

  startOfflineRendering(String filePath, RecorderNode recorder) {
    LabSound().AudioContext_startOfflineRendering(this.pointer, recorder.nodeId, filePath.toInt8());
  }

  resetDevice() {
    LabSound().AudioContext_resetDevice(this.pointer);
  }

  // 音频渲染设备;
  AudioNode get destination => AudioNode(this, -1);

  /// 关闭一个音频环境, 释放任何正在使用系统资源的音频。
  dispose() {
    LabSound().AudioContext_releaseContext(this.pointer);
  }
}
