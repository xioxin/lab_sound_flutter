import 'audio_param.dart';
import 'audio_context.dart';
import 'audio_node.dart';
import 'lab_sound.dart';
class ADSRNode extends AudioNode {
  late AudioParam gate;
  late AudioParam oneShot;
  late AudioParam attackTime;
  late AudioParam attackLevel;
  late AudioParam decayTime;
  late AudioParam sustainTime;
  late AudioParam sustainLevel;
  late AudioParam releaseTime;
  ADSRNode(AudioContext ctx, int nodeId) : super(ctx, LabSound().createADSRNode(ctx.pointer)) {
    gate = AudioParam(ctx, nodeId, LabSound().ADSRNode_gate(nodeId));
    oneShot = AudioParam(ctx , nodeId, LabSound().ADSRNode_oneShot(nodeId));
    attackTime = AudioParam(ctx, nodeId, LabSound().ADSRNode_attackTime(nodeId));
    attackLevel = AudioParam(ctx , nodeId, LabSound().ADSRNode_attackLevel(nodeId));
    decayTime = AudioParam(ctx , nodeId, LabSound().ADSRNode_decayTime(nodeId));
    sustainTime = AudioParam(ctx , nodeId, LabSound().ADSRNode_sustainTime(nodeId));
    sustainLevel = AudioParam(ctx, nodeId, LabSound().ADSRNode_sustainLevel(nodeId));
    releaseTime = AudioParam(ctx , nodeId, LabSound().ADSRNode_releaseTime(nodeId));
  }
}