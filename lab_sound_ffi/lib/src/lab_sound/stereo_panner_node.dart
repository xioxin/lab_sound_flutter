import 'audio_context.dart';
import 'audio_node.dart';
import 'audio_param.dart';
import 'lab_sound.dart';

class StereoPannerNode extends AudioNode {
  late AudioParam delayTime;
  StereoPannerNode(AudioContext ctx): super(ctx, LabSound().createStereoPannerNode(ctx.pointer)) {
    delayTime = AudioParam(this.ctx, nodeId, LabSound().StereoPannerNode_pan(nodeId));
  }
}