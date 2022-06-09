import 'dart:collection';
import 'dart:ffi';
import 'audio_context.dart';
import 'audio_scheduled_source_node.dart';
import 'audio_setting.dart';
import 'lab_sound.dart';

typedef FunctionNodeCallback = void Function(AudioContext context,
    FunctionNode me, int channel, FunctionNodeBuffer values);

class FunctionNodeBuffer extends IterableBase<double> {
  Pointer<Float> ptr;
  int size;
  FunctionNodeBuffer(this.size, this.ptr);

  @override
  Iterator<double> get iterator {
    return _FunctionNodeBufferIterator(ptr, size);
  }

  double getAt(int i) {
    return ptr.elementAt(i).value;
  }

  setAt(int i, double value) {
    ptr.elementAt(i).value = value;
  }

  double operator [](int index) => getAt(index);
  operator []=(int index, double value) {
    setAt(index, value);
  }

  @override
  double get first => getAt(0);

  @override
  double get last => getAt(size - 1);

  @override
  bool get isEmpty => false;

  @override
  bool get isNotEmpty => true;
}

class _FunctionNodeBufferIterator extends Iterator<double> {
  Pointer<Float> ptr;
  int size;
  _FunctionNodeBufferIterator(this.ptr, this.size);
  int index = -1;
  @override
  double get current {
    return ptr.elementAt(index).value;
  }

  @override
  bool moveNext() {
    index++;
    return index < size;
  }
}

class FunctionNode extends AudioScheduledSourceNode {
  late AudioSettingFloat delayTime;
  FunctionNode(AudioContext ctx, {int channels = 1})
      : super(ctx, LabSound().createFunctionNode(ctx.pointer, channels));

  FunctionNode.fromId(AudioContext ctx, int id) : super(ctx, id);
  double get now => LabSound().FunctionNode_now(nodeId);
  FunctionNodeCallback? fn;
  setFunction(FunctionNodeCallback fn) {
    this.fn = fn;
    LabSound().FunctionNode_setFunction(nodeId);
  }
}
