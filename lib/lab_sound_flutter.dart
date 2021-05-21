
import 'dart:async';

import 'package:flutter/services.dart';

class LabSoundFlutter {
  static const MethodChannel _channel =
      const MethodChannel('lab_sound_flutter');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
