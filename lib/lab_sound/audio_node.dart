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

  AudioNode(this.ctx, this.nodeId);

  /// 已释放
  bool released = false;

  List<AudioNode> linked = [];

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
    released = true;
    this.disconnectAll();
    LabSound().releaseNode(this.nodeId);
  }
  reset() {
    LabSound().AudioNode_reset(nodeId, ctx.pointer);
  }
}
