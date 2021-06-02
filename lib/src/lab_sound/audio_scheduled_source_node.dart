import 'audio_context.dart';
import 'audio_node.dart';
import 'lab_sound.dart';

class AudioScheduledSourceNode extends AudioNode {
  AudioScheduledSourceNode(AudioContext ctx, int nodeId): super(ctx, nodeId);
  bool get isPlayingOrScheduled => LabSound().AudioScheduledSourceNode_isPlayingOrScheduled(nodeId) > 0;
  stop({double when = 0}) => LabSound().AudioScheduledSourceNode_stop(nodeId, when);
  start({double when = 0}) => LabSound().AudioScheduledSourceNode_start(nodeId, when);
  bool get hasFinished => LabSound().AudioScheduledSourceNode_hasFinished(nodeId) > 0;
  int get startWhen => LabSound().AudioScheduledSourceNode_startWhen(nodeId);
  SchedulingState get playbackState => SchedulingState.values[LabSound().AudioScheduledSourceNode_playbackState(nodeId)];
}