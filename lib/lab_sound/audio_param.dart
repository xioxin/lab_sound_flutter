import 'lab_sound.dart';

class AudioParam {
  AudioContext ctx;
  final int paramId;
  final int nodeId;

  // final Pointer paramPointer;
  AudioParam(this.ctx, this.nodeId, this.paramId);
  double get value => LabSound().AudioParam_value(this.nodeId, this.paramId);

  double get minValue => LabSound().AudioParam_minValue(this.nodeId, this.paramId);
  double get maxValue => LabSound().AudioParam_maxValue(this.nodeId, this.paramId);
  double get defaultValue => LabSound().AudioParam_defaultValue(this.nodeId, this.paramId);

  setValue(double value) {
    print('setValue: node: $nodeId, param: $paramId, val: $value');
    LabSound().AudioParam_setValue(this.nodeId, this.paramId, value);
  }
  setValueCurveAtTime(List<double> values, double time, double duration) {
    //todo
  }
  exponentialRampToValueAtTime(double value, double time) {
    LabSound().AudioParam_exponentialRampToValueAtTime(this.nodeId, this.paramId, value, this.ctx.correctionTime(time));
  }
  linearRampToValueAtTime(double value, double time) {
    LabSound().AudioParam_linearRampToValueAtTime(this.nodeId, this.paramId, value, this.ctx.correctionTime(time));
  }
  setValueAtTime(double value, double time) {
    LabSound().AudioParam_setValueAtTime(this.nodeId, this.paramId, value, this.ctx.correctionTime(time));
  }
  setTargetAtTime(double value, double time, double timeConstant) {
    LabSound().AudioParam_setTargetAtTime(this.nodeId, this.paramId, value, this.ctx.correctionTime(time), timeConstant);
  }

  resetSmoothedValue() {
    LabSound().AudioParam_resetSmoothedValue(this.nodeId, this.paramId);
  }

  setSmoothingConstant(double k) {
    LabSound().AudioParam_setSmoothingConstant(this.nodeId, this.paramId, k);
  }

  cancelScheduledValues([double time = 0.0]) {
    LabSound().AudioParam_cancelScheduledValues(this.nodeId, this.paramId, this.ctx.correctionTime(time));
  }

}
