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

  connect(AudioNode dst) {
    linked.add(dst);
    this.ctx.connect(dst, this);
  }
  disconnect(AudioNode dst) {
    linked.remove(dst);
    this.ctx.disconnect(dst, this);
  }
  disconnectAll() {
    linked.toList().forEach((element) {
      this.ctx.disconnect(element, this);
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
