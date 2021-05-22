import 'dart:collection';
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'lab_sound.dart';


class AnalyserBuffer<T> extends IterableBase<T> {
  Pointer? ptr;
  int size;
  AnalyserBuffer(this.size){
    if(T == double) {
      ptr = malloc.allocate<Float>(sizeOf<Float>() * size);
    } else if(T == int) {
      ptr = malloc.allocate<Uint8>(sizeOf<Uint8>() * size);
    }else {
      throw "Unsupported type: $T";
    }
  }

  @override
  // TODO: implement iterator
  Iterator<T> get iterator {
    if(ptr == null) throw "ptr is null";
    return _AnalyserBufferIterator(ptr!, size);
  }

  free() {
    if(ptr == null) return;
    malloc.free(ptr!);
    ptr = null;
  }

  T getAt(int i) {
    if(ptr == null) throw "ptr is null";
    if(T == double){
      return (ptr as Pointer<Float>).elementAt(i).value as T;
    } else if(T == int) {
      return (ptr as Pointer<Uint8>).elementAt(i).value as T;
    }else {
      throw "Unsupported type: $T";
    }
  }

  T operator [](int index) => getAt(index);

  @override
  T get first => getAt(0);

  @override
  T get last => getAt(size - 1);

  @override
  bool get isEmpty => false;

  @override
  bool get isNotEmpty => true;

}

class _AnalyserBufferIterator<T> extends Iterator<T> {
  Pointer ptr;
  int size;
  _AnalyserBufferIterator(this.ptr, this.size);

  int index = -1;

  @override
  T get current {
    if(T == double){
      return (ptr as Pointer<Float>).elementAt(index).value as T;
    } else if(T == int) {
      return (ptr as Pointer<Uint8>).elementAt(index).value as T;
    }else {
      throw "Unsupported type: $T";
    }
  }

  @override
  bool moveNext() {
    index++;
    return index < size;
  }
}


class AnalyserNode extends AudioNode {

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

  AnalyserBuffer<double>? floatFrequencyData;
  AnalyserBuffer<double> getFloatFrequencyData() {
    floatFrequencyData ??= AnalyserBuffer<double>(frequencyBinCount);
    if(floatFrequencyData!.ptr == null) throw "floatFrequencyData ptr is null";
    LabSound().AnalyserNode_getFloatFrequencyData(this.nodeId, floatFrequencyData!.ptr! as Pointer<Float>);
    return floatFrequencyData!;
  }

  AnalyserBuffer<int>? byteFrequencyData;
  AnalyserBuffer<int> getByteFrequencyData({resample = false}) {
    byteFrequencyData ??= AnalyserBuffer<int>(frequencyBinCount);
    if(byteFrequencyData!.ptr == null) throw "byteFrequencyData ptr is null";
    LabSound().AnalyserNode_getByteFrequencyData(this.nodeId, byteFrequencyData!.ptr! as Pointer<Uint8>, resample ? 1 : 0);
    return byteFrequencyData!;
  }


  AnalyserBuffer<double>? floatTimeDomainData;
  AnalyserBuffer<double> getFloatTimeDomainData() {
    floatTimeDomainData ??= AnalyserBuffer<double>(frequencyBinCount);
    if(floatTimeDomainData!.ptr == null) throw "floatTimeDomainData ptr is null";
    LabSound().AnalyserNode_getFloatTimeDomainData(this.nodeId, floatTimeDomainData!.ptr! as Pointer<Float>);
    return floatTimeDomainData!;
  }

  AnalyserBuffer<int>? byteTimeDomainData;
  AnalyserBuffer<int> getByteTimeDomainData() {
    byteTimeDomainData ??= AnalyserBuffer<int>(frequencyBinCount);
    if(byteTimeDomainData!.ptr == null) throw "byteTimeDomainData ptr is null";
    LabSound().AnalyserNode_getByteTimeDomainData(this.nodeId, byteTimeDomainData!.ptr! as Pointer<Uint8>);
    return byteTimeDomainData!;
  }

  @override
  dispose() {
    floatFrequencyData?.free();
    byteFrequencyData?.free();
    floatTimeDomainData?.free();
    byteTimeDomainData?.free();
    super.dispose();
  }

}