import 'dart:async';
import 'dart:ffi';
import 'lab_sound.dart';
import 'package:ffi/ffi.dart';
import '../extensions/ffi_string.dart';

class AudioBus {

  String? debugName;
  final int resourceId;
  Set<AudioNode> usedNode = Set();
  String filePath;
  bool autoDispose;
  bool released = false;
  bool loaded = false;
  Future<AudioBus>? complete;

  StreamSubscription? _statusStreamSubscription;
  AudioBus(this.filePath , {this.autoDispose = false}): resourceId = LabSound().decodeAudioData(filePath.toInt8()) {
    loaded = true;
  }

  static async(String filePath, {autoDispose = false}) {
    final bus = AudioBus.asyncLoad(filePath, autoDispose: autoDispose);
    return bus.complete;
  }

  AudioBus.asyncLoad(this.filePath, {this.autoDispose = false}): resourceId = LabSound().decodeAudioDataAsync(filePath.toInt8()) {
    Completer<AudioBus> _loadCompleter = Completer();
    _statusStreamSubscription = LabSound().onAudioBusStatus.where((event) => event.busId == this.resourceId).listen((event) {
      if(event.decoded) {
        _loadCompleter.complete(this);
      }
    });
    complete = _loadCompleter.future;
  }

  lock(AudioNode node) {
    usedNode.add(node);
    print("$this 节点占用 ${usedNode.length}");
  }

  unlock(AudioNode node) {
    usedNode.remove(node);
    print("$this 节点解锁 ${usedNode.length}, 剩余: $usedNode, audoDispose: $autoDispose");
    if(usedNode.length == 0 && autoDispose) {
      print("$this 销毁！！！");
      this.dispose();
    }
  }

  dispose() {
    if(released) return;
    released = true;
    loaded = false;
    _statusStreamSubscription?.cancel();
    LabSound().releaseAudioBus(this.resourceId);
  }

  int get numberOfChannels => LabSound().AudioBus_numberOfChannels(this.resourceId);
  int get length => LabSound().AudioBus_length(this.resourceId);
  double get sampleRate => LabSound().AudioBus_sampleRate(this.resourceId);
  Duration get duration => Duration(milliseconds: (this.length / this.sampleRate * 1000).toInt());

  toString() {
    return "AudioBus<$resourceId: $debugName>";
  }
}
