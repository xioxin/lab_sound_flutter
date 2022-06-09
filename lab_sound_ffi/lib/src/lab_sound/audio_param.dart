
import 'audio_context.dart';
import 'lab_sound.dart';

class AudioParam {
  AudioContext ctx;
  final int paramId;
  final int nodeId;

  // final Pointer paramPointer;
  AudioParam(this.ctx, this.nodeId, this.paramId);
  double get value => LabSound().AudioParam_value(nodeId, paramId);
  set value(double value) => setValue(value);

  double get minValue => LabSound().AudioParam_minValue(nodeId, paramId);
  double get maxValue => LabSound().AudioParam_maxValue(nodeId, paramId);
  double get defaultValue => LabSound().AudioParam_defaultValue(nodeId, paramId);

  setValue(double value) {
    LabSound().AudioParam_setValue(nodeId, paramId, value);
    resetSmoothedValue();
  }
  setValueCurveAtTime(List<double> values, double time, double duration) {
    //todo
  }
  exponentialRampToValueAtTime(double value, double time) {
    LabSound().AudioParam_exponentialRampToValueAtTime(nodeId, paramId, value, time);
  }
  linearRampToValueAtTime(double value, double time) {
    LabSound().AudioParam_linearRampToValueAtTime(nodeId, paramId, value, time);
  }
  setValueAtTime(double value, double time) {
    LabSound().AudioParam_setValueAtTime(nodeId, paramId, value, time);
  }
  setTargetAtTime(double value, double time, double timeConstant) {
    LabSound().AudioParam_setTargetAtTime(nodeId, paramId, value, time, timeConstant);
  }

  resetSmoothedValue() {
    LabSound().AudioParam_resetSmoothedValue(nodeId, paramId);
  }

  setSmoothingConstant(double k) {
    LabSound().AudioParam_setSmoothingConstant(nodeId, paramId, k);
  }

  cancelScheduledValues([double time = 0.0]) {
    LabSound().AudioParam_cancelScheduledValues(nodeId, paramId, time);
  }

}
