import 'audio_context.dart';
import 'audio_node.dart';
import 'audio_scheduled_source_node.dart';
import 'lab_sound.dart';


enum NoiseType {
  WHITE,
  PINK,
  BROWN,
}


class NoiseNode extends AudioScheduledSourceNode {

  NoiseNode(AudioContext ctx): super(ctx, LabSound().createNoiseNode(ctx.pointer));

  NoiseType get type => NoiseType.values[LabSound().NoiseNode_type(nodeId)];
  set type(NoiseType type) => LabSound().NoiseNode_setType(nodeId, type.index);

}