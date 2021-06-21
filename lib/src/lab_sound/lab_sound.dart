import 'dart:ffi';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dart:collection';
import 'package:ffi/ffi.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';

import '../generated_bindings.dart';
import '../extensions/ffi_string.dart';
import 'dart:async';
import 'dart:isolate';
import 'package:flutter/widgets.dart';

import 'audio_node.dart';
import 'audio_stream_config.dart' as ASC;

const CHECK_TIMER_DURATION = const Duration(milliseconds: 200);

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
    ? DynamicLibrary.open(
        kDebugMode ? "libLabSoundBridge_d.so" : "libLabSoundBridge.so")
    : DynamicLibrary.process();

enum AndroidAudioDeviceType {
  unknown, // 0
  builtinEarpiece, // 1
  builtinSpeaker, // 2
  wiredHeadset, // 3
  wiredHeadphones, // 4
  lineAnalog, // 5
  lineDigital, // 6
  bluetoothSCO, // 7
  bluetoothA2DP, // 8
  hdmi, // 9
  hdmiARC, // 10
  usbDevice, // 11
  usbAccessory, // 12
  dock, // 13
  fm, // 14
  builtinMic, // 15
  fmTuner, // 16
  tvTuner, // 17
  telephony, // 18
  auxLine, // 19
  ip, // 20
  bus, // 21
  usbHeadset, // 22
  hearingAid, // 23
  builtinSpeakerSafe, // 24
  remoteSubmix, // 25
  bleHeadset, // 26
  bleSpeaker, // 27
  unknown28, // 28
  hdmiEARC, // 29
}

class AudioDeviceInfo {
  int index;
  String? identifier;
  int? numOutputChannels;
  int? numInputChannels;
  double? nominalSampleRate;
  bool? isDefaultOutput;
  bool? isDefaultInput;
  List<double>? supportedSampleRates;
  bool? isOutput;
  bool? isInput;

  AudioDeviceInfo({
    required this.index,
    this.identifier,
    this.numInputChannels,
    this.numOutputChannels,
    this.nominalSampleRate,
    this.isDefaultInput,
    this.isDefaultOutput,
    this.supportedSampleRates,
    this.isOutput,
    this.isInput,
  });

  Map<String, dynamic> toJson() => {
        "index": index,
        "identifier": identifier,
        "numInputChannels": numInputChannels,
        "numOutputChannels": numOutputChannels,
        "nominalSampleRate": nominalSampleRate,
        "isDefaultInput": isDefaultInput,
        "isDefaultOutput": isDefaultOutput,
        "supportedSampleRates": supportedSampleRates,
      };

  @override
  String toString() => "AudioDevice[$index]: ${toJson()}";
}

class AudioDeviceInfoAndroid extends AudioDeviceInfo {
  // android
  String? address;
  String? productName;
  bool? isOutput;
  bool? isInput;
  List<int>? supportedChannelCounts;
  AndroidAudioDeviceType? androidType;
  List<double>? supportedSampleRates;

  AudioDeviceInfoAndroid({
    required int index,
    this.productName,
    this.supportedChannelCounts,
    this.androidType,
    this.address,
    this.isOutput,
    this.isInput,
    this.supportedSampleRates,
  }) : super(index: index);

  @override
  String toString() => "AndroidAudioDevice[$index]: $productName - $address $androidType";
}

class LabSound extends LabSoundBind {
  static MethodChannel? androidAudioManagerChannel;
  static EventChannel? androidEventChannel;

  LabSound._() : super(labSoundLib) {
    WidgetsFlutterBinding.ensureInitialized();
    var nativeInited = InitDartApiDL(NativeApi.initializeApiDLData);
    // According to https://dart-review.googlesource.com/c/sdk/+/151525
    // flutter-1.24.0-10.1.pre+ has `DART_API_DL_MAJOR_VERSION = 2`
    assert(nativeInited == 0, 'DART_API_DL_MAJOR_VERSION != 2');
    _audioBusSubscription = _audioBusReceivePort.listen(_handleAudioBusStatus);
    registerDecodeAudioSendPort(_audioBusReceivePort.sendPort.nativePort);
    _audioSampleOnEndedSubscription =
        _audioSampleOnEndedReceivePort.listen(_handleAudioSampleOnEnded);
    registerAudioSampleOnEndedSendPort(
        _audioSampleOnEndedReceivePort.sendPort.nativePort);

    _offlineRenderCompleteSubscription =
        _offlineRenderCompleteReceivePort.listen(_handleOfflineRenderComplete);
    registerOfflineRenderCompleteSendPort(
        _offlineRenderCompleteReceivePort.sendPort.nativePort);

    if (Platform.isAndroid) {
      androidAudioManagerChannel ??=
          MethodChannel('flutter.event/lab_sound_flutter/audio_manager');
      androidEventChannel ??=
          EventChannel('flutter.event/lab_sound_flutter/audio_event');
      // onAndroidAudioDeviceStateChanged.listen((event) {
      //   print('onAudioDeviceStateChanged: $event');
      // });
    }
  }

