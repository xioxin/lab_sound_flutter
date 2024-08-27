import 'audio_context.dart';
import 'audio_node.dart';
import 'lab_sound.dart';

class ChannelSplitterNode extends AudioNode {
  ChannelSplitterNode(AudioContext ctx, {int numberOfOutputs = 1}): super(ctx, LabSound().createChannelSplitterNode(ctx.pointer, numberOfOutputs));
  addInputs(int n) => LabSound().ChannelSplitterNode_addOutputs(nodeId, n);
}