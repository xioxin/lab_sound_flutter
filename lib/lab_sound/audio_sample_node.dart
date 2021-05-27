import 'dart:async';
import 'lab_sound.dart';

class AudioSampleNode extends AudioScheduledSourceNode {
  AudioBus? resource;
  AudioSampleNode(AudioContext ctx, { AudioBus? resource }): super(ctx, LabSound().createAudioSampleNode(ctx.pointer)) {
    if(resource != null) {
      this.setBus(resource);
    }
    final pRateId = LabSound().SampledAudioNode_playbackRate(this.nodeId);
    playbackRate = AudioParam(this.ctx, this.nodeId, pRateId);
    detune = AudioParam(this.ctx, this.nodeId, LabSound().SampledAudioNode_detune(this.nodeId));
  }

  setBus(AudioBus resource) {
    this.resource = resource;
    if(resource.released) throw AssertionError("音频资源已被释放: $resource");
    LabSound().SampledAudioNode_setBus(nodeId, ctx.pointer, resource.resourceId);
    this.resource!.lock(this);
  }

  int get cursor => LabSound().SampledAudioNode_getCursor(this.nodeId);

  late AudioParam playbackRate;
  late AudioParam detune;

  Stream get onEnded => LabSound().onAudioSampleEnd.where((e) => e.nodeId == this.nodeId);
  StreamSubscription? _endedDisposeSubscription;

  Duration? get position {
    if(resource == null) return null;
    final c = this.cursor;
    if(c == -1) return null;
    return Duration(milliseconds: (c / resource!.sampleRate * 1000).toInt());
  }
  Duration? get duration => this.resource?.duration;

  schedule({double? relativeWhen, double? offset, double? duration, int? loopCount}) {
    if(relativeWhen != null && offset != null && duration != null && loopCount != null) {
      LabSound().SampledAudioNode_schedule4(this.nodeId, relativeWhen, offset, duration, loopCount);
    } else if(relativeWhen != null && offset != null && loopCount != null) {
      LabSound().SampledAudioNode_schedule3(this.nodeId, relativeWhen, offset, loopCount);
    } else if(relativeWhen != null && loopCount != null) {
      LabSound().SampledAudioNode_schedule2(this.nodeId, relativeWhen, loopCount);
    } else {
      LabSound().SampledAudioNode_schedule(this.nodeId, relativeWhen ?? 0.0);
    }
  }

  start({double? when, double? offset, double? duration, int? loopCount}) {
    loopCount ??= 0;
    if(when != null && offset != null && duration != null) {
      LabSound().SampledAudioNode_start4(this.nodeId, when, offset, duration, loopCount);
    } else if(when != null && offset != null) {
      LabSound().SampledAudioNode_start3(this.nodeId, when, offset, loopCount);
    } else {
      LabSound().SampledAudioNode_start2(this.nodeId, when ?? 0.0, loopCount);
    }
  }

  clearSchedules() {
    LabSound().SampledAudioNode_clearSchedules(nodeId);
  }

  stop({double? when}) {
    start(when: when, offset: 0, duration: 0, loopCount: -2);
    super.stop(when: when ?? ctx.currentTime);
  }

  @override
  dispose() {
    // _onPositionController.close();
    // _onEndedController.close();
    // _checkTimer?.cancel();
    if(playbackState == SchedulingState.PLAYING) {
      stop();
    }
    _endedDisposeSubscription?.cancel();
    super.dispose();
    this.resource?.unlock(this);
    return;
  }

  toString() {
    return "AudioSampleNode<$nodeId>";
  }

  endedDispose({Function? destroyed}) {
    if(hasFinished) {
      this.dispose();
      if(destroyed != null) destroyed();
    } else {
      this._endedDisposeSubscription = this.onEnded.listen((event) {
        this.dispose();
        if(destroyed != null) destroyed();
      });
    }
  }

}