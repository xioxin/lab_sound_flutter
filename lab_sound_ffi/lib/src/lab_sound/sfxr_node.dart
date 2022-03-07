import 'package:lab_sound_ffi/lab_sound_ffi.dart';


enum WaveType { square, sawtooth, sine, noise }

class SfxrNode extends AudioScheduledSourceNode {
  late AudioSettingEnumeration _waveType;

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

  SfxrNode(AudioContext ctx)
      : super(ctx, LabSound().createSfxrNode(ctx.pointer)) {
    attackTime = AudioParam(
        this.ctx, nodeId, LabSound().SfxrNode_attackTime(nodeId));
    sustainTime = AudioParam(
        this.ctx, nodeId, LabSound().SfxrNode_sustainTime(nodeId));
    sustainPunch = AudioParam(
        this.ctx, nodeId, LabSound().SfxrNode_sustainPunch(nodeId));
    decayTime = AudioParam(
        this.ctx, nodeId, LabSound().SfxrNode_decayTime(nodeId));
    startFrequency = AudioParam(
        this.ctx, nodeId, LabSound().SfxrNode_startFrequency(nodeId));
    minFrequency = AudioParam(
        this.ctx, nodeId, LabSound().SfxrNode_minFrequency(nodeId));
    slide = AudioParam(
        this.ctx, nodeId, LabSound().SfxrNode_slide(nodeId));
    deltaSlide = AudioParam(
        this.ctx, nodeId, LabSound().SfxrNode_deltaSlide(nodeId));
    vibratoDepth = AudioParam(
        this.ctx, nodeId, LabSound().SfxrNode_vibratoDepth(nodeId));
    vibratoSpeed = AudioParam(
        this.ctx, nodeId, LabSound().SfxrNode_vibratoSpeed(nodeId));
    changeAmount = AudioParam(
        this.ctx, nodeId, LabSound().SfxrNode_changeAmount(nodeId));
    changeSpeed = AudioParam(
        this.ctx, nodeId, LabSound().SfxrNode_changeSpeed(nodeId));
    squareDuty = AudioParam(
        this.ctx, nodeId, LabSound().SfxrNode_squareDuty(nodeId));
    dutySweep = AudioParam(
        this.ctx, nodeId, LabSound().SfxrNode_dutySweep(nodeId));
    repeatSpeed = AudioParam(
        this.ctx, nodeId, LabSound().SfxrNode_repeatSpeed(nodeId));
    phaserOffset = AudioParam(
        this.ctx, nodeId, LabSound().SfxrNode_phaserOffset(nodeId));
    phaserSweep = AudioParam(
        this.ctx, nodeId, LabSound().SfxrNode_phaserSweep(nodeId));
    lpFilterCutoff = AudioParam(
        this.ctx, nodeId, LabSound().SfxrNode_lpFilterCutoff(nodeId));
    lpFilterCutoffSweep = AudioParam(this.ctx, nodeId,
        LabSound().SfxrNode_lpFilterCutoffSweep(nodeId));
    lpFiterResonance = AudioParam(this.ctx, nodeId,
        LabSound().SfxrNode_lpFiterResonance(nodeId));
    hpFilterCutoff = AudioParam(
        this.ctx, nodeId, LabSound().SfxrNode_hpFilterCutoff(nodeId));
    hpFilterCutoffSweep = AudioParam(this.ctx, nodeId,
        LabSound().SfxrNode_hpFilterCutoffSweep(nodeId));
    _waveType = AudioSettingEnumeration(
        ctx, nodeId, LabSound().SfxrNode_waveType(nodeId));
  }

  WaveType get waveType => WaveType.values[_waveType.value];
  set waveType(WaveType val) {
    _waveType.setValue(val.index);
  }

  setStartFrequencyInHz(double value) =>
      LabSound().SfxrNode_setStartFrequencyInHz(nodeId, value);
  setVibratoSpeedInHz(double value) =>
      LabSound().SfxrNode_setVibratoSpeedInHz(nodeId, value);

  double envelopeTimeInSeconds(double sfxrEnvTime) =>
      LabSound().SfxrNode_envelopeTimeInSeconds(nodeId, sfxrEnvTime);
  double envelopeTimeInSfxrUnits(double t) =>
      LabSound().SfxrNode_envelopeTimeInSfxrUnits(nodeId, t);
  double frequencyInSfxrUnits(double hz) =>
      LabSound().SfxrNode_frequencyInSfxrUnits(nodeId, hz);
  double frequencyInHz(double sfxr) =>
      LabSound().SfxrNode_frequencyInHz(nodeId, sfxr);
  double vibratoInSfxrUnits(double hz) =>
      LabSound().SfxrNode_vibratoInSfxrUnits(nodeId, hz);
  double vibratoInHz(double sfxr) =>
      LabSound().SfxrNode_vibratoInHz(nodeId, sfxr);
  double filterFreqInHz(double sfxr) =>
      LabSound().SfxrNode_filterFreqInHz(nodeId, sfxr);
  double filterFreqInSfxrUnits(double hz) =>
      LabSound().SfxrNode_filterFreqInSfxrUnits(nodeId, hz);

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
