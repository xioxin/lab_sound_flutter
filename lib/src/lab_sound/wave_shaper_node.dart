import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'audio_context.dart';
import 'audio_node.dart';
import 'lab_sound.dart';

class WaveShaperNode extends AudioNode {
  WaveShaperNode(AudioContext ctx): super(ctx, LabSound().createWaveShaperNode(ctx.pointer));

  setCurve(List<double> curve) {
    final curvePtr = malloc.allocate<Float>(curve.length);
    for (int i = 0; i < curve.length; i++) {
      curvePtr[i] = curve[i];
    }
    LabSound().WaveShaperNode_setCurve(nodeId, curvePtr);
    malloc.free(curvePtr);
  }
}