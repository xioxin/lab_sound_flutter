import 'dart:async';
import '../../lab_sound_flutter.dart';

enum PlayerNodeStatus {
  pause, playing, ended,
}

class GainAudioSampleNode extends GainNode implements AudioSampleNode {
  late AudioSampleNode _sample;

  GainAudioSampleNode(AudioContext ctx, {
    AudioBus? resource,
  }) : super(ctx) {
    _sample = AudioSampleNode(ctx, resource: resource);
    _sample.connect(this);
  }

  @override
  dispose() {
    _sample.dispose();
    return super.dispose();
  }

  @override
  AudioParam get detune => _sample.detune;

  @override
  AudioParam get playbackRate => _sample.playbackRate;

  @override
  AudioBus? get resource => _sample.resource;

  @override
  clearSchedules({double? when}) => _sample.clearSchedules(when: when);

  @override
  int get cursor => _sample.cursor;

  @override
  Duration? get duration => _sample.duration;

  @override
  endedDispose({Function? destroyed}) {
    print('endedDispose');
    if(hasFinished) {
      this.dispose();
      if(destroyed != null) destroyed();
    } else {
      print('endedDispose 注册');
      this.onEnded.listen((event) {
        print('endedDispose onEnded listen');
        this.dispose();
        if(destroyed != null) destroyed();
      });
    }
  }

  @override
  bool get hasFinished => _sample.hasFinished;

  @override
  bool get isPlayingOrScheduled => _sample.isPlayingOrScheduled;

  @override
  Stream get onEnded => _sample.onEnded;

  @override
  SchedulingState get playbackState => _sample.playbackState;

  @override
  Duration? get position => _sample.position;

  @override
  schedule(
      {double? relativeWhen,
      double? offset,
      double? duration,
      int? loopCount}) {
    _sample.schedule(
        relativeWhen: relativeWhen,
        offset: offset,
        duration: duration,
        loopCount: loopCount);
  }

  @override
  setBus(AudioBus resource) {
    _sample.setBus(resource);
  }

  @override
  start({double? when, double? offset, double? duration, int? loopCount}) {
    _sample.start(
        when: when, offset: offset, duration: duration, loopCount: loopCount);
  }

  @override
  int get startWhen => _sample.startWhen;

  @override
  stop({double? when}) => _sample.stop(when: when ?? 0);

  @override
  set detune(AudioParam _detune) {
    _sample.detune = _detune;
  }

  @override
  set playbackRate(AudioParam _playbackRate) {
    _sample.playbackRate = _playbackRate;
  }

  @override
  set resource(AudioBus? _resource) {
    _sample.resource = _resource;
  }
}

class PlayerNode extends GainNode {

  PlayerNode(AudioContext ctx, {
    Duration? clockDuration = const Duration(milliseconds: 100),
    this.middleAudioNode,
    this.middleInAudioNode,
    this.middleOutAudioNode,
    this.autoSleep = false,
    this.crossFadeTime = 0.0,
  }) : super(ctx) {
    if(clockDuration != null) {
      _clock = Stream.periodic(clockDuration).asBroadcastStream();
    }
    assert(!(middleAudioNode != null && (middleInAudioNode != null || middleOutAudioNode != null)));
    if(middleAudioNode != null) {
      middleAudioNode!.connect(this);
    }else if(middleInAudioNode != null || middleOutAudioNode != null) {
      assert(middleInAudioNode != null && middleOutAudioNode != null);
      middleOutAudioNode!.connect(this);
    }
  }

  AudioNode get _out {
    if(middleAudioNode != null) return middleAudioNode!;
    if(middleInAudioNode != null) return middleInAudioNode!;
    return this;
  }
  final AudioNode? middleAudioNode;
  final AudioNode? middleInAudioNode;
  final AudioNode? middleOutAudioNode;

  final bool autoSleep;

  bool get hasResource => resource != null;
  AudioBus? resource;
  Duration? get duration => resource?.duration;

  double _playbackRate = 1.0;
  double get playbackRate => _playbackRate;
  set playbackRate(double val) {
    if(sample?.released == false){
      sample?.playbackRate.setValue(val);
    }
    _playbackRate = val;
  }


  Stream? _clock;

  GainAudioSampleNode? _sample;
  double crossFadeTime;
  AudioContext get audioContext => ctx;

  Duration? pausePosition;

  AudioBus? audioData;
  GainAudioSampleNode? get sample => _sample;
  set sample(GainAudioSampleNode? sample) {
    _subscriptionEnded?.cancel();
    _sample = sample;
    if(sample == null)return;
    _subscriptionEnded = sample.onEnded.listen((event) {
      print('sample. onEnded');
      final isOver = status == PlayerNodeStatus.playing;
      status = PlayerNodeStatus.ended;
      pausePosition = null;
      if (autoSleep) {
        audioContext.suspend();
      }
      this._onEndedController.add(isOver);
    });
  }

