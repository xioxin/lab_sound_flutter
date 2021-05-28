import 'lab_sound.dart';

class AudioHardwareDeviceNode extends AudioNode {
  AudioHardwareDeviceNode(AudioContext ctx,
      {AudioStreamConfig? outputConfig, AudioStreamConfig? inputConfig})
      : super(
            ctx,
            LabSound().createAudioHardwareDeviceNode(
                ctx.pointer,
                (outputConfig ?? AudioStreamConfig()).ffiValue,
                (inputConfig ?? AudioStreamConfig()).ffiValue));

  AudioHardwareDeviceNode.fromId(AudioContext ctx, int nodeId): super(ctx, nodeId);


  start() => LabSound().AudioHardwareDeviceNode_start(nodeId);

  stop() => LabSound().AudioHardwareDeviceNode_stop(nodeId);

  bool get isRunning =>
      LabSound().AudioHardwareDeviceNode_isRunning(nodeId) > 0;

  backendReinitialize() => LabSound().AudioHardwareDeviceNode_backendReinitialize(nodeId);

  AudioStreamConfig getOutputConfig() => AudioStreamConfig.value(LabSound().AudioHardwareDeviceNode_getOutputConfig(nodeId));

  AudioStreamConfig getInputConfig() => AudioStreamConfig.value(LabSound().AudioHardwareDeviceNode_getInputConfig(nodeId));
}
