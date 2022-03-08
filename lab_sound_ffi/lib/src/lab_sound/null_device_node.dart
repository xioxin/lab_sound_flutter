import 'audio_context.dart';
import 'audio_node.dart';
import 'lab_sound.dart';

class NullDeviceNode extends AudioNode {
  NullDeviceNode(AudioContext ctx)
      : super(ctx, LabSound().createNullDeviceNode(ctx.pointer));
}
