import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'lab_sound.dart';

class AnalyserNode extends AudioNode {

  Pointer<Float>? bufferFloatPtr;
  int? bufferFloatSize;


  AnalyserNode(AudioContext ctx, { int? fftSize }): super(ctx, fftSize == null ? LabSound().createAnalyserNode(ctx.pointer) : LabSound().createAnalyserNodeFftSize(ctx.pointer, fftSize));

  setFftSize(int fftSize) => LabSound().AnalyserNode_setFftSize(this.nodeId, this.ctx.pointer, fftSize);
  int get fftSize => LabSound().AnalyserNode_fftSize(this.nodeId);

  int get frequencyBinCount => LabSound().AnalyserNode_frequencyBinCount(this.nodeId);

  setMinDecibels(double k) => LabSound().AnalyserNode_setMinDecibels(this.nodeId, k);
  int get minDecibels => LabSound().AnalyserNode_minDecibels(this.nodeId);

  setMaxDecibels(double k) => LabSound().AnalyserNode_setMaxDecibels(this.nodeId, k);
  int get maxDecibels => LabSound().AnalyserNode_maxDecibels(this.nodeId);


  setSmoothingTimeConstant(double k) => LabSound().AnalyserNode_setSmoothingTimeConstant(this.nodeId, k);
  int get smoothingTimeConstant => LabSound().AnalyserNode_smoothingTimeConstant(this.nodeId);

  getFloatFrequencyData() {

    bufferFloatSize ??= frequencyBinCount;
    bufferFloatPtr ??= malloc.allocate<Float>(sizeOf<Float>() * bufferFloatSize!);
    LabSound().AnalyserNode_getFloatFrequencyData(this.nodeId, bufferFloatPtr!);
    final list = List<double>.filled(bufferFloatSize!, 0.0);
    for(int i = 0; i < bufferFloatSize!; i++) {
      list[i] = bufferFloatPtr!.elementAt(i).value;
    }
    print("getFloatFrequencyData: ${list}");
  }

/*
  *


void AnalyserNode_getFloatFrequencyData(int nodeIndex, float * array);

  * */

}