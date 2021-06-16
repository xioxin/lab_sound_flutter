import 'audio_context.dart';
import 'audio_param.dart';
import 'audio_scheduled_source_node.dart';
import 'lab_sound.dart';

enum OscillatorType {
  oscillatorNone,
  sine,
  fastSine,
  square,
  sawtooth,
  triangle,
  custom,
}

class OscillatorNode extends AudioScheduledSourceNode {

  late AudioParam amplitude;
  late AudioParam frequency;
  late AudioParam detune;
  late AudioParam bias;

  OscillatorNode(AudioContext ctx)
      : super(ctx, LabSound().createOscillatorNode(ctx.pointer)) {
    amplitude = AudioParam(this.ctx, this.nodeId, LabSound().OscillatorNode_amplitude(this.nodeId));
    frequency = AudioParam(this.ctx, this.nodeId, LabSound().OscillatorNode_frequency(this.nodeId));
    detune = AudioParam(this.ctx, this.nodeId, LabSound().OscillatorNode_detune(this.nodeId));
    bias = AudioParam(this.ctx, this.nodeId, LabSound().OscillatorNode_bias(this.nodeId));
  }

  OscillatorType get type => OscillatorType.values[LabSound().OscillatorNode_type(nodeId)];
  set type(OscillatorType type) => setType(type);

  setType(OscillatorType type) {
    LabSound().OscillatorNode_setType(nodeId, type.index);
  }

  @override
  dispose() {
    super.dispose();
  }
}
