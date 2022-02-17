import '../extensions/ffi_string.dart';
import 'audio_bus.dart';
import 'audio_context.dart';
import 'audio_node.dart';
import 'audio_stream_config.dart';
import 'lab_sound.dart';

class RecorderNode extends AudioNode {
  // todo: 有两个创建方法 一个是仅传递声道数量 一个是传递配置结构
  RecorderNode(AudioContext ctx, [int channelCount = 2]): super(ctx, LabSound().createRecorderNode(ctx.pointer, channelCount));
  RecorderNode.fromConfig(AudioContext ctx, AudioStreamConfig outputConfig): super(ctx, LabSound().createRecorderNodeByConfig(ctx.pointer, outputConfig.ffiValue));

  void startRecording() => LabSound().RecorderNode_startRecording(nodeId);
  void stopRecording() => LabSound().RecorderNode_stopRecording(nodeId);
  double get recordedLengthInSeconds => LabSound().RecorderNode_recordedLengthInSeconds(nodeId);

  AudioBus? createBusFromRecording({bool mixToMono = false}) {
    final busId = LabSound().RecorderNode_createBusFromRecording(nodeId, mixToMono ? 1 : 0);
    if(busId < 0) return null;
    return AudioBus.fromId(busId);
  }

  bool writeRecordingToWav(String filenameWithWavExtension, {bool mixToMono = false}) {
    return LabSound().RecorderNode_writeRecordingToWav(nodeId, filenameWithWavExtension.toInt8(), mixToMono ? 1 : 0) > 0;
  }
}