  List<AudioDeviceInfo> makeAudioDeviceList() {
    final data = labSound_MakeAudioDeviceList();
    final List<AudioDeviceInfo> list = [];
    for (int i = 0; i < data.length; i++) {
      final device = data.audioDeviceList.elementAt(i).ref;
      list.add(AudioDeviceInfo(
        index: device.index,
        identifier: device.identifier.toStr(),
        numInputChannels: device.num_input_channels,
        numOutputChannels: device.num_output_channels,
        nominalSampleRate: device.nominal_samplerate,
        isDefaultInput: device.is_default_input > 0,
        isDefaultOutput: device.is_default_output > 0,
        supportedSampleRates: device.supported_samplerates.toList(),
      ));
    }
    return list;
  }

  AudioDeviceIndex getDefaultOutputAudioDeviceIndex() =>
      labSound_GetDefaultOutputAudioDeviceIndex();

  AudioDeviceIndex getDefaultInputAudioDeviceIndex() =>
      labSound_GetDefaultInputAudioDeviceIndex();

  //
  Future<List<AudioDeviceInfoAndroid>> getAndroidAudioDeviceList() async {
    if (androidAudioManagerChannel == null) return [];
    final List<dynamic> androidDeviceList =
        await androidAudioManagerChannel!.invokeMethod('getDevices', 1);
    print('androidDeviceList $androidDeviceList');
    print('input ${androidDeviceList.where(((v) => v['isSource']))}');
    final devList =  androidDeviceList.map((e) => AudioDeviceInfoAndroid(
          index: e["id"] as int,
          address: e["address"] as String,
          productName: e["productName"] as String,
          isOutput: e["isSource"] as bool,
          isInput: e["isSink"] as bool,
          androidType: AndroidAudioDeviceType.values[e["type"] as int],
          supportedSampleRates: e["sampleRates"] == null ? null : (e["sampleRates"] as List)
              .map((e) => (e as int).toDouble())
              .toList(),
          supportedChannelCounts: e["channelCounts"] == null ? null : (e["channelCounts"] as List).map((e) => (e as int)).toList(),
        )).toList();

    print(devList.map((e) => e.toString()).join("\n"));
    return devList;
  }

  Set<AudioNode> allNodes = Set();

  printSurvivingNodes() {
    allNodes.forEach((node) {
      if (!node.released) {
        print(node);
      }
    });
  }

  ReceivePort _audioBusReceivePort = ReceivePort();
  ReceivePort _audioSampleOnEndedReceivePort = ReceivePort();
  ReceivePort _offlineRenderCompleteReceivePort = ReceivePort();

  Stream<dynamic>? _onAndroidAudioDeviceStateChanged;

  Stream<dynamic> get onAndroidAudioDeviceStateChanged {
    _onAndroidAudioDeviceStateChanged ??=
        androidEventChannel!.receiveBroadcastStream();
    return _onAndroidAudioDeviceStateChanged!;
  }

  _parseAudioDeviceState(dynamic event) {
    return event;
  }

  StreamSubscription? _audioBusSubscription;
  StreamSubscription? _audioSampleOnEndedSubscription;
  StreamSubscription? _offlineRenderCompleteSubscription;

  StreamController<AudioBusStatus> _onAudioBusStatusController =
      StreamController.broadcast();

  Stream<AudioBusStatus> get onAudioBusStatus =>
      _onAudioBusStatusController.stream;

  StreamController<AudioSampleEndMsg> _onAudioSampleEndController =
      StreamController.broadcast();

  Stream<AudioSampleEndMsg> get onAudioSampleEnd =>
      _onAudioSampleEndController.stream;

  StreamController<OfflineRenderStatus> _onOfflineRenderCompleteController =
      StreamController.broadcast();

  Stream<OfflineRenderStatus> get onOfflineRenderComplete =>
      _onOfflineRenderCompleteController.stream;

  void _handleAudioBusStatus(dynamic message) {
    if (message is List && message.length == 2) {
      _onAudioBusStatusController
          .add(AudioBusStatus(message[0], message[1] == 1));
    }
  }

  void _handleAudioSampleOnEnded(dynamic message) {
    if (message is List && message.length == 1) {
      print('onEnded: $message');
      _onAudioSampleEndController.add(AudioSampleEndMsg(message[0]));
    }
  }

  void _handleOfflineRenderComplete(dynamic message) {
    if (message is List && message.length == 2) {
      _onOfflineRenderCompleteController
          .add(OfflineRenderStatus(message[0], message[1]));
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

  static LabSound _sharedInstance() {
    _instance ??= LabSound._();
    return _instance!;
  }
}

class Lab {
  static List<AudioDeviceInfo> makeAudioDeviceList() =>
      LabSound().makeAudioDeviceList();

  static AudioDeviceIndex getDefaultOutputAudioDeviceIndex() =>
      LabSound().getDefaultOutputAudioDeviceIndex();

  static AudioDeviceIndex getDefaultInputAudioDeviceIndex() =>
      LabSound().getDefaultOutputAudioDeviceIndex();

  static AudioContext makeRealtimeAudioContext(
          {ASC.AudioStreamConfig? outputConfig,
          ASC.AudioStreamConfig? inputConfig}) =>
      AudioContext(outputConfig: outputConfig, inputConfig: inputConfig);
}
