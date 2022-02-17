
import 'package:lab_sound_ffi/lab_sound_ffi.dart';

import 'audio_context.dart';
import 'lab_sound.dart';
import '../extensions/ffi_string.dart';

enum AudioSettingType {
  None,
  Bool,
  Integer,
  Float,
  Enumeration,
  Bus
}

abstract class AudioSetting<T> {
  AudioContext ctx;
  final int settingId;
  final int nodeId;

  AudioSetting(this.ctx, this.nodeId, this.settingId);
  String get name => LabSound().AudioSetting_name(nodeId, settingId).toStr();
  String get shortName => LabSound().AudioSetting_shortName(nodeId, settingId).toStr();

  AudioSettingType get type => AudioSettingType.values[LabSound().AudioSetting_type(nodeId, settingId)];

  T get value;
  set value(T val) => setValue(val);
  setValue(T val, [bool notify = true]);

  @override
  String toString() => "AudioSetting<$shortName: $value>";
}

class AudioSettingBool extends AudioSetting<bool> {
  AudioSettingBool(AudioContext ctx, int nodeId, int settingId) : super(ctx, nodeId, settingId) {
    assert(this.type == AudioSettingType.Bool);
  }

  @override
  setValue(bool val, [bool notify = true]) => LabSound().AudioSetting_setBool(nodeId, settingId, val ? 1 : 0, notify ? 1 : 0);

  @override
  bool get value => LabSound().AudioSetting_valueBool(nodeId, settingId) > 0;
}
class AudioSettingInteger extends AudioSetting<int> {
  AudioSettingInteger(AudioContext ctx, int nodeId, int settingId) : super(ctx, nodeId, settingId) {
    assert(this.type == AudioSettingType.Integer);
  }

  @override
  setValue(int val, [bool notify = true]) => LabSound().AudioSetting_setUint32(nodeId, settingId, val, notify ? 1 : 0);

  @override
  int get value => LabSound().AudioSetting_valueUint32(nodeId, settingId);
}
class AudioSettingFloat extends AudioSetting<double> {
  AudioSettingFloat(AudioContext ctx, int nodeId, int settingId) : super(ctx, nodeId, settingId) {
    assert(this.type == AudioSettingType.Float);
  }

  @override
  setValue(double val, [bool notify = true]) => LabSound().AudioSetting_setFloat(nodeId, settingId, val, notify ? 1 : 0);

  @override
  double get value => LabSound().AudioSetting_valueFloat(nodeId, settingId);
}
class AudioSettingBus extends AudioSetting<AudioBus> {
  AudioSettingBus(AudioContext ctx, int nodeId, int settingId) : super(ctx, nodeId, settingId) {
    assert(this.type == AudioSettingType.Float);
  }

  @override
  setValue(AudioBus val, [bool notify = true]) => LabSound().AudioSetting_setBool(nodeId, settingId, val.resourceId, notify ? 1 : 0);

  @override
  AudioBus get value => AudioBus.fromId(LabSound().AudioSetting_valueBus(nodeId, settingId));
}


class AudioSettingEnumeration extends AudioSetting<int> {
  AudioSettingEnumeration(AudioContext ctx, int nodeId, int settingId) : super(ctx, nodeId, settingId) {
    assert(this.type == AudioSettingType.Integer);
  }

  @override
  setValue(int val, [bool notify = true]) => LabSound().AudioSetting_setEnumeration(nodeId, settingId, val, notify ? 1 : 0);

  @override
  int get value => LabSound().AudioSetting_valueUint32(nodeId, settingId);
}
