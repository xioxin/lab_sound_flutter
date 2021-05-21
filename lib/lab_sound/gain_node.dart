import 'lab_sound.dart';
class GainNode extends AudioNode {
  late AudioParam gain;
  GainNode(AudioContext ctx): super(ctx, LabSound().createGain(ctx.pointer)) {
    this.gain = AudioParam(this.ctx, this.nodeId, LabSound().GainNode_gain(this.nodeId));
  }
}