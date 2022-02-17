import 'audio_context.dart';
import 'audio_node.dart';
import 'audio_param.dart';
import 'lab_sound.dart';

class DynamicsCompressorNode extends AudioNode {

  late AudioParam threshold;
  late AudioParam knee;
  late AudioParam ratio;
  late AudioParam attack;
  late AudioParam release;

  late AudioParam reduction;

  DynamicsCompressorNode(AudioContext ctx): super(ctx, LabSound().createDynamicsCompressorNode(ctx.pointer)) {
    threshold = AudioParam(this.ctx, this.nodeId, LabSound().DynamicsCompressorNode_threshold(this.nodeId));
    knee = AudioParam(this.ctx, this.nodeId, LabSound().DynamicsCompressorNode_knee(this.nodeId));
    ratio = AudioParam(this.ctx, this.nodeId, LabSound().DynamicsCompressorNode_ratio(this.nodeId));
    attack = AudioParam(this.ctx, this.nodeId, LabSound().DynamicsCompressorNode_attack(this.nodeId));
    release = AudioParam(this.ctx, this.nodeId, LabSound().DynamicsCompressorNode_release(this.nodeId));
    reduction = AudioParam(this.ctx, this.nodeId, LabSound().DynamicsCompressorNode_reduction(this.nodeId));
  }

}