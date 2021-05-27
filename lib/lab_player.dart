import 'dart:async';
import 'lab_sound/lab_sound.dart';
import 'package:rxdart/rxdart.dart';

enum LabPlayerStatus {
  pause, playing, ended,
}

class LabPlayer {
  late AudioContext audioContext;
  AudioSampleNode? _player;
  GainNode? playerGainNode;
  AudioBus? audioData;
  AudioBus? readyAudioData;
  late GainNode masterGainNode;
  double _volume = 1.0;
  double crossfadeTime = 0.3;
  bool get playing => status == LabPlayerStatus.playing;




  LabPlayer({ AudioContext? audioContext, Duration? clockDuration = const Duration(milliseconds: 100) }) {
    this.audioContext = audioContext ?? AudioContext(initSampleRate: 48000.0, channels: 2);
    this.masterGainNode = GainNode(this.audioContext);
    this.masterGainNode.connect(this.audioContext.destination);
    _volume = this.masterGainNode.gain.value;


  }

  AudioSampleNode? get player => _player;
  set player (AudioSampleNode? v) {
    print("设置新的播放器: $v");
    _subscriptionPosition?.cancel();
    _subscriptionEnded?.cancel();
    _player = v;
    if(_player == null) {
      this._onPositionController.add(Duration.zero);
      return;
    }
    this._onPositionController.add(_player!.position!);
    if(_playbackRate != 1.0) {
      playbackRate = playbackRate;
    }
    // todo: 监听位置
    // _subscriptionPosition = _player!.onPosition.listen((event) {
    //   this._onPositionController.add(event);
    // });
    _subscriptionEnded = _player!.onEnded.listen((event) {
      final isOver = status == LabPlayerStatus.playing;
      status = LabPlayerStatus.ended;
      this._onEndedController.add(isOver);
      if(isOver) {
        _onPositionController.add(Duration.zero);
      }
    });
    posWaitingPlayerSwitch = false;
  }


  AudioSampleNode createBufferSource(AudioBus audio) {
    return AudioSampleNode(audioContext, resource: audio);
  }

  bool get playerPosIsZero => (player?.position ?? Duration(milliseconds: 0)).inMilliseconds == 0;

  Duration get position {
    if(player == null){
      return Duration.zero;
    }
    if(startPosition != null && !player!.isPlayingOrScheduled) {
      return startPosition ?? Duration.zero;
    }
    if(playerPosIsZero) {
      return _startPositionLast ?? Duration.zero;
    }
    return player!.position ?? Duration.zero;
  }


  Duration get duration => player?.duration ?? Duration(milliseconds: 0);

  bool posWaitingPlayerSwitch = false;
  Duration? _startPosition;
  Duration? _startPositionLast = Duration.zero;
  set startPosition(Duration? v) {
    _startPosition = v;
    if(v != null) {
      _startPositionLast = v;
    }
  }
  Duration? get startPosition => _startPosition;

  reset() {
    _startPosition = null;
    _startPositionLast = Duration.zero;
    player?.reset();
  }

  double _playbackRate = 1.0;
  double get playbackRate => _playbackRate;
  set playbackRate(double val) {
    if(player?.released == false){
      player?.playbackRate.setValue(val);
    }
    _playbackRate = val;
  }

  double get percentage => this.duration.inMilliseconds == 0 ? 0 : this.position.inMilliseconds / this.duration.inMilliseconds;

  Duration percentageToTime(double per) => Duration(milliseconds: (this.duration.inMilliseconds * per).toInt());

  LabPlayerStatus _status = LabPlayerStatus.pause;
  LabPlayerStatus get status {
    return this._status;
  }
  set status(LabPlayerStatus v) {
    this._status = v;
    _onStatusController.add(v);
  }
  StreamController<LabPlayerStatus> _onStatusController = StreamController.broadcast();
  Stream<LabPlayerStatus> get onStatus => _onStatusController.stream;

  StreamSubscription? _subscriptionEnded;
  StreamController<bool> _onEndedController = StreamController.broadcast();
  Stream<bool> get onEnded => _onEndedController.stream;

  StreamSubscription? _subscriptionPosition;
  StreamController<Duration> _onPositionController = StreamController.broadcast();
  Stream<Duration> get onPosition => _onPositionController.stream;


  double get volume => _volume;
  set volume (double value) {
    this._volume = value;
    masterGainNode.gain.setValue(value);
  }

  loadFile(String path) {
    readyAudioData?.dispose();
    this.readyAudioData = AudioContext.decodeAudioFile(path);
  }

  play(String path) {
    if(playing) return;
    loadFile(path);
    if (readyAudioData != null) {
      playFromBus(readyAudioData!);
    }
  }

  stop() {
    if(player == null) return;
    final oldPlayer = player;
    final oldPlayerGainNode = playerGainNode;
    if(playing) {
      if(crossfadeTime > 0.1 && playerGainNode != null && player != null) {
        final startTime = this.audioContext.currentTime + 0.01;
        oldPlayerGainNode?.gain.setValueAtTime(oldPlayerGainNode.gain.value, startTime);
        oldPlayerGainNode?.gain.exponentialRampToValueAtTime(
            0.001, startTime + crossfadeTime);
        oldPlayer?.stop(when: startTime + crossfadeTime);
        oldPlayer?.endedDispose(destroyed: () {
          oldPlayerGainNode?.dispose();
        });
      } else {
        oldPlayer?.stop(when: 0);
        oldPlayer?.dispose();
        oldPlayerGainNode?.dispose();
      }
    }else {
      oldPlayer?.dispose();
      oldPlayerGainNode?.dispose();
    }
    player = null;
    playerGainNode = null;
    startPosition = null;
  }

