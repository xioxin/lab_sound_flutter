import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart';
import '../extensions/ffi_string.dart';
import 'audio_context.dart';
import 'audio_param.dart';
import 'lab_sound.dart';

enum SchedulingState {
  unscheduled, // Initial playback state. Created, but not yet scheduled
  scheduled, // Scheduled to play (via noteOn() or noteGrainOn()), but not yet playing
  fadeIn, // First epoch, fade in, then play
  playing, // Generating sound
  stopping, // Transitioning to finished
  resetting, // Node is resetting to initial, unscheduled state
  finishing, // Playing has finished
  finished // Node has finished
}

abstract class AudioConnectable {
  AudioContext ctx;

  AudioConnectable(this.ctx);

  int get inputNodeId;
  int get outputNodeId;

  int get numberOfInputs;
  int get numberOfOutputs;
  int get channelCount;

  List<AudioConnectable> linked = [];

  connect(AudioConnectable dst, [destIdx = 0, int srcIdx = 0]) {
    linked.add(dst);
    LabSound().AudioContext_connect(
        ctx.pointer, dst.inputNodeId, outputNodeId, destIdx, srcIdx);
  }

  disconnect([AudioConnectable? dst, destIdx = 0, int srcIdx = 0]) {
    linked.remove(dst);
    LabSound().AudioContext_disconnect(
        ctx.pointer, dst?.inputNodeId ?? -1, outputNodeId, destIdx, srcIdx);
  }

  dispose();

  operator >> (AudioConnectable otherNode) {
    connect(otherNode);
    return otherNode;
  }
}

abstract class CombinationAudioNode extends AudioConnectable {
  CombinationAudioNode(AudioContext ctx) : super(ctx);

  AudioNode get input;
  AudioNode get output;

  @override
  int get numberOfInputs => input.numberOfInputs;
  @override
  int get numberOfOutputs => output.numberOfOutputs;
  @override
  int get channelCount => output.channelCount;

  @override
  int get inputNodeId => input.nodeId;

  @override
  int get outputNodeId => output.nodeId;
}


final Finalizer<AudioNode> _audioNodeFinalizer = Finalizer((node) {
  print('_audioNodeFinalizer: $node');
  node.dispose();
});

class AudioNode extends AudioConnectable {
  final int nodeId;
  AudioContext ctx;

  @override
  int get inputNodeId => nodeId;
  @override
  int get outputNodeId => nodeId;

  AudioNode(this.ctx, this.nodeId) : super(ctx) {
    _audioNodeFinalizer.attach(this, this, detach: this);
    LabSound().nodeMap[nodeId] = WeakReference(this);
  }

  bool get released => LabSound().hasNode(nodeId) < 1;

  int get useCount => LabSound().AudioNode_useCount(nodeId);

  String get name =>
      (Pointer<Utf8>.fromAddress(LabSound().AudioNode_name(nodeId).address))
          .toStr();

  bool get isScheduledNode => LabSound().AudioNode_isScheduledNode(nodeId) > 0;

  @override
  int get numberOfInputs => LabSound().AudioNode_numberOfInputs(nodeId);
  @override
  int get numberOfOutputs => LabSound().AudioNode_numberOfOutputs(nodeId);
  @override
  int get channelCount => LabSound().AudioNode_channelCount(nodeId);

  double get tailTime => LabSound().AudioNode_tailTime(nodeId, ctx.pointer);
  double get latencyTime =>
      LabSound().AudioNode_latencyTime(nodeId, ctx.pointer);

  bool get isInitialized => LabSound().AudioNode_isInitialized(nodeId) > 0;

  initialize() => LabSound().AudioNode_initialize(nodeId);
  uninitialize() => LabSound().AudioNode_uninitialize(nodeId);

  @override
  dispose() {
    ctx.disconnectCompletely(this);
    LabSound().releaseNode(nodeId);
  }

  connectParam(AudioParam destination, [int output = 0]) {
    ctx.connectParam(destination, this, output);
  }

  reset() {
    LabSound().AudioNode_reset(nodeId, ctx.pointer);
  }

  @override
  String toString() => "[$nodeId]$name";
}
