import 'lab_sound.dart';

class RecorderNode extends AudioNode {
  final int channels;
  final double sampleRate;
  RecorderNode(AudioContext ctx, this.channels, this.sampleRate): super(ctx, LabSound().createRecorderNode(ctx.pointer, channels, sampleRate));
}