  playFromBus(AudioBus bus, {double? when}) {

    assert(!bus.released, "播放的资源已释放");

    final oldPlayer = player;
    final oldGainNode = playerGainNode;
    final newPlayer = createBufferSource(bus);
    final newGainNode = GainNode(this.audioContext);
    newPlayer.connect(newGainNode);
    newGainNode.connect(this.masterGainNode);
    player = newPlayer;
    playerGainNode = newGainNode;
    if(crossfadeTime > 0.1 && playerGainNode != null) {
      final startTime = when ?? this.audioContext.currentTime;
      final oldEndTime = this.audioContext.currentTime + crossfadeTime;
      newGainNode.gain.setValue(0);
      newGainNode.gain.setValueAtTime(0.001, startTime);
      newGainNode.gain.exponentialRampToValueAtTime(1.0, oldEndTime);
      newPlayer.start(when: startTime);
      if(oldPlayer != null) {
        oldGainNode?.gain.setValueAtTime(oldGainNode.gain.value, startTime + 0.01);
        oldGainNode?.gain.exponentialRampToValueAtTime(0.0, oldEndTime);
        oldPlayer.stop(when: oldEndTime + 2.0);
        oldPlayer.endedDispose(destroyed: () {
          oldGainNode?.dispose();
        });
      }
    }else {
      newPlayer.start(when: when);
      oldPlayer?.stop();
      oldPlayer?.dispose();
    }
    status = LabPlayerStatus.playing;
    startPosition = null;
    _startPositionLast = null;
  }

  resume({double? when}) {
    if(player == null) return;

    if(crossfadeTime > 0.1 && playerGainNode != null) {
      final startTime = (when ?? this.audioContext.currentTime) + 0.01;
      playerGainNode?.gain.setValueAtTime(0.001, startTime);
      playerGainNode?.gain.exponentialRampToValueAtTime(1.0, startTime + crossfadeTime);
    }
    if(startPosition != null) {
      posWaitingPlayerSwitch = true;
      final oldPlayer = player;
      final newPlayer = createBufferSource(player!.resource!);
      newPlayer.connect(playerGainNode!);
      newPlayer.start(when: when ?? this.audioContext.currentTime, offset: startPosition!.inMilliseconds / 1000);
      player = newPlayer;
      oldPlayer?.dispose();
    } else {
      player?.start(when: when);
    }
    status = LabPlayerStatus.playing;
    startPosition = null;
  }

  pause() {
    startPosition = player?.position;
    if(crossfadeTime > 0.1 && playerGainNode != null) {
      final startTime = this.audioContext.currentTime + 0.01;
      playerGainNode?.gain.setValueAtTime(playerGainNode!.gain.value, startTime);
      playerGainNode?.gain.exponentialRampToValueAtTime(
          0.001, startTime + crossfadeTime);
      player?.stop(when: startTime + crossfadeTime);
    } else {
      player?.stop(when: 0);
    }
    status = LabPlayerStatus.pause;
  }

  seekTo(Duration pos, {double? when}) {
    posWaitingPlayerSwitch = true;
    startPosition = pos;
    if(player == null) return;
    if (status == LabPlayerStatus.playing) {
      if (crossfadeTime > 0.1 && playerGainNode != null) {
        final oldPlayer = player;
        final oldGainNode = playerGainNode;
        final newPlayer = createBufferSource(player!.resource!);
        final newGainNode = GainNode(audioContext);
        newPlayer.connect(newGainNode);
        newGainNode.connect(this.masterGainNode);
        final startTime = when ?? (this.audioContext.currentTime + 0.2);
        final oldEndTime = this.audioContext.currentTime + crossfadeTime;
        newGainNode.gain.setValue(0);
        newGainNode.gain.setValueAtTime(0.001, startTime );
        newGainNode.gain.exponentialRampToValueAtTime(1.0, oldEndTime);
        newPlayer.start(when: startTime, offset: pos.inMilliseconds / 1000);
        player = newPlayer;
        playerGainNode = newGainNode;
        oldGainNode?.gain.setValueAtTime(oldGainNode.gain.value, startTime);
        oldGainNode?.gain.exponentialRampToValueAtTime(1.0, oldEndTime);
        oldPlayer?.stop(when: oldEndTime);
        oldPlayer?.endedDispose(destroyed: () {
          oldGainNode?.dispose();
        });
      } else {
        player?.start(when: when ?? 0, offset: pos.inMilliseconds / 1000);
      }
      status = LabPlayerStatus.playing;
    }else {
      startPosition = pos;
      status = LabPlayerStatus.pause;
      return;
    }
  }

  dispose() {
    startPosition = null;
    player?.stop();
    player?.dispose();
    _subscriptionPosition?.cancel();
    _subscriptionEnded?.cancel();
    _onEndedController.close();
    _onPositionController.close();
    _onStatusController.close();
  }

}