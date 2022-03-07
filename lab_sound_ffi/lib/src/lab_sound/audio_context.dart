import 'dart:async';
import 'dart:ffi';
import 'package:lab_sound_ffi/lab_sound_ffi.dart';
import 'package:lab_sound_ffi/src/lab_sound/audio_listener.dart';
import '../extensions/ffi_string.dart';

class AudioContext {
  final Pointer<Void> pointer;
  final bool offline;
  final AudioStreamConfig? outputConfig;
  final AudioStreamConfig? inputConfig;

  AudioHardwareDeviceNode? _device;

  AudioHardwareDeviceNode get device {
    _device ??= AudioHardwareDeviceNode.fromId(
        this, LabSound().AudioContext_device(pointer));
    return _device!;
  }

  setDevice(AudioNode node) {
    LabSound().AudioContext_setDeviceNode(pointer, node.nodeId);
  }

  static AudioStreamConfig getDefaultOutputConfig() {
    final deviceList = LabSound().makeAudioDeviceList();
    final defaultDevices =
        deviceList.where((element) => element.isDefaultOutput == true);
    AudioDeviceInfo? defaultDevice;
    if (defaultDevices.isNotEmpty) {
      defaultDevice = defaultDevices.first;
    }
    return AudioStreamConfig(
        deviceIndex: defaultDevice?.index ?? 0,
        desiredChannels: defaultDevice?.numOutputChannels ?? 2,
        desiredSampleRate: defaultDevice?.nominalSampleRate ?? 48000.0);
  }

  AudioContext({this.outputConfig, this.inputConfig})
      : offline = false,
        pointer = LabSound().createRealtimeAudioContext(
            (outputConfig ?? getDefaultOutputConfig()).ffiValue,
            (inputConfig ?? AudioStreamConfig.disable()).ffiValue);

  AudioContext.offline(
      {this.outputConfig, this.inputConfig, required Duration? duration})
      : offline = true,
        pointer = LabSound().createOfflineAudioContext(
            (outputConfig ?? AudioStreamConfig()).ffiValue,
            (duration?.inMilliseconds ?? 0).toDouble());

  double get currentTime => LabSound().AudioContext_currentTime(pointer);

  double get predictedCurrentTime =>
      LabSound().AudioContext_predictedCurrentTime(pointer);

  double get sampleRate => LabSound().AudioContext_sampleRate(pointer);

  AudioListener get listener =>
      AudioListener.fromId(this, LabSound().AudioContext_listener(pointer));

  bool get isOfflineContext =>
      LabSound().AudioContext_isOfflineContext(pointer) > 0;

  int get currentSampleFrame =>
      LabSound().AudioContext_currentSampleFrame(pointer);

  bool get isRunning => device.isRunning;
  final StreamController<bool> _onRunning = StreamController.broadcast();

  Stream<bool> get onRunning => _onRunning.stream;

  addAutomaticPullNode(AudioNode node) =>
      LabSound().AudioContext_addAutomaticPullNode(pointer, node.nodeId);

  removeAutomaticPullNode(AudioNode node) =>
      LabSound().AudioContext_removeAutomaticPullNode(pointer, node.nodeId);

  processAutomaticPullNodes(int framesToProcess) => LabSound()
      .AudioContext_processAutomaticPullNodes(pointer, framesToProcess);

  handlePreRenderTasks() =>
      LabSound().AudioContext_handlePreRenderTasks(pointer);

  handlePostRenderTasks() =>
      LabSound().AudioContext_handlePostRenderTasks(pointer);

  synchronizeConnections(Duration timeOut) => LabSound()
      .AudioContext_synchronizeConnections(pointer, timeOut.inMilliseconds);

  connect(AudioNode destination, AudioNode source,
      [destIdx = 0, int srcIdx = 0]) {
    LabSound().AudioContext_connect(
        pointer, destination.nodeId, source.nodeId, destIdx, srcIdx);
  }

  disconnect(AudioNode destination, AudioNode source,
      [destIdx = 0, int srcIdx = 0]) {
    LabSound().AudioContext_disconnect(
        pointer, destination.nodeId, source.nodeId, destIdx, srcIdx);
  }

  disconnectCompletely(AudioNode destination, [int destIdx = 0]) {
    LabSound().AudioContext_disconnectCompletely(
        pointer, destination.nodeId, destIdx);
  }

  connectParam(AudioParam param, AudioNode driverNode, [int index = 0]) {
    LabSound().AudioContext_connectParam(
        pointer, param.nodeId, param.paramId, driverNode.nodeId, index);
  }

  connectParamByName(
      AudioNode destinationNode, String parameterName, AudioNode driverNode,
      [int index = 0]) {
    LabSound().AudioContext_connectParamByName(pointer, destinationNode.nodeId,
        parameterName.toInt8(), driverNode.nodeId, index);
  }

  disconnectParam(AudioParam param, AudioNode driverNode, [int index = 0]) {
    LabSound().AudioContext_disconnectParam(
        pointer, param.nodeId, param.paramId, driverNode.nodeId, index);
  }

  suspend() {
    LabSound().AudioContext_suspend(pointer);
    _onRunning.sink.add(false);
  }

  resume() {
    LabSound().AudioContext_resume(pointer);
    _onRunning.sink.add(true);
  }

  Future<bool> startOfflineRendering() async {
    final id = LabSound().AudioContext_startOfflineRendering(pointer);
    if (id < 0) return false;
    final result = await LabSound()
        .onOfflineRenderComplete
        .firstWhere((element) => element.id == id);
    return result.status > 0;
  }

  AudioHardwareDeviceNode get destination => device;

  AudioNode makeAudioHardwareInputNode() => AudioNode(
      this, LabSound().AudioContext_makeAudioHardwareInputNode(pointer));

  dispose() {
    for (var node in LabSound().allNodes) {
      if (!node.released && node.ctx == this) {
        node.dispose();
      }
    }
    _onRunning.close();
    LabSound().AudioContext_releaseContext(pointer);
  }
}
