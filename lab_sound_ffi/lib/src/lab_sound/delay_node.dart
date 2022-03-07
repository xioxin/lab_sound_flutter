import 'audio_context.dart';
import 'audio_node.dart';
import 'audio_setting.dart';
import 'lab_sound.dart';

class DelayNode extends AudioNode {
  late AudioSettingFloat delayTime;
  DelayNode(AudioContext ctx): super(ctx, LabSound().createDelayNode(ctx.pointer)) {
    delayTime = AudioSettingFloat(this.ctx, nodeId, LabSound().DelayNode_delayTime(nodeId));
  }

  DelayNode.fromId(AudioContext ctx, int id): super(ctx, id) {
    delayTime = AudioSettingFloat(this.ctx, nodeId, LabSound().DelayNode_delayTime(nodeId));
  }

}