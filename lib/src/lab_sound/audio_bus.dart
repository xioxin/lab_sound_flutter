import 'dart:async';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart';
import '../extensions/ffi_string.dart';
import 'audio_node.dart';
import 'lab_sound.dart';

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
  AudioBus(this.filePath , {this.autoDispose = false, this.debugName}): resourceId = LabSound().decodeAudioData(filePath.toInt8()) {
    loaded = true;
  }

  static Future<AudioBus> async(String filePath, {autoDispose = false, String? debugName}) {
    debugName ??= basename(filePath);
    final bus = AudioBus.asyncLoad(filePath, autoDispose: autoDispose, debugName: debugName);
    return bus.complete!;
  }

  AudioBus.fromId(this.resourceId, {this.autoDispose = false, this.debugName}): filePath = '';

  AudioBus.asyncLoad(this.filePath, {this.autoDispose = false, this.debugName}): resourceId = LabSound().decodeAudioDataAsync(filePath.toInt8()) {
    debugName ??= basename(filePath);
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

  double? _sampleRate;
  double get sampleRate {
    _sampleRate ??= LabSound().AudioBus_sampleRate(this.resourceId);
    return _sampleRate!;
  }

  double get lengthInSeconds => this.length / this.sampleRate;

  Duration get duration => Duration(milliseconds: (this.lengthInSeconds * 1000).toInt());

  toString() {
    return "[$resourceId]AudioBus${debugName != null ? "($debugName)" : ''}";
  }
}
