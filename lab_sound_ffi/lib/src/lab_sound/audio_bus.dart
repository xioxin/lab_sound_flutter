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
  static final Map<int, WeakReference<AudioBus>> busMap = {};

  static final Finalizer<AudioBus> finalizer = Finalizer((bus) {
    print('AudioBus Finalizer: $bus');
    bus.dispose();
  });

  String? debugName;
  final int resourceId;
  Set<AudioNode> usedNode = {};
  String filePath = '';
  bool released = false;
  bool loaded = false;
  Future<AudioBus>? complete;

  final Map<int, Pointer> _bufferPtr = {};

  // allocate indicates whether or not to initially have the AudioChannels created with managed storage.
  // Normal usage is to pass true here, in which case the AudioChannels will memory-manage their own storage.
  // If allocate is false then setChannelMemory() has to be called later on for each channel before the AudioBus is useable...
  AudioBus(int numberOfChannels, int length, {bool allocate = true})
      : resourceId = LabSound()
            .createAudioBus(numberOfChannels, length, allocate ? 1 : 0) {
    finalizer.attach(this, this, detach: this);
    busMap[resourceId] = WeakReference(this);
  }

  // Tells the given channel to use an externally allocated buffer.
  setChannelMemory(int channelIndex, List<double> storage) {
    final oldPtr = _bufferPtr[channelIndex];
    final bufferPtr = malloc.allocate<Float>(sizeOf<Float>() * storage.length);
    for (int i = 0; i < storage.length; i++) {
      bufferPtr[i] = storage[i];
    }
    LabSound().AudioBus_setChannelMemory(
        resourceId, channelIndex, bufferPtr, storage.length);
    _bufferPtr[channelIndex] = bufferPtr;
    if (oldPtr != null) malloc.free(oldPtr);
  }

  bool get has => LabSound().audioBusHasCheck(resourceId) > 0;

  StreamSubscription? _statusStreamSubscription;
  AudioBus._loadByFile(this.filePath,
      {this.debugName, bool mixToMono = false, double targetSampleRate = 0.0})
      : resourceId = LabSound().makeBusFromFile(
            filePath.toInt8(), mixToMono ? 1 : 0, targetSampleRate) {
    finalizer.attach(this, this, detach: this);
    busMap[resourceId] = WeakReference(this);

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
    this.debugName,
    bool mixToMono = false,
  })  : filePath = '',
        resourceId = LabSound().makeBusFromMemory(
            bufferPtr, bufferLen, extension.toInt8(), mixToMono ? 1 : 0) {
    finalizer.attach(this, this, detach: this);
    busMap[resourceId] = WeakReference(this);

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
        extension: extension ?? '', debugName: debugName, mixToMono: mixToMono);
    print(' bus.complete!');
    await bus.complete!;
    print('[OK] bus.complete!');

    malloc.free(bufferPtr);
    return bus;
  }

  static AudioBus fromId(int resourceId, {String? debugName}) {
    final bus = busMap[resourceId]?.target;
    if (bus != null) {
      return bus;
    }
    if (LabSound().audioBusHasCheck(resourceId) > 0) {
      return AudioBus._fromId(resourceId, debugName: debugName);
    }
    throw Exception("AudioBus Resource not exist");
  }

  AudioBus._fromId(this.resourceId, {this.debugName}) : filePath = '' {
    finalizer.attach(this, this, detach: this);
    busMap[resourceId] = WeakReference(this);
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
