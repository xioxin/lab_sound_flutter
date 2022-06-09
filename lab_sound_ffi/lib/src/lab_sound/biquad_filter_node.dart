import 'audio_context.dart';
import 'audio_node.dart';
import 'audio_param.dart';
import 'lab_sound.dart';

enum FilterType {
  filterNone,
  lowPass,
  highPass,
  bandpass,
  lowShelf,
  highShelf,
  peaking,
  notch,
  allPass,
}

class BiquadFilterNode extends AudioNode {

  late AudioParam frequency;
  late AudioParam q;
  late AudioParam gain;
  late AudioParam detune;

  BiquadFilterNode(AudioContext ctx)
      : super(ctx, LabSound().createBiquadFilterNode(ctx.pointer)) {
    frequency = AudioParam(this.ctx, nodeId, LabSound().BiquadFilterNode_frequency(nodeId));
    q = AudioParam(this.ctx, nodeId, LabSound().BiquadFilterNode_q(nodeId));
    gain = AudioParam(this.ctx, nodeId, LabSound().BiquadFilterNode_gain(nodeId));
    detune = AudioParam(this.ctx, nodeId, LabSound().BiquadFilterNode_detune(nodeId));
  }

  FilterType get type => FilterType.values[LabSound().BiquadFilterNode_type(nodeId)];
  set type(FilterType type) {
    LabSound().BiquadFilterNode_setType(nodeId, type.index);
  }

}
