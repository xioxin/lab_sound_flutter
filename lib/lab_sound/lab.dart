
import 'dart:ffi';
import 'dart:io';
import '../generated_bindings.dart';
import 'dart:async';
import 'dart:isolate';
import 'package:flutter/widgets.dart';


const CHECK_TIMER_DURATION = const Duration( milliseconds: 200 );


class AudioBusStatus {
  int busId;
  bool decoded;
  AudioBusStatus(this.busId, this.decoded);
}

class AudioSampleEndMsg {
  int nodeId;
  AudioSampleEndMsg(this.nodeId);
}

const bool inProduction = const bool.fromEnvironment("dart.vm.product");
final DynamicLibrary labSoundLib = Platform.isAndroid
    ? DynamicLibrary.open(inProduction ? "libLabSound.so" : "libLabSound_d.so")
    : DynamicLibrary.process();

class LabSound extends LabSoundBind {
  ReceivePort _audioBusReceivePort = ReceivePort();
  ReceivePort _audioSampleOnEndedReceivePort = ReceivePort();

  StreamSubscription? _audioBusSubscription;
  StreamSubscription? _audioSampleOnEndedSubscription;

  StreamController<AudioBusStatus> _onAudioBusStatusController = StreamController.broadcast();
  Stream<AudioBusStatus> get onAudioBusStatus => _onAudioBusStatusController.stream;

  StreamController<AudioSampleEndMsg> _onAudioSampleEndController = StreamController.broadcast();
  Stream<AudioSampleEndMsg> get onAudioSampleEnd => _onAudioSampleEndController.stream;

  void _handleAudioBusStatus(dynamic message) {
    if(message is List && message.length == 2) {
      _onAudioBusStatusController.add(AudioBusStatus(message[0], message[1] == 1));
    }
  }

  void _handleAudioSampleOnEnded(dynamic message) {
    if(message is List && message.length == 1) {
      _onAudioSampleEndController.add(AudioSampleEndMsg(message[0]));
    }
  }

  factory LabSound() => _sharedInstance();
  static LabSound? _instance;
  LabSound._(): super(labSoundLib) {
    WidgetsFlutterBinding.ensureInitialized();
    var nativeInited = InitDartApiDL(NativeApi.initializeApiDLData);
    // According to https://dart-review.googlesource.com/c/sdk/+/151525
    // flutter-1.24.0-10.1.pre+ has `DART_API_DL_MAJOR_VERSION = 2`
    assert(nativeInited == 0, 'DART_API_DL_MAJOR_VERSION != 2');
    _audioBusSubscription = _audioBusReceivePort.listen(_handleAudioBusStatus);
    registerDecodeAudioSendPort(_audioBusReceivePort.sendPort.nativePort);

    _audioSampleOnEndedSubscription = _audioSampleOnEndedReceivePort.listen(_handleAudioSampleOnEnded);
    registerAudioSampleOnEndedSendPort(_audioSampleOnEndedReceivePort.sendPort.nativePort);

  }
  static LabSound _sharedInstance() {
    _instance ??= LabSound._();
    return _instance!;
  }
}


