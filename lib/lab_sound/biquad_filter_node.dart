import 'lab_sound.dart';

enum FilterType {
  FILTER_NONE,
  LOWPASS,
  HIGHPASS,
  BANDPASS,
  LOWSHELF,
  HIGHSHELF,
  PEAKING,
  NOTCH,
  ALLPASS,
}

class BiquadFilterNode extends AudioNode {

  late AudioParam frequency;
  late AudioParam q;
  late AudioParam gain;
  late AudioParam detune;

  BiquadFilterNode(AudioContext ctx)
      : super(ctx, LabSound().createBiquadFilterNode(ctx.pointer)) {
    frequency = AudioParam(this.ctx, this.nodeId, LabSound().BiquadFilterNode_frequency(this.nodeId));
    q = AudioParam(this.ctx, this.nodeId, LabSound().BiquadFilterNode_q(this.nodeId));
    gain = AudioParam(this.ctx, this.nodeId, LabSound().BiquadFilterNode_gain(this.nodeId));
    detune = AudioParam(this.ctx, this.nodeId, LabSound().BiquadFilterNode_detune(this.nodeId));
  }

  FilterType get type => FilterType.values[LabSound().BiquadFilterNode_type(nodeId)];

  setType(FilterType type) {
    LabSound().BiquadFilterNode_setType(nodeId, type.index);
  }

  @override
  dispose() {
    super.dispose();
  }
}
