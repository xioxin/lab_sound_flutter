import 'audio_context.dart';
import 'audio_node.dart';
import 'audio_param.dart';
import 'lab_sound.dart';

class SfxrNode extends AudioNode {

  late AudioParam attackTime;
  late AudioParam sustainTime;
  late AudioParam sustainPunch;
  late AudioParam decayTime;
  late AudioParam startFrequency;
  late AudioParam minFrequency;
  late AudioParam slide;
  late AudioParam deltaSlide;
  late AudioParam vibratoDepth;
  late AudioParam vibratoSpeed;
  late AudioParam changeAmount;
  late AudioParam changeSpeed;
  late AudioParam squareDuty;
  late AudioParam dutySweep;
  late AudioParam repeatSpeed;
  late AudioParam phaserOffset;
  late AudioParam phaserSweep;
  late AudioParam lpFilterCutoff;
  late AudioParam lpFilterCutoffSweep;
  late AudioParam lpFiterResonance;
  late AudioParam hpFilterCutoff;
  late AudioParam hpFilterCutoffSweep;

  SfxrNode(AudioContext ctx): super(ctx, LabSound().createSfxrNode(ctx.pointer)) {
    attackTime = AudioParam(this.ctx, this.nodeId, LabSound().SfxrNode_attackTime(this.nodeId));
    sustainTime = AudioParam(this.ctx, this.nodeId, LabSound().SfxrNode_sustainTime(this.nodeId));
    sustainPunch = AudioParam(this.ctx, this.nodeId, LabSound().SfxrNode_sustainPunch(this.nodeId));
    decayTime = AudioParam(this.ctx, this.nodeId, LabSound().SfxrNode_decayTime(this.nodeId));
    startFrequency = AudioParam(this.ctx, this.nodeId, LabSound().SfxrNode_startFrequency(this.nodeId));
    minFrequency = AudioParam(this.ctx, this.nodeId, LabSound().SfxrNode_minFrequency(this.nodeId));
    slide = AudioParam(this.ctx, this.nodeId, LabSound().SfxrNode_slide(this.nodeId));
    deltaSlide = AudioParam(this.ctx, this.nodeId, LabSound().SfxrNode_deltaSlide(this.nodeId));
    vibratoDepth = AudioParam(this.ctx, this.nodeId, LabSound().SfxrNode_vibratoDepth(this.nodeId));
    vibratoSpeed = AudioParam(this.ctx, this.nodeId, LabSound().SfxrNode_vibratoSpeed(this.nodeId));
    changeAmount = AudioParam(this.ctx, this.nodeId, LabSound().SfxrNode_changeAmount(this.nodeId));
    changeSpeed = AudioParam(this.ctx, this.nodeId, LabSound().SfxrNode_changeSpeed(this.nodeId));
    squareDuty = AudioParam(this.ctx, this.nodeId, LabSound().SfxrNode_squareDuty(this.nodeId));
    dutySweep = AudioParam(this.ctx, this.nodeId, LabSound().SfxrNode_dutySweep(this.nodeId));
    repeatSpeed = AudioParam(this.ctx, this.nodeId, LabSound().SfxrNode_repeatSpeed(this.nodeId));
    phaserOffset = AudioParam(this.ctx, this.nodeId, LabSound().SfxrNode_phaserOffset(this.nodeId));
    phaserSweep = AudioParam(this.ctx, this.nodeId, LabSound().SfxrNode_phaserSweep(this.nodeId));
    lpFilterCutoff = AudioParam(this.ctx, this.nodeId, LabSound().SfxrNode_lpFilterCutoff(this.nodeId));
    lpFilterCutoffSweep = AudioParam(this.ctx, this.nodeId, LabSound().SfxrNode_lpFilterCutoffSweep(this.nodeId));
    lpFiterResonance = AudioParam(this.ctx, this.nodeId, LabSound().SfxrNode_lpFiterResonance(this.nodeId));
    hpFilterCutoff = AudioParam(this.ctx, this.nodeId, LabSound().SfxrNode_hpFilterCutoff(this.nodeId));
    hpFilterCutoffSweep = AudioParam(this.ctx, this.nodeId, LabSound().SfxrNode_hpFilterCutoffSweep(this.nodeId));
  }

  setStartFrequencyInHz(double value) => LabSound().SfxrNode_setStartFrequencyInHz(nodeId, value);
  setVibratoSpeedInHz(double value) => LabSound().SfxrNode_setVibratoSpeedInHz(nodeId, value);

  double envelopeTimeInSeconds(double sfxrEnvTime) => LabSound().SfxrNode_envelopeTimeInSeconds(nodeId, sfxrEnvTime);
  double envelopeTimeInSfxrUnits(double t) => LabSound().SfxrNode_envelopeTimeInSfxrUnits(nodeId, t);
  double frequencyInSfxrUnits(double hz) => LabSound().SfxrNode_frequencyInSfxrUnits(nodeId, hz);
  double frequencyInHz(double sfxr) => LabSound().SfxrNode_frequencyInHz(nodeId, sfxr);
  double vibratoInSfxrUnits(double hz) => LabSound().SfxrNode_vibratoInSfxrUnits(nodeId, hz);
  double vibratoInHz(double sfxr) => LabSound().SfxrNode_vibratoInHz(nodeId, sfxr);
  double filterFreqInHz(double sfxr) => LabSound().SfxrNode_filterFreqInHz(nodeId, sfxr);
  double filterFreqInSfxrUnits(double hz) => LabSound().SfxrNode_filterFreqInSfxrUnits(nodeId, hz);


  setDefaultBeep() => LabSound().SfxrNode_setDefaultBeep(nodeId);
  coin() => LabSound().SfxrNode_coin(nodeId);
  laser() => LabSound().SfxrNode_laser(nodeId);
  explosion() => LabSound().SfxrNode_explosion(nodeId);
  powerUp() => LabSound().SfxrNode_powerUp(nodeId);
  hit() => LabSound().SfxrNode_hit(nodeId);
  jump() => LabSound().SfxrNode_jump(nodeId);
  select() => LabSound().SfxrNode_select(nodeId);
  mutate() => LabSound().SfxrNode_mutate(nodeId);
  randomize() => LabSound().SfxrNode_randomize(nodeId);

}