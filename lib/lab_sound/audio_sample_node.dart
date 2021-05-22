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
  // late AudioParam gain;
  late AudioParam detune;

  StreamController _onEndedController = StreamController.broadcast();
  Stream get onEnded => _onEndedController.stream;

  StreamController<Duration> _onPositionController = StreamController.broadcast();
  Stream<Duration> get onPosition => _onPositionController.stream;

  Timer? _checkTimer;
  _startCheckTimer(){
    _checkTimer?.cancel();
    _checkTimer = Timer.periodic( CHECK_TIMER_DURATION , ( timer ) {
      if(this.position != null) {
        _onPositionController.add(this.position!);
        if(this.hasFinished){
          _checkTimer?.cancel();
          _checkTimer = null;
          _onEndedController.add(null);
        }
      }
    });
  }

  Duration? get position => this.resource == null ? null : Duration(milliseconds: (this.cursor / this.resource!.sampleRate * 1000).toInt());
  Duration? get duration => this.resource?.duration;

  // start({double? when, double? offset, double? duration, int? loopCount}) {
  //   schedule(when: when, offset: offset, duration: duration, loopCount: loopCount);
  // }

  schedule({double? when, double? offset, double? duration, int? loopCount}) {
    if(when != null && offset != null && duration != null && loopCount != null) {
      LabSound().SampledAudioNode_schedule4(this.nodeId, ctx.correctionTime(when), offset, duration, loopCount);
    } else if(when != null && offset != null && duration != null) {
      LabSound().SampledAudioNode_schedule3(this.nodeId, ctx.correctionTime(when), offset, duration);
    } else if(when != null && offset != null) {
      LabSound().SampledAudioNode_schedule2(this.nodeId, ctx.correctionTime(when), offset);
    } else {
      LabSound().SampledAudioNode_schedule(this.nodeId, ctx.correctionTime(when ?? 0.0));
    }
    _startCheckTimer();
  }

  clearSchedules() {
    LabSound().SampledAudioNode_clearSchedules(nodeId);
  }

  @override
  dispose() {
    _onPositionController.close();
    _onEndedController.close();
    _checkTimer?.cancel();
    super.dispose();
    this.resource?.unlock(this);
    return;
  }

  toString() {
    return "AudioSampleNode<${nodeId}>";
  }

  endedDispose({Function? destroyed}) {
    print('$this onEndedDispose $_checkTimer');
    if(hasFinished) {
      print('$this hasFinished true');
      this.dispose();
      if(destroyed != null) destroyed();
    } else {
      print('$this hasFinished false listen');
      this.onEnded.listen((event) {
        print('$this hasFinished false listen get');
        this.dispose();
        if(destroyed != null) destroyed();
      });
    }
  }


}