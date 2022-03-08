import 'package:lab_sound_ffi/lab_sound_ffi.dart';

enum ClipMode { clip, tanh }

class ClipNode extends AudioNode {
  late AudioParam aVal;
  late AudioParam bVal;
  ClipNode(AudioContext ctx)
      : super(ctx, LabSound().createClipNode(ctx.pointer)) {
    aVal = AudioParam(ctx, nodeId, LabSound().ClipNode_aVal(nodeId));
    bVal = AudioParam(ctx, nodeId, LabSound().ClipNode_bVal(nodeId));
  }
  setMode(ClipMode mode) {
    LabSound().ClipNode_setMode(nodeId, mode.index);
  }
}
