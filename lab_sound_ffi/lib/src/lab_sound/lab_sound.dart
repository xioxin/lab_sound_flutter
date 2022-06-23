import 'dart:ffi';
import 'dart:io';
import 'package:lab_sound_ffi/lab_sound_ffi.dart';
import 'package:lab_sound_ffi/src/lab_sound/function_node.dart';
import '../generated_bindings.dart';
import '../extensions/ffi_string.dart';
import 'dart:async';
import 'dart:isolate';

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

typedef LoadLabSoundLib = DynamicLibrary Function();

enum OperatingSystem {
  android,
  linux,
  iOS,
  macOS,
  windows,
  fuchsia,
}

const bool inProduction = bool.fromEnvironment("dart.vm.product");

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

class LabSound extends LabSoundBind {
  static DynamicLibrary defaultLoadLabSoundLib() {
    if (Platform.isAndroid) {
      return DynamicLibrary.open("libLabSoundBridge.so");
    }

    if (Platform.isLinux) {
      return DynamicLibrary.open("libLabSoundBridge.so");
    }

    if (Platform.isWindows) {
      return DynamicLibrary.open("LabSoundBridge.dll");
    }

    return DynamicLibrary.process();
  }

  static LoadLabSoundLib _loadDynamicLibrary = defaultLoadLabSoundLib;

  static OperatingSystem? get _os {
    if (Platform.isAndroid) return OperatingSystem.android;
    if (Platform.isLinux) return OperatingSystem.linux;
    if (Platform.isIOS) return OperatingSystem.iOS;
    if (Platform.isMacOS) return OperatingSystem.macOS;
    if (Platform.isWindows) return OperatingSystem.windows;
    if (Platform.isFuchsia) return OperatingSystem.fuchsia;
    return null;
  }

  static overrideDynamicLibrary(LoadLabSoundLib func,
      [OperatingSystem? platform]) {
    if (platform == null || _os == platform) {
      _loadDynamicLibrary = func;
    }
  }

  static void functionNodeChannel(
      int nodeId, int channel, Pointer<Float> values, int bufferSize) {
    print("nodeId: $nodeId, bufferSize: $bufferSize, channel: $channel");
    if (nodeId <= 0) return;
    final box = LabSound().nodeMap[nodeId];
    final node = box?.target;
    if (node != null && node is FunctionNode) {
      if (node.fn != null) {
        node.fn!(
            node.ctx, node, channel, FunctionNodeBuffer(bufferSize, values));
      }
    }
  }

  List<AudioDeviceInfo> makeAudioDeviceList() {
    final data = labSound_MakeAudioDeviceList();
    final List<AudioDeviceInfo> list = [];
    for (int i = 0; i < data.length; i++) {
      final device = data.audioDeviceList.elementAt(i).ref;
      list.add(AudioDeviceInfo(
        index: device.index,
        identifier: device.identifier.toStr(length: device.identifier_len),
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

  Map<int, WeakReference<AudioNode>> nodeMap = {};

  printSurvivingNodes() {
    for (var wrNode in nodeMap.values) {
      if (wrNode.target != null) {
        print(wrNode.target);
      }
    }
  }

  final ReceivePort _audioBusReceivePort = ReceivePort();
  final ReceivePort _audioSampleOnEndedReceivePort = ReceivePort();
  final ReceivePort _offlineRenderCompleteReceivePort = ReceivePort();
  final ReceivePort _functionNodeSendPort = ReceivePort();

  _parseAudioDeviceState(dynamic event) {
    return event;
  }

  StreamSubscription? audioBusSubscription;
  StreamSubscription? audioSampleOnEndedSubscription;
  StreamSubscription? offlineRenderCompleteSubscription;
  StreamSubscription? functionNodeSubscription;

  final StreamController<AudioBusStatus> _onAudioBusStatusController =
      StreamController.broadcast();

  Stream<AudioBusStatus> get onAudioBusStatus =>
      _onAudioBusStatusController.stream;

  final StreamController<AudioSampleEndMsg> _onAudioSampleEndController =
      StreamController.broadcast();

  Stream<AudioSampleEndMsg> get onAudioSampleEnd =>
      _onAudioSampleEndController.stream;

  final StreamController<OfflineRenderStatus>
      _onOfflineRenderCompleteController = StreamController.broadcast();

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
      _onAudioSampleEndController.add(AudioSampleEndMsg(message[0]));
    }
  }

  void _handleOfflineRenderComplete(dynamic message) {
    if (message is List && message.length == 2) {
      _onOfflineRenderCompleteController
          .add(OfflineRenderStatus(message[0], message[1]));
    }
  }

  void _handleFunctionNode(dynamic message) {
    if (message is List && message.length == 4) {
      final nodeId = message[0] as int;
      if (nodeId <= 0) return;
      final box = LabSound().nodeMap[nodeId];
      final node = box?.target;
      if (node != null && node is FunctionNode && !node.released) {
        if (node.fn != null) {
          final channel = message[1] as int;
          final bufferPointer = Pointer<Float>.fromAddress(message[2] as int);
          final bufferSize = message[3] as int;
          print(
              '_handleFunctionNode: $nodeId $channel $bufferPointer $bufferSize');
          final buffer = FunctionNodeBuffer(bufferSize, bufferPointer);
          print("buffer: $buffer");
          node.fn!(node.ctx, node, channel, buffer);
        }
      }
    }
  }

  static LabSound? _instance;

  static LabSound _sharedInstance() {
    _instance ??= LabSound._init();
    return _instance!;
  }

  factory LabSound() => _sharedInstance();

  LabSound._init() : super(_loadDynamicLibrary()) {
    print("LabSound init");
    var nativeInited = InitDartApiDL(NativeApi.initializeApiDLData);
    // According to https://dart-review.googlesource.com/c/sdk/+/151525
    // flutter-1.24.0-10.1.pre+ has `DART_API_DL_MAJOR_VERSION = 2`
    assert(nativeInited == 0, 'DART_API_DL_MAJOR_VERSION != 2');
    audioBusSubscription = _audioBusReceivePort.listen(_handleAudioBusStatus);
    registerDecodeAudioSendPort(_audioBusReceivePort.sendPort.nativePort);
    audioSampleOnEndedSubscription =
        _audioSampleOnEndedReceivePort.listen(_handleAudioSampleOnEnded);
    registerAudioSampleOnEndedSendPort(
        _audioSampleOnEndedReceivePort.sendPort.nativePort);

    offlineRenderCompleteSubscription =
        _offlineRenderCompleteReceivePort.listen(_handleOfflineRenderComplete);
    registerOfflineRenderCompleteSendPort(
        _offlineRenderCompleteReceivePort.sendPort.nativePort);

    functionNodeSubscription =
        _functionNodeSendPort.listen(_handleFunctionNode);
    registerFunctionNodeSendPort(_functionNodeSendPort.sendPort.nativePort);

    setFunctionNodeChannelFn(
        Pointer.fromFunction(LabSound.functionNodeChannel));

    // print("RegisterClosureCallbackFP(closureCallbackPointer);");
    // RegisterClosureCallbackFP(closureCallbackPointer);
    // // C holds on to this closure through a `Dart_PersistenHandle`.
    // print("RegisterClosureCallback(closure);");
    // RegisterClosureCallback(closure);
    // print("InvokeClosureCallback;");
    // InvokeClosureCallback();
    // print("ReleaseClosureCallback;");
    // ReleaseClosureCallback();
  }

  static dispose() {
    if (_instance != null) {
      for (var element in _instance!.nodeMap.values) {
        element.target?.dispose();
      }
      _instance!.audioBusSubscription?.cancel();
      _instance!.audioSampleOnEndedSubscription?.cancel();
      _instance!.offlineRenderCompleteSubscription?.cancel();
      _instance!.functionNodeSubscription?.cancel();
      _instance = null;
    }
  }
}
