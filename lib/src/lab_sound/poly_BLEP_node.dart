import 'audio_context.dart';
import 'audio_node.dart';
import 'audio_param.dart';
import 'lab_sound.dart';

enum PolyBLEPType {
  TRIANGLE,
  SQUARE,
  RECTANGLE,
  SAWTOOTH,
  RAMP,
  MODIFIED_TRIANGLE,
  MODIFIED_SQUARE,
  HALF_WAVE_RECTIFIED_SINE,
  FULL_WAVE_RECTIFIED_SINE,
  TRIANGULAR_PULSE,
  TRAPEZOID_FIXED,
  TRAPEZOID_VARIABLE,
}


class PolyBLEPNode extends AudioNode {
  late AudioParam amplitude;
  late AudioParam frequency;
  PolyBLEPNode(AudioContext ctx): super(ctx, LabSound().createPolyBLEPNode(ctx.pointer)) {
    this.amplitude = AudioParam(this.ctx, this.nodeId, LabSound().PolyBLEPNode_amplitude(this.nodeId));
    this.frequency = AudioParam(this.ctx, this.nodeId, LabSound().PolyBLEPNode_frequency(this.nodeId));
  }

  PolyBLEPType get type => PolyBLEPType.values[LabSound().PolyBLEPNode_type(this.nodeId)];
  set type(PolyBLEPType type) => LabSound().PolyBLEPNode_setType(this.nodeId, type.index);

}

