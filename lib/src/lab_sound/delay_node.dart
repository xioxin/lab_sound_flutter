import 'audio_context.dart';
import 'audio_node.dart';
import 'audio_param.dart';
import 'audio_setting.dart';
import 'lab_sound.dart';

class DelayNode extends AudioNode {
  late AudioSettingFloat delayTime;
  DelayNode(AudioContext ctx): super(ctx, LabSound().createDelayNode(ctx.pointer)) {
    this.delayTime = AudioSettingFloat(this.ctx, this.nodeId, LabSound().DelayNode_delayTime(this.nodeId));
  }

  DelayNode.fromId(AudioContext ctx, int id): super(ctx, id) {
    this.delayTime = AudioSettingFloat(this.ctx, this.nodeId, LabSound().DelayNode_delayTime(this.nodeId));
  }

}