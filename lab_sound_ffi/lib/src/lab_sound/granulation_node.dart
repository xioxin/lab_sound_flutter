import 'package:lab_sound_ffi/lab_sound_ffi.dart';

enum WindowFunction {
  rectangle, // aka the boxcar or Dirichlet window
  cosine, // aka the sine window
  hann, // generalized raised cosine, order 1, aka the raised cosine window
  hamming, // generalized raised cosine, order 1 (modified hann)
  blackman, // generalized raised cosine, order 2
  nutall, // generalized raised cosine, order 3
  blackmanHarris, // generalized raised cosine, order 3
  blackmanNutall, // generalized raised cosine, order 3
  hannPoisson, // Hann window multiplied by a Poisson window
  gaussian50, // gaussian with a sigma of 0.50
  gaussian25, // gaussian with a sigma of 0.25
  welch, //
  bartlett, // aka the (symmetric) triangular window
  bartlettHann, //
  parzen, // B-spline, order 4 (a triangle shape)
  flatTop, // generalized raised cosine, order 4
  lanczos // aka the sinc window
}

class GranulationNode extends AudioScheduledSourceNode {
  late AudioSettingEnumeration _windowFunc;
  late AudioParam numGrains;
  late AudioParam grainDuration;
  late AudioParam grainPositionMin;
  late AudioParam grainPositionMax;
  late AudioParam grainPlaybackFreq;

  GranulationNode(AudioContext ctx)
      : super(ctx, LabSound().createGranulationNode(ctx.pointer)) {
    _windowFunc = AudioSettingEnumeration(
        ctx, nodeId, LabSound().GranulationNode_windowFunc(nodeId));
    numGrains =
        AudioParam(ctx, nodeId, LabSound().GranulationNode_numGrains(nodeId));
    grainDuration = AudioParam(
        ctx, nodeId, LabSound().GranulationNode_grainDuration(nodeId));
    grainPositionMin = AudioParam(
        ctx, nodeId, LabSound().GranulationNode_grainPositionMin(nodeId));
    grainPlaybackFreq = AudioParam(
        ctx, nodeId, LabSound().GranulationNode_grainPlaybackFreq(nodeId));
  }

  AudioBus? resource;
  setGrainSource(AudioBus resource) {
    this.resource= resource;
    LabSound().GranulationNode_setGrainSource(
        nodeId, ctx.pointer, resource.resourceId);
  }

  AudioBus getGrainSource() {
    return AudioBus.fromId(LabSound().GranulationNode_getGrainSource(nodeId));
  }

  WindowFunction get windowFunc => WindowFunction.values[_windowFunc.value];
  set windowFunc(WindowFunction val) {
    _windowFunc.setValue(val.index);
  }
}
