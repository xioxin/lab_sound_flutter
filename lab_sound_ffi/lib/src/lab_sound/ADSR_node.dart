import 'package:lab_sound_ffi/lab_sound_ffi.dart';

import 'audio_param.dart';
import 'audio_context.dart';
import 'audio_node.dart';
import 'lab_sound.dart';
import 'audio_setting.dart';
class ADSRNode extends AudioNode {
  late AudioParam gate;
  late AudioSettingBool oneShot;
  late AudioSettingFloat attackTime;
  late AudioSettingFloat attackLevel;
  late AudioSettingFloat decayTime;
  late AudioSettingFloat sustainTime;
  late AudioSettingFloat sustainLevel;
  late AudioSettingFloat releaseTime;
  ADSRNode(AudioContext ctx) : super(ctx, LabSound().createADSRNode(ctx.pointer)) {
    gate = AudioParam(ctx, nodeId, LabSound().ADSRNode_gate(nodeId));
    oneShot = AudioSettingBool(ctx , nodeId, LabSound().ADSRNode_oneShot(nodeId));
    attackTime = AudioSettingFloat(ctx, nodeId, LabSound().ADSRNode_attackTime(nodeId));
    attackLevel = AudioSettingFloat(ctx , nodeId, LabSound().ADSRNode_attackLevel(nodeId));
    decayTime = AudioSettingFloat(ctx , nodeId, LabSound().ADSRNode_decayTime(nodeId));
    sustainTime = AudioSettingFloat(ctx , nodeId, LabSound().ADSRNode_sustainTime(nodeId));
    sustainLevel = AudioSettingFloat(ctx, nodeId, LabSound().ADSRNode_sustainLevel(nodeId));
    releaseTime = AudioSettingFloat(ctx , nodeId, LabSound().ADSRNode_releaseTime(nodeId));
  }

  set(double attackTime, double attackLevel, double decayTime, double sustainTime, double sustainLevel, double releaseTime) => LabSound().ADSRNode_set(nodeId, attackTime, attackLevel, decayTime, sustainTime, sustainLevel, releaseTime);

  bool get finished => LabSound().ADSRNode_finished(nodeId, ctx.pointer) > 0;

}