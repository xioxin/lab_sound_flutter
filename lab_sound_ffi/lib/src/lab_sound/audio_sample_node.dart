import 'dart:async';

import 'audio_bus.dart';
import 'audio_context.dart';
import 'audio_node.dart';
import 'audio_param.dart';
import 'audio_scheduled_source_node.dart';
import 'lab_sound.dart';


class AudioSampleNode extends AudioScheduledSourceNode {
  AudioBus? resource;
  AudioSampleNode(AudioContext ctx, { AudioBus? resource }): super(ctx, LabSound().createAudioSampleNode(ctx.pointer)) {
    if(resource != null) {
      setBus(resource);
    }
    final pRateId = LabSound().SampledAudioNode_playbackRate(nodeId);
    playbackRate = AudioParam(this.ctx, nodeId, pRateId);
    detune = AudioParam(this.ctx, nodeId, LabSound().SampledAudioNode_detune(nodeId));
  }

  setBus(AudioBus resource) {
    this.resource = resource;
    if(resource.released) throw AssertionError("音频资源已被释放: $resource");
    LabSound().SampledAudioNode_setBus(nodeId, ctx.pointer, resource.resourceId);
    this.resource!.lock(this);
  }

  int get cursor => LabSound().SampledAudioNode_getCursor(nodeId);

  late AudioParam playbackRate;
  late AudioParam detune;

  Stream get onEnded => LabSound().onAudioSampleEnd.where((e) => e.nodeId == nodeId);
  StreamSubscription? _endedDisposeSubscription;

  Duration? get position {
    if(resource == null) return null;
    final c = cursor;
    if(c == -1) return null;
    return Duration(milliseconds: (c / resource!.sampleRate * 1000).toInt());
  }
  Duration? get duration => resource?.duration;

  schedule({double? relativeWhen, double? offset, double? duration, int? loopCount}) {
    if(relativeWhen != null && offset != null && duration != null && loopCount != null) {
      LabSound().SampledAudioNode_schedule4(nodeId, relativeWhen, offset, duration, loopCount);
    } else if(relativeWhen != null && offset != null && loopCount != null) {
      LabSound().SampledAudioNode_schedule3(nodeId, relativeWhen, offset, loopCount);
    } else if(relativeWhen != null && loopCount != null) {
      LabSound().SampledAudioNode_schedule2(nodeId, relativeWhen, loopCount);
    } else {
      LabSound().SampledAudioNode_schedule(nodeId, relativeWhen ?? 0.0);
    }
  }

  @override
  start([double? when, double? offset, double? duration, int? loopCount]) {
    loopCount ??= 0;
    if(when != null && offset != null && duration != null) {
      LabSound().SampledAudioNode_start4(nodeId, when, offset, duration, loopCount);
    } else if(when != null && offset != null) {
      LabSound().SampledAudioNode_start3(nodeId, when, offset, loopCount);
    } else {
      LabSound().SampledAudioNode_start2(nodeId, when ?? 0.0, loopCount);
    }
  }

  clearSchedules({double? when}) {
    if(when == null) {
      return LabSound().SampledAudioNode_clearSchedules(nodeId);
    }else {
      return start(when, 0, 0, -2);
    }
  }

  @override
  stop([double? when]) {
    if(when != null) when = when - ctx.currentTime;
    super.stop(when ?? 0 );
  }

  @override
  dispose() {
    // _onPositionController.close();
    // _onEndedController.close();
    // _checkTimer?.cancel();
    if(playbackState == SchedulingState.playing) {
      stop();
    }
    _endedDisposeSubscription?.cancel();
    super.dispose();
    resource?.unlock(this);
    return;
  }

  @override
  String toString() => "${super.toString()} bus: $resource";

  endedDispose({Function? destroyed}) {
    if(hasFinished) {
      dispose();
      if(destroyed != null) destroyed();
    } else {
      _endedDisposeSubscription = onEnded.listen((event) {
        dispose();
        if(destroyed != null) destroyed();
      });
    }
  }



}