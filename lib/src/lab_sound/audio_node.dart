import 'dart:ffi';
import 'package:ffi/ffi.dart';
import '../extensions/ffi_string.dart';
import 'audio_context.dart';
import 'lab_sound.dart';

enum SchedulingState {
UNSCHEDULED, // Initial playback state. Created, but not yet scheduled
SCHEDULED,       // Scheduled to play (via noteOn() or noteGrainOn()), but not yet playing
FADE_IN,         // First epoch, fade in, then play
PLAYING,         // Generating sound
STOPPING,        // Transitioning to finished
RESETTING,       // Node is resetting to initial, unscheduled state
FINISHING,       // Playing has finished
FINISHED         // Node has finished
}

class AudioNode {
  final int nodeId;
  AudioContext ctx;

  AudioNode(this.ctx, this.nodeId) {
    LabSound().allNodes.add(this);
  }

  /// 已释放
  bool get released => LabSound().hasNode(nodeId) < 1;

  List<AudioNode> linked = [];

  String get name => (Pointer<Utf8>.fromAddress(LabSound().AudioNode_name(nodeId).address)).toStr();

  bool get isScheduledNode => LabSound().AudioNode_isScheduledNode(nodeId) > 0;

  int get numberOfInputs => LabSound().AudioNode_numberOfInputs(nodeId);
  int get numberOfOutputs => LabSound().AudioNode_numberOfOutputs(nodeId);
  int get channelCount => LabSound().AudioNode_channelCount(nodeId);

  initialize() => LabSound().AudioNode_initialize(nodeId);
  uninitialize() => LabSound().AudioNode_uninitialize(nodeId);

  connect(AudioNode dst, [destIdx = 0, int srcIdx = 0]) {
    linked.add(dst);
    LabSound().AudioContext_connect(ctx.pointer, dst.nodeId, nodeId, destIdx, srcIdx);
  }
  disconnect(AudioNode dst, [destIdx = 0, int srcIdx = 0]) {
    linked.remove(dst);
    LabSound().AudioContext_disconnect(ctx.pointer, dst.nodeId, nodeId, destIdx, srcIdx);
  }
  disconnectAll() {
    linked.toList().forEach((element) {
      LabSound().AudioContext_disconnect(ctx.pointer, element.nodeId, nodeId, 0, 0);
    });
    linked.clear();
  }
  dispose() {
    this.disconnectAll();
    LabSound().releaseNode(this.nodeId);
  }
  reset() {
    LabSound().AudioNode_reset(nodeId, ctx.pointer);
  }

  @override
  String toString() => "[$nodeId]$name";

}
