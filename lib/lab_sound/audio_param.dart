import 'lab_sound.dart';

class AudioParam {
  AudioContext ctx;
  final int paramIndex;
  final int nodeIndex;

  // final Pointer paramPointer;
  AudioParam(this.ctx, this.nodeIndex, this.paramIndex);
  double get value => LabSound().AudioParam_value(this.nodeIndex, this.paramIndex);

  double get minValue => LabSound().AudioParam_minValue(this.nodeIndex, this.paramIndex);
  double get maxValue => LabSound().AudioParam_maxValue(this.nodeIndex, this.paramIndex);
  double get defaultValue => LabSound().AudioParam_defaultValue(this.nodeIndex, this.paramIndex);

  setValue(double value) {
    print('setValue: node: $nodeIndex, param: $paramIndex, val: $value');
    LabSound().AudioParam_setValue(this.nodeIndex, this.paramIndex, value);
  }
  setValueCurveAtTime(List<double> values, double time, double duration) {
    //todo
  }
  exponentialRampToValueAtTime(double value, double time) {
    LabSound().AudioParam_exponentialRampToValueAtTime(this.nodeIndex, this.paramIndex, value, this.ctx.correctionTime(time));
  }
  linearRampToValueAtTime(double value, double time) {
    LabSound().AudioParam_linearRampToValueAtTime(this.nodeIndex, this.paramIndex, value, this.ctx.correctionTime(time));
  }
  setValueAtTime(double value, double time) {
    LabSound().AudioParam_setValueAtTime(this.nodeIndex, this.paramIndex, value, this.ctx.correctionTime(time));
  }
  setTargetAtTime(double value, double time, double timeConstant) {
    LabSound().AudioParam_setTargetAtTime(this.nodeIndex, this.paramIndex, value, this.ctx.correctionTime(time), timeConstant);
  }

  resetSmoothedValue() {
    LabSound().AudioParam_resetSmoothedValue(this.nodeIndex, this.paramIndex);
  }

  setSmoothingConstant(double k) {
    LabSound().AudioParam_setSmoothingConstant(this.nodeIndex, this.paramIndex, k);
  }

  cancelScheduledValues([double time = 0.0]) {
    LabSound().AudioParam_cancelScheduledValues(this.nodeIndex, this.paramIndex, this.ctx.correctionTime(time));
  }

}

/*
*
*


void AudioParam_resetSmoothedValue(int nodeId, int paramIndex);

void AudioParam_setSmoothingConstant(int nodeId, int paramIndex, double k);

int AudioParam_hasSampleAccurateValues(int nodeId, int paramIndex);

* */