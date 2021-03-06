import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'audio_context.dart';
import 'audio_node.dart';
import 'audio_param.dart';
import 'lab_sound.dart';

enum PanningMode  {
  PANNING_NONE,
  EQUALPOWER,
  HRTF,
}

enum DistanceModel {
  LINEAR_DISTANCE,
  INVERSE_DISTANCE,
  EXPONENTIAL_DISTANCE,
}

class AzimuthElevationData {
  final double outAzimuth;
  final double outElevation;
  AzimuthElevationData(this.outAzimuth, this.outElevation);
}

class PannerNode extends AudioNode {

  late AudioParam positionX;
  late AudioParam positionY;
  late AudioParam positionZ;

  late AudioParam orientationX;
  late AudioParam orientationY;
  late AudioParam orientationZ;

  late AudioParam velocityX;
  late AudioParam velocityY;
  late AudioParam velocityZ;

  late AudioParam distanceGain;
  late AudioParam coneGain;


  PannerNode(AudioContext ctx): super(ctx, LabSound().createPannerNode(ctx.pointer)) {

    this.positionX = AudioParam(this.ctx, this.nodeId, LabSound().PannerNode_positionX(this.nodeId));
    this.positionY = AudioParam(this.ctx, this.nodeId, LabSound().PannerNode_positionY(this.nodeId));
    this.positionZ = AudioParam(this.ctx, this.nodeId, LabSound().PannerNode_positionZ(this.nodeId));

    this.orientationX = AudioParam(this.ctx, this.nodeId, LabSound().PannerNode_orientationX(this.nodeId));
    this.orientationY = AudioParam(this.ctx, this.nodeId, LabSound().PannerNode_orientationY(this.nodeId));
    this.orientationZ = AudioParam(this.ctx, this.nodeId, LabSound().PannerNode_orientationZ(this.nodeId));

    this.velocityX = AudioParam(this.ctx, this.nodeId, LabSound().PannerNode_velocityX(this.nodeId));
    this.velocityY = AudioParam(this.ctx, this.nodeId, LabSound().PannerNode_velocityY(this.nodeId));
    this.velocityZ = AudioParam(this.ctx, this.nodeId, LabSound().PannerNode_velocityZ(this.nodeId));

    distanceGain = AudioParam(this.ctx, this.nodeId, LabSound().PannerNode_distanceGain(this.nodeId));
    coneGain = AudioParam(this.ctx, this.nodeId, LabSound().PannerNode_coneGain(this.nodeId));

  }

  PanningMode get panningModel => PanningMode.values[LabSound().PannerNode_panningModel(nodeId)];

  set panningModel(PanningMode m) => LabSound().PannerNode_setPanningModel(nodeId, m.index);

  DistanceModel get distanceModel => DistanceModel.values[LabSound().PannerNode_distanceModel(nodeId)];

  set distanceModel(DistanceModel m) => LabSound().PannerNode_setDistanceModel(nodeId, m.index);

  setPosition(double x, double y, double, z) => LabSound().PannerNode_setPosition(nodeId, x, y, z);

  setOrientation(double x, double y, double, z) => LabSound().PannerNode_setOrientation(nodeId, x, y, z);

  setVelocity(double x, double y, double, z) => LabSound().PannerNode_setVelocity(nodeId, x, y, z);

  double get refDistance => LabSound().PannerNode_refDistance(nodeId);
  set refDistance(double refDistance) => LabSound().PannerNode_setRefDistance(nodeId, refDistance);

  double get maxDistance => LabSound().PannerNode_maxDistance(nodeId);
  set maxDistance(double maxDistance) => LabSound().PannerNode_setMaxDistance(nodeId, maxDistance);

  double get rolloffFactor => LabSound().PannerNode_rolloffFactor(nodeId);
  set rolloffFactor(double rolloffFactor) => LabSound().PannerNode_setRolloffFactor(nodeId, rolloffFactor);

  double get coneInnerAngle => LabSound().PannerNode_coneInnerAngle(nodeId);
  set coneInnerAngle(double angle) => LabSound().PannerNode_setConeInnerAngle(nodeId, angle);

  double get coneOuterAngle => LabSound().PannerNode_coneOuterAngle(nodeId);
  set coneOuterAngle(double angle) => LabSound().PannerNode_setConeOuterAngle(nodeId, angle);

  double get coneOuterGain => LabSound().PannerNode_coneOuterGain(nodeId);
  set coneOuterGain(double angle) => LabSound().PannerNode_setConeOuterGain(nodeId, angle);

  AzimuthElevationData getAzimuthElevation() {
    final outAzimuthPtr = malloc.allocate<Double>(sizeOf<Double>());
    final outElevationPtr = malloc.allocate<Double>(sizeOf<Double>());
    LabSound().PannerNode_getAzimuthElevation(nodeId, ctx.pointer, outAzimuthPtr, outElevationPtr);
    final data = AzimuthElevationData(outAzimuthPtr.value, outElevationPtr.value);
    malloc.free(outElevationPtr);
    malloc.free(outAzimuthPtr);
    return data;
  }

  dopplerRate() => LabSound().PannerNode_dopplerRate(nodeId, ctx.pointer);

}