import 'audio_context.dart';
import 'audio_node.dart';
import 'lab_sound.dart';

class ChannelMergerNode extends AudioNode {
  ChannelMergerNode(AudioContext ctx, {int numberOfInputs = 1}): super(ctx, LabSound().createChannelMergerNode(ctx.pointer, numberOfInputs));
  addInputs(int n) => LabSound().ChannelMergerNode_addInputs(nodeId, n);
  setOutputChannelCount(int n) => LabSound().ChannelMergerNode_setOutputChannelCount(nodeId, n);
}