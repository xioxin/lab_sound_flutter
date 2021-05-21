import 'lab_sound.dart';

class AudioParam {
  AudioContext ctx;
  final int paramIndex;
  final int nodeIndex;

  // final Pointer paramPointer;
  AudioParam(this.ctx, this.nodeIndex, this.paramIndex);
  double get value => LabSound().AudioParam_value(this.nodeIndex, this.paramIndex);
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

}
