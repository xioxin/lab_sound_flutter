
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/services.dart';

import '../generated_bindings.dart';
import 'dart:async';
import 'dart:isolate';
import 'package:flutter/widgets.dart';

import 'audio_node.dart';


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

class OfflineRenderStatus {
  int id;
  int status;
  OfflineRenderStatus(this.id, this.status);
}

typedef test_func = Void Function();
typedef testFunc = void Function();


const bool inProduction = const bool.fromEnvironment("dart.vm.product");
final DynamicLibrary labSoundLib = Platform.isAndroid
    ? DynamicLibrary.open(inProduction ? "libLabSoundBridge.so" : "libLabSoundBridge_d.so")
    : DynamicLibrary.process();

class LabSound extends LabSoundBind {


  Set<AudioNode> allNodes = Set();

  printSurvivingNodes() {
    allNodes.forEach((node) {
      if(!node.released) {
        print(node);
      }
    });
  }


  ReceivePort _audioBusReceivePort = ReceivePort();
  ReceivePort _audioSampleOnEndedReceivePort = ReceivePort();
  ReceivePort _offlineRenderCompleteReceivePort = ReceivePort();

  static const MethodChannel audioManagerChannel = const MethodChannel('flutter.event/lab_sound_flutter/headset_status');

  static const EventChannel eventChannel = const EventChannel('flutter.event/lab_sound_flutter/headset_status_handler');

  Stream<dynamic>? _onAudioDeviceStateChanged;

  Stream<dynamic> get onAudioDeviceStateChanged {
    _onAudioDeviceStateChanged ??= eventChannel
        .receiveBroadcastStream();
    return _onAudioDeviceStateChanged!;
  }

  _parseAudioDeviceState(dynamic event) {
    return event;
  }

  StreamSubscription? _audioBusSubscription;
  StreamSubscription? _audioSampleOnEndedSubscription;
  StreamSubscription? _offlineRenderCompleteSubscription;

  StreamController<AudioBusStatus> _onAudioBusStatusController = StreamController.broadcast();
  Stream<AudioBusStatus> get onAudioBusStatus => _onAudioBusStatusController.stream;

  StreamController<AudioSampleEndMsg> _onAudioSampleEndController = StreamController.broadcast();
  Stream<AudioSampleEndMsg> get onAudioSampleEnd => _onAudioSampleEndController.stream;

  StreamController<OfflineRenderStatus> _onOfflineRenderCompleteController = StreamController.broadcast();
  Stream<OfflineRenderStatus> get onOfflineRenderComplete => _onOfflineRenderCompleteController.stream;
  

  void _handleAudioBusStatus(dynamic message) {
    if(message is List && message.length == 2) {
      _onAudioBusStatusController.add(AudioBusStatus(message[0], message[1] == 1));
    }
  }

  void _handleAudioSampleOnEnded(dynamic message) {
    if(message is List && message.length == 1) {
      print('onEnded: $message');
      _onAudioSampleEndController.add(AudioSampleEndMsg(message[0]));
    }
  }

  void _handleOfflineRenderComplete(dynamic message) {
    if(message is List && message.length == 2) {
      _onOfflineRenderCompleteController.add(OfflineRenderStatus(message[0], message[1]));
    }
  }

  //
  // test() {
  //   final testFunc test = labSoundLib
  //       .lookup<NativeFunction<test_func>>('labTest')
  //       .asFunction();
  //
  //   test();
  //
  // }

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

    _offlineRenderCompleteSubscription = _offlineRenderCompleteReceivePort.listen(_handleOfflineRenderComplete);
    registerOfflineRenderCompleteSendPort(_offlineRenderCompleteReceivePort.sendPort.nativePort);
    //
    audioManagerChannel.invokeMethod('getDevices', 1).then((value) {
      print('getDevice: $value');
    });
    onAudioDeviceStateChanged.listen((event) {
      print('onAudioDeviceStateChanged: $event');
    });
  }
  static LabSound _sharedInstance() {
    _instance ??= LabSound._();
    return _instance!;
  }
}


