import 'audio_context.dart';
import 'audio_param.dart';
import 'audio_scheduled_source_node.dart';
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


class PolyBLEPNode extends AudioScheduledSourceNode {
  late AudioParam amplitude;
  late AudioParam frequency;
  PolyBLEPNode(AudioContext ctx): super(ctx, LabSound().createPolyBLEPNode(ctx.pointer)) {
    amplitude = AudioParam(this.ctx, nodeId, LabSound().PolyBLEPNode_amplitude(nodeId));
    frequency = AudioParam(this.ctx, nodeId, LabSound().PolyBLEPNode_frequency(nodeId));
  }

  PolyBLEPType get type => PolyBLEPType.values[LabSound().PolyBLEPNode_type(nodeId)];
  set type(PolyBLEPType type) => LabSound().PolyBLEPNode_setType(nodeId, type.index);

}