  StreamSubscription? _subscriptionEnded;
  StreamController<bool> _onEndedController = StreamController.broadcast();
  Stream<bool> get onEnded => _onEndedController.stream;

  bool _pauseOnPosition = false;
  Stream<Duration> get onPosition {
    assert(_clock != null, "_clock is null");
    return _clock!.where((event) {
      if(this.status == PlayerNodeStatus.playing && _sample?.playbackState == SchedulingState.PLAYING) {
        _pauseOnPosition = false;
        return true;
      }
      if(_pauseOnPosition == false) {
        _pauseOnPosition = true;
        return true;
      }
      return false;
    })
        .map((event) => this.position);
  }

  Stream<SchedulingState?> get onSamplePlaybackState {
    assert(_clock != null, "_clock is null");
    return _clock!.map((event) => _sample?.playbackState);
  }


  Duration? _lastPosition;
  Duration get position {
    Duration? pos = _sample?.position;
    if (status == PlayerNodeStatus.pause) {
      pos = pausePosition ?? Duration.zero;
    } else if (status == PlayerNodeStatus.ended) {
      pos = resource?.duration ?? Duration.zero;
    } else if (_sample == null){
      pos = Duration.zero;
    } else if ((_sample?.playbackState == SchedulingState.SCHEDULED) && pausePosition != null) {
      pos = pausePosition;
    } else if (_sample?.playbackState != SchedulingState.PLAYING && pos == null && pausePosition != null) {
      pos = pausePosition;
    }
    if(pos != null) _lastPosition = pos;
    return pos ?? _lastPosition ?? Duration.zero;
  }

  bool get playing => status == PlayerNodeStatus.playing;

  PlayerNodeStatus _status = PlayerNodeStatus.pause;
  PlayerNodeStatus get status => _status;

  StreamController<PlayerNodeStatus> _onStatusController = StreamController.broadcast();
  Stream<PlayerNodeStatus> get onStatus => _onStatusController.stream;

  set status(PlayerNodeStatus v) {
    this._status = v;
    _onStatusController.add(v);
  }

  play(AudioBus bus, {double? when}) {
    pausePosition = null;
    _switchSample(bus, when: when);
    status = PlayerNodeStatus.playing;
  }

  resume({double? when}) {
    if(resource == null) return;
    if(playing) return;
    _switchSample(resource, when: when, offset: pausePosition ?? Duration.zero);
    status = PlayerNodeStatus.playing;
    pausePosition = null;
  }

  pause() {
    if(resource == null) return;
    if(sample == null) return null;
    pausePosition = sample?.position;
    _switchSample(resource, pause: true);
    status = PlayerNodeStatus.pause;
  }

  stop() {
    pausePosition = null;
    if(sample == null) return;
    _switchSample(null);
    status = PlayerNodeStatus.ended;
  }

  seekTo(Duration offset, {double? when}) {
    pausePosition = offset;
    if(status == PlayerNodeStatus.pause) {
      return;
    }
    if(resource == null) return;
    if (playing) {
      _switchSample(resource, when: when, offset: offset);
      status = PlayerNodeStatus.playing;
    }
  }

  _switchSample(AudioBus? bus, { double? when, Duration offset = Duration.zero, bool pause = false}) {
    final oldSample = sample;
    resource = bus;
    final startTime = when ?? this.audioContext.currentTime;
    final crossFadeEndTime = startTime + crossFadeTime;
    if(bus != null && !pause) {
      assert(!bus.released, "Resources have been released");
      if(autoSleep && !audioContext.device.isRunning)audioContext.resume();
      final newSample = GainAudioSampleNode(this.ctx, resource: resource);
      if(playbackRate != 1.0) {
        newSample.playbackRate.setValue(playbackRate);
      }
      newSample.connect(_out);
      sample = newSample;
      if (crossFadeTime > 0.01) {
        newSample.gain.setValue(0.001);
        newSample.gain.setValueAtTime(0.001, startTime);
        newSample.gain.exponentialRampToValueAtTime(1.0, crossFadeEndTime);
        newSample.start(when: startTime, offset: offset.inMilliseconds / 1000);
      } else {
        newSample.start(when: startTime, offset: offset.inMilliseconds / 1000);
      }
    }
    if (oldSample != null) {
      if (crossFadeTime > 0.01) {
        oldSample.gain.setValueAtTime(oldSample.gain.value, startTime);
        oldSample.gain.exponentialRampToValueAtTime(0.0, crossFadeEndTime);
        oldSample.stop(when: crossFadeEndTime);
        oldSample.endedDispose();
      }else {
        oldSample.stop();
        oldSample.dispose();
      }
      if(sample == oldSample) {
        sample = null;
        print("oldSample.hasFinished: ${oldSample.hasFinished}");
        oldSample.endedDispose(destroyed: () {
          print('oldSample.endedDispose2');
          if (autoSleep) {
            audioContext.suspend();
          }
        });
      }
    }
  }

  dispose() {
    _sample?.dispose();
    _onEndedController.close();
    super.dispose();
  }
}
