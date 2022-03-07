import 'dart:collection';
import 'dart:ffi';

import 'package:lab_sound_ffi/lab_sound_ffi.dart';


class AudioChannel {
  final Pointer<Void> pointer;
  AudioChannel(this.pointer);
  get length => LabSound().AudioChannel_length(pointer);
  Pointer<Float> get dataPtr => LabSound().AudioChannel_data(pointer);
  ChannelBuffer getData() => ChannelBuffer(length, dataPtr.address);
}


class ChannelBuffer extends IterableBase<double> {
  final Pointer ptr;
  final int size;

  ChannelBuffer(this.size, int address): ptr = Pointer<Float>.fromAddress(address);

  @override
  _ChannelBufferIterator get iterator {
    return _ChannelBufferIterator(ptr, size);
  }

  double getAt(int i) {
    return (ptr as Pointer<Float>).elementAt(i).value;
  }

  double operator [](int index) => getAt(index);

  @override
  double get first => getAt(0);

  @override
  double get last => getAt(size - 1);

  @override
  bool get isEmpty => false;

  @override
  bool get isNotEmpty => true;

}

class _ChannelBufferIterator extends Iterator<double> {
  final Pointer ptr;
  final int size;
  _ChannelBufferIterator(this.ptr, this.size);

  int index = -1;

  @override
  double get current {
    return (ptr as Pointer<Float>).elementAt(index).value;
  }

  @override
  bool moveNext() {
    index++;
    return index < size;
  }
}
