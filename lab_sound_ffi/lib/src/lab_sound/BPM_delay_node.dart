import 'package:lab_sound_ffi/lab_sound_ffi.dart';

enum TempoSync {
  TS_32,
  TS_16T,
  TS_32D,
  TS_16,
  TS_8T,
  TS_16D,
  TS_8,
  TS_4T,
  TS_8D,
  TS_4,
  TS_2T,
  TS_4D,
  TS_2,
  TS_2D,
}

class BPMDelayNode extends DelayNode {
  BPMDelayNode(AudioContext ctx, double tempo): super.fromId(ctx, LabSound().createBPMDelayNode(ctx.pointer, tempo));
  setTempo(double newTempo) => LabSound().BPMDelayNode_setTempo(nodeId, newTempo);
  setDelayIndex(TempoSync value) => LabSound().BPMDelayNode_setDelayIndex(nodeId, value.index);
}