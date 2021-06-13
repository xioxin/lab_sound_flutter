import 'audio_context.dart';
import 'audio_node.dart';
import 'lab_sound.dart';

class PowerMonitorNode extends AudioNode {

  PowerMonitorNode(AudioContext ctx): super(ctx, LabSound().createPowerMonitorNode(ctx.pointer));

  int get windowSize => LabSound().PowerMonitorNode_windowSize(nodeId);
  set windowSize(int ws) => LabSound().PowerMonitorNode_setWindowSize(nodeId, ws);

  double get db => LabSound().PowerMonitorNode_db(nodeId);
}

