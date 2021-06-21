import 'dart:async';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:rxdart/rxdart.dart';
import '../extensions/ffi_string.dart';
import 'recorder_node.dart';
import 'audio_hardware_device_node.dart';
import 'audio_node.dart';
import 'audio_stream_config.dart';
import 'lab_sound.dart';

class AudioContext {
  final Pointer<Void> pointer;
  final bool offline;
  final AudioStreamConfig? outputConfig;
  final AudioStreamConfig? inputConfig;

  AudioHardwareDeviceNode? _device;

  AudioHardwareDeviceNode get device {
    _device ??= AudioHardwareDeviceNode.fromId(
        this, LabSound().AudioContext_device(this.pointer));
    return _device!;
  }

  setDevice(AudioNode node) {
    LabSound().AudioContext_setDeviceNode(this.pointer, node.nodeId);
  }

  AudioContext({this.outputConfig, this.inputConfig})
      : offline = false, pointer = LabSound().createRealtimeAudioContext(
      (outputConfig ?? AudioStreamConfig(desiredChannels: 2, desiredSampleRate: 48000.0)).ffiValue,
      (inputConfig ?? AudioStreamConfig()).ffiValue) {
    // LabSound().onAudioDeviceStateChanged.debounceTime(Duration(milliseconds: 1000)).listen((event) {
    //   final running = this.device.isRunning;
    //   this.device.stop();
    //   this.device.backendReinitialize();
    //   if(running)this.device.start();
    // });
  }

  AudioContext.offline({
    this.outputConfig, this.inputConfig,
    @required Duration? duration
  }):offline = true, pointer = LabSound().createOfflineAudioContext(
      (outputConfig ?? AudioStreamConfig()).ffiValue, (duration?.inMilliseconds ?? 0).toDouble());

  double get currentTime => LabSound().AudioContext_currentTime(this.pointer);

  double get predictedCurrentTime =>
      LabSound().AudioContext_predictedCurrentTime(this.pointer);

  double get sampleRate => LabSound().AudioContext_sampleRate(this.pointer);

  int get currentSampleFrame => LabSound().AudioContext_currentSampleFrame(this.pointer);

  bool get isRunning => device.isRunning;
  StreamController<bool> _onRunning = StreamController.broadcast();
  Stream<bool> get onRunning => _onRunning.stream;

  addAutomaticPullNode(AudioNode node) => LabSound().AudioContext_addAutomaticPullNode(pointer, node.nodeId);
  removeAutomaticPullNode(AudioNode node) => LabSound().AudioContext_removeAutomaticPullNode(pointer, node.nodeId);

  processAutomaticPullNodes(int framesToProcess) => LabSound().AudioContext_processAutomaticPullNodes(pointer, framesToProcess);

  handlePreRenderTasks() => LabSound().AudioContext_handlePreRenderTasks(pointer);
  handlePostRenderTasks() => LabSound().AudioContext_handlePostRenderTasks(pointer);
  synchronizeConnections(Duration timeOut) => LabSound().AudioContext_synchronizeConnections(pointer, timeOut.inMilliseconds);

  connect(AudioNode destination, AudioNode source, [destIdx = 0, int srcIdx = 0]) {
    LabSound().AudioContext_connect(pointer, destination.nodeId, source.nodeId, destIdx, srcIdx);
  }
  disconnect(AudioNode destination, AudioNode source, [destIdx = 0, int srcIdx = 0]) {
    LabSound().AudioContext_disconnect(pointer, destination.nodeId, source.nodeId, destIdx, srcIdx);
  }

  disconnectCompletely(AudioNode destination, [int destIdx = 0]) {
    LabSound().AudioContext_disconnectCompletely(pointer, destination.nodeId, destIdx);
  }

  connectParam(AudioParam param, AudioNode driverNode, [int index = 0]) {
    LabSound().AudioContext_connectParam(pointer, param.nodeId, param.paramId, driverNode.nodeId, index);
  }

  connectParamByName(AudioNode destinationNode, String parameterName, AudioNode driverNode, [int index = 0]) {
    LabSound().AudioContext_connectParamByName(pointer, destinationNode.nodeId, parameterName.toInt8(), driverNode.nodeId, index);
  }

  disconnectParam(AudioParam param, AudioNode driverNode, [int index = 0]) {
    LabSound().AudioContext_disconnectParam(pointer, param.nodeId, param.paramId, driverNode.nodeId, index);
  }

  suspend() {
    LabSound().AudioContext_suspend(this.pointer);
    _onRunning.sink.add(false);
  }

  resume() {
    LabSound().AudioContext_resume(this.pointer);
    _onRunning.sink.add(true);
  }

  Future<bool> startOfflineRendering() async {
    final id = LabSound().AudioContext_startOfflineRendering(this.pointer);
    if(id < 0) return false;
    final result = await LabSound().onOfflineRenderComplete.firstWhere((element) => element.id == id);
    return result.status > 0;
  }

  AudioHardwareDeviceNode get destination => this.device;

  AudioNode makeAudioHardwareInputNode() => AudioNode(this, LabSound().AudioContext_makeAudioHardwareInputNode(this.pointer));
  
  dispose() {
    LabSound().allNodes.forEach((node) {
      if(!node.released) {
        node.dispose();
      }
    });
    _onRunning.close();
    LabSound().AudioContext_releaseContext(this.pointer);
  }
}
