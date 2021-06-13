import 'audio_context.dart';
import 'audio_node.dart';
import 'audio_param.dart';
import 'lab_sound.dart';

class DelayNode extends AudioNode {
  late AudioParam delayTime;
  DelayNode(AudioContext ctx): super(ctx, LabSound().createGain(ctx.pointer)) {
    this.delayTime = AudioParam(this.ctx, this.nodeId, LabSound().DelayNode_delayTime(this.nodeId));
  }

  DelayNode.fromId(AudioContext ctx, int id): super(ctx, id) {
    this.delayTime = AudioParam(this.ctx, this.nodeId, LabSound().DelayNode_delayTime(this.nodeId));
  }

}