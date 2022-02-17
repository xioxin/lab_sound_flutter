import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart';
import '../extensions/ffi_string.dart';

import 'audio_node.dart';
import 'lab_sound.dart';
import 'audio_channel.dart';

class AudioBus {

  String? debugName;
  final int resourceId;
  Set<AudioNode> usedNode = Set();
  String filePath;
  bool autoDispose;
  bool released = false;
  bool loaded = false;
  Future<AudioBus>? complete;

  int get has => LabSound().audioBusHasCheck(resourceId);

  StreamSubscription? _statusStreamSubscription;
  AudioBus._loadByFile(this.filePath, {
    this.autoDispose = false,
    this.debugName,
    bool mixToMono = false,
    double targetSampleRate = 0.0
  }): resourceId = LabSound().makeBusFromFile(filePath.toInt8(), mixToMono ? 1 : 0, targetSampleRate) {
    debugName ??= basename(filePath);
    Completer<AudioBus> _loadCompleter = Completer();
    complete = _loadCompleter.future;
    _statusStreamSubscription = LabSound().onAudioBusStatus.where((event) => event.busId == this.resourceId).listen((event) {
      if(event.decoded) {
        loaded = true;
        _loadCompleter.complete(this);
      }
    });
  }
  AudioBus._loadByBuffer(Pointer<Uint8> bufferPtr, int bufferLen, {
    String extension = '',
    this.autoDispose = false,
    this.debugName,
    bool mixToMono = false,
  }):filePath = '', resourceId = LabSound().makeBusFromMemory(bufferPtr, bufferLen, extension.toInt8(), mixToMono ? 1 : 0) {
    debugName ??= basename(filePath);
    Completer<AudioBus> _loadCompleter = Completer();
    complete = _loadCompleter.future;
    _statusStreamSubscription = LabSound().onAudioBusStatus.where((event) => event.busId == this.resourceId).listen((event) {
      if(event.decoded) {
        loaded = true;
        _loadCompleter.complete(this);
      }
    });
  }

  static Future<AudioBus> fromFile(String filePath, {autoDispose = false, String? debugName, bool? mixToMono, double? targetSampleRate}) {
    debugName ??= basename(filePath);
    final bus = AudioBus._loadByFile(filePath, autoDispose: autoDispose, debugName: debugName, mixToMono: mixToMono ?? false, targetSampleRate: targetSampleRate ?? 0.0);
    return bus.complete!;
  }

  static Future<AudioBus> fromBuffer(Uint8List buffer, {autoDispose = false, String? extension, String? debugName, bool mixToMono = false}) async {
    final bufferPtr = malloc.allocate<Uint8>(buffer.length);
    for (int i = 0; i < buffer.length; i++) {
      bufferPtr[i] = buffer[i];
    }
    final bus = AudioBus._loadByBuffer(bufferPtr, buffer.length, extension: extension ?? '', autoDispose: autoDispose, debugName: debugName, mixToMono: mixToMono);
    await bus.complete!;
    malloc.free(bufferPtr);
    return bus;
  }


  AudioBus.fromId(this.resourceId, {this.autoDispose = false, this.debugName}): filePath = '';

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


  AudioChannel? channel(int channelIndex) {
    final pointer = LabSound().AudioBus_channel(resourceId, channelIndex);
    if(pointer.address == 0) return null;
    return AudioChannel(pointer);
  }

  toString() {
    return "[$resourceId]AudioBus${debugName != null ? "($debugName)" : ''}";
  }
}
