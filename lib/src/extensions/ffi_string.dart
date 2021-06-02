import 'dart:ffi';
import 'package:ffi/ffi.dart';

extension StringExtensions on String {
  Pointer<Int8> toInt8() {
    return this.toNativeUtf8().cast<Int8>();
  }
}

extension PointerExtensions on Pointer<Utf8> {
  String toStr() {
    return this.toDartString();
  }
}