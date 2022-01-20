import 'dart:ffi';
import 'package:ffi/ffi.dart';

import '../generated_bindings.dart';
import 'dart:convert';
extension StringExtensions on String {
  Pointer<Int8> toInt8() {
    return this.toNativeUtf8().cast<Int8>();
  }
}

extension PointerUtf8Extensions on Pointer<Utf8> {
  String toStr({int? length}) {
    final codeUnits = cast<Uint8>();
    if (length != null) {
      RangeError.checkNotNegative(length, 'length');
    } else {
      length = this.length;
    }
    return utf8.decode(codeUnits.asTypedList(length), allowMalformed: true);
  }
}

extension PointerInt8Extensions on Pointer<Int8> {
  String toStr({int? length}) {
    return Pointer<Utf8>.fromAddress(this.address).toStr(length: length);
  }
}

extension PointerInt16Extensions on Pointer<Int8> {
  String toStrUtf16() => Pointer<Utf16>.fromAddress(this.address).toDartString();
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