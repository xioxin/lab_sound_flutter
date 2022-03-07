import 'package:lab_sound_ffi/lab_sound_ffi.dart';


class ConvolverNode extends AudioNode {
  late AudioParam delayTime;
  ConvolverNode(AudioContext ctx): super(ctx, LabSound().createConvolverNode(ctx.pointer));

  bool get normalize => LabSound().ConvolverNode_normalize(nodeId) > 0;
  set normalize(bool v) => LabSound().ConvolverNode_setNormalize(nodeId, v ? 1 : 0);

  setImpulse(AudioBus bus) => LabSound().ConvolverNode_setImpulse(nodeId, bus.resourceId);

}