import 'audio_context.dart';
import 'audio_node.dart';
import 'lab_sound.dart';

class PWMNode extends AudioNode {
  PWMNode(AudioContext ctx) : super(ctx, LabSound().createPWMNode(ctx.pointer));
}
