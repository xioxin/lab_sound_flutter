import 'dart:ffi';
import 'package:ffi/ffi.dart';

import '../generated_bindings.dart';

extension StringExtensions on String {
  Pointer<Int8> toInt8() {
    return this.toNativeUtf8().cast<Int8>();
  }
}

extension PointerExtensions on Pointer<Utf8> {
  String toStr({int? length}) => toDartString(length: length);
}

extension FloatArrayEx on FloatArray {
  List<double> toList() {
    final List<double> list = [];
    for(int i = 0; i < len; i++) {
      list.add(array.elementAt(i).value);
    }
    return list;
  }
}

extension CharArrayEx on CharArray {
  String toStr() {
    print("len: $len");
    if(len == 0) return "";
    return Pointer<Utf8>.fromAddress(string.address).toStr(length: len);
  }
}