import 'audio_context.dart';
import 'audio_node.dart';
import 'lab_sound.dart';

class ChannelSplitterNode extends AudioNode {
  ChannelSplitterNode(AudioContext ctx): super(ctx, LabSound().createChannelSplitterNode(ctx.pointer));
  addInputs(int n) => LabSound().ChannelSplitterNode_addOutputs(nodeId, n);
}