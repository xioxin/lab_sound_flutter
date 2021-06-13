import 'package:lab_sound_flutter/lab_sound_flutter.dart';

import 'audio_context.dart';
import 'audio_node.dart';
import 'audio_param.dart';
import 'lab_sound.dart';

class ConvolverNode extends AudioNode {
  late AudioParam delayTime;
  ConvolverNode(AudioContext ctx): super(ctx, LabSound().createConvolverNode(ctx.pointer));

  bool get normalize => LabSound().ConvolverNode_normalize(this.nodeId) > 0;
  set normalize(bool v) => LabSound().ConvolverNode_setNormalize(this.nodeId, v ? 1 : 0);

  setImpulse(AudioBus bus) => LabSound().ConvolverNode_setImpulse(nodeId, bus.resourceId);

}