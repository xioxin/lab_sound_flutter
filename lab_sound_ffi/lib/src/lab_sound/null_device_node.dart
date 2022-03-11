import '../../lab_sound_ffi.dart';
import 'audio_context.dart';
import 'audio_node.dart';
import 'lab_sound.dart';

class NullDeviceNode extends AudioNode {
  NullDeviceNode(
    AudioContext ctx,
    AudioStreamConfig outputConfig,
    double lengthSeconds,
  ) : super(
            ctx,
            LabSound().createNullDeviceNode(
              ctx.pointer,
              outputConfig.ffiValue,
              lengthSeconds,
            ));
}
