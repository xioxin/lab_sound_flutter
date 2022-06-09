import 'package:flutter/services.dart';
import 'package:lab_sound_ffi/lab_sound_ffi.dart';

Future<AudioBus> audioBusFromAsset(String assetName,
    {String extension = '',
    AssetBundle? bundle,
    String? package,
    String? debugName,
    bool mixToMono = false}) async {
  String keyName = package == null ? assetName : 'packages/$package/$assetName';
  final AssetBundle chosenBundle = bundle ?? rootBundle;
  final asset = await chosenBundle.load(keyName);
  print("AudioBus.fromBuffer");
  return await AudioBus.fromBuffer(asset.buffer.asUint8List(),
      extension: extension,
      debugName: debugName ?? keyName,
      mixToMono: mixToMono);
}
