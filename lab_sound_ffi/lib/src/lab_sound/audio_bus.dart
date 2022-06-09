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
  Set<AudioNode> usedNode = {};
  String filePath = '';
  bool autoDispose = false;
  bool released = false;
  bool loaded = false;
  Future<AudioBus>? complete;

  final Map<int, Pointer> _bufferPtr = {};


  // allocate indicates whether or not to initially have the AudioChannels created with managed storage.
  // Normal usage is to pass true here, in which case the AudioChannels will memory-manage their own storage.
  // If allocate is false then setChannelMemory() has to be called later on for each channel before the AudioBus is useable...
  AudioBus(int numberOfChannels, int length, {bool allocate = true}): resourceId = LabSound().createAudioBus(numberOfChannels, length, allocate ? 1 : 0);

  // Tells the given channel to use an externally allocated buffer.
  setChannelMemory(int channelIndex, List<double> storage) {
    final oldPtr = _bufferPtr[channelIndex];
    final bufferPtr = malloc.allocate<Float>(sizeOf<Float>() * storage.length);
    for (int i = 0; i < storage.length; i++) {
      bufferPtr[i] = storage[i];
    }
    LabSound().AudioBus_setChannelMemory(resourceId, channelIndex, bufferPtr, storage.length);
    _bufferPtr[channelIndex] = bufferPtr;
    if(oldPtr != null) malloc.free(oldPtr);
  }

  int get has => LabSound().audioBusHasCheck(resourceId);

  StreamSubscription? _statusStreamSubscription;
  AudioBus._loadByFile(this.filePath,
      {this.autoDispose = false,
      this.debugName,
      bool mixToMono = false,
      double targetSampleRate = 0.0})
      : resourceId = LabSound().makeBusFromFile(
            filePath.toInt8(), mixToMono ? 1 : 0, targetSampleRate) {
    debugName ??= basename(filePath);
    Completer<AudioBus> _loadCompleter = Completer();
    complete = _loadCompleter.future;
    _statusStreamSubscription = LabSound()
        .onAudioBusStatus
        .where((event) => event.busId == resourceId)
        .listen((event) {
      if (event.decoded) {
        loaded = true;
        _loadCompleter.complete(this);
      }
    });
  }
  AudioBus._loadByBuffer(
    Pointer<Uint8> bufferPtr,
    int bufferLen, {
    String extension = '',
    this.autoDispose = false,
    this.debugName,
    bool mixToMono = false,
  })  : filePath = '',
        resourceId = LabSound().makeBusFromMemory(
            bufferPtr, bufferLen, extension.toInt8(), mixToMono ? 1 : 0) {
    print('_loadByBuffer');

    debugName ??= basename(filePath);
    Completer<AudioBus> _loadCompleter = Completer();
    complete = _loadCompleter.future;
    _statusStreamSubscription = LabSound()
        .onAudioBusStatus
        .where((event) => event.busId == resourceId)
        .listen((event) {
      print("_statusStreamSubscription: $event");
      if (event.decoded) {
        loaded = true;
        _loadCompleter.complete(this);
      }
    });
  }

  static Future<AudioBus> fromFile(String filePath,
      {autoDispose = false,
      String? debugName,
      bool? mixToMono,
      double? targetSampleRate}) {
    debugName ??= basename(filePath);
    final bus = AudioBus._loadByFile(filePath,
        autoDispose: autoDispose,
        debugName: debugName,
        mixToMono: mixToMono ?? false,
        targetSampleRate: targetSampleRate ?? 0.0);
    return bus.complete!;
  }

  static Future<AudioBus> fromBuffer(Uint8List buffer,
      {autoDispose = false,
      String? extension,
      String? debugName,
      bool mixToMono = false}) async {
    print('fromBuffer');
    final bufferPtr = malloc.allocate<Uint8>(sizeOf<Uint8>() * buffer.length);
    for (int i = 0; i < buffer.length; i++) {
      bufferPtr[i] = buffer[i];
    }
    final bus = AudioBus._loadByBuffer(bufferPtr, buffer.length,
        extension: extension ?? '',
        autoDispose: autoDispose,
        debugName: debugName,
        mixToMono: mixToMono);
    print(' bus.complete!');
    await bus.complete!;
    print('[OK] bus.complete!');

    malloc.free(bufferPtr);
    return bus;
  }

  AudioBus.fromId(this.resourceId, {this.autoDispose = false, this.debugName})
      : filePath = '';

  lock(AudioNode node) {
    usedNode.add(node);
  }

  unlock(AudioNode node) {
    usedNode.remove(node);
    print(
        "$this 节点解锁 ${usedNode.length}, 剩余: $usedNode, audoDispose: $autoDispose");
    if (usedNode.isEmpty && autoDispose) {
      print("$this 销毁！！！");
      dispose();
    }
  }

  dispose() {
    if (released) return;
    released = true;
    loaded = false;
    _statusStreamSubscription?.cancel();
    for (var element in _bufferPtr.values) {
      malloc.free(element);
    }
    LabSound().releaseAudioBus(resourceId);
  }

  int get numberOfChannels => LabSound().AudioBus_numberOfChannels(resourceId);
  int get length => LabSound().AudioBus_length(resourceId);

  double? _sampleRate;
  double get sampleRate {
    _sampleRate ??= LabSound().AudioBus_sampleRate(resourceId);
    return _sampleRate!;
  }

  double get lengthInSeconds => length / sampleRate;

  Duration get duration =>
      Duration(milliseconds: (lengthInSeconds * 1000).toInt());

  AudioChannel? channel(int channelIndex) {
    final pointer = LabSound().AudioBus_channel(resourceId, channelIndex);
    if (pointer.address == 0) return null;
    return AudioChannel(pointer);
  }

  @override
  toString() {
    return "[$resourceId]AudioBus${debugName != null ? "($debugName)" : ''}";
  }
}
