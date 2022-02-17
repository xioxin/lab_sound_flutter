import 'audio_context.dart';
import 'audio_node.dart';
import 'lab_sound.dart';

class ChannelMergerNode extends AudioNode {
  ChannelMergerNode(AudioContext ctx): super(ctx, LabSound().createChannelMergerNode(ctx.pointer));
  addInputs(int n) => LabSound().ChannelMergerNode_addInputs(nodeId, n);
  setOutputChannelCount(int n) => LabSound().ChannelMergerNode_setOutputChannelCount(nodeId, n);
}