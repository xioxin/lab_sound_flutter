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
    threshold = AudioParam(this.ctx, nodeId, LabSound().DynamicsCompressorNode_threshold(nodeId));
    knee = AudioParam(this.ctx, nodeId, LabSound().DynamicsCompressorNode_knee(nodeId));
    ratio = AudioParam(this.ctx, nodeId, LabSound().DynamicsCompressorNode_ratio(nodeId));
    attack = AudioParam(this.ctx, nodeId, LabSound().DynamicsCompressorNode_attack(nodeId));
    release = AudioParam(this.ctx, nodeId, LabSound().DynamicsCompressorNode_release(nodeId));
    reduction = AudioParam(this.ctx, nodeId, LabSound().DynamicsCompressorNode_reduction(nodeId));
  }

}