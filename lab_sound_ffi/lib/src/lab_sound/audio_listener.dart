import 'package:lab_sound_ffi/lab_sound_ffi.dart';

import 'audio_context.dart';
import 'audio_node.dart';
import 'audio_scheduled_source_node.dart';
import 'lab_sound.dart';

class AudioListener {
  final int listenerId;
  AudioContext ctx;

  late AudioParam playbackRate;
  late AudioParam detune;

  AudioListener(this.ctx)
      : listenerId = LabSound().createAudioListener(ctx.pointer);
  AudioListener.fromId(this.ctx, this.listenerId);

  bool get has => LabSound().AudioListener_has(listenerId) > 0;

  setPosition(double x, double y, double z) {
    LabSound().AudioListener_setPosition(listenerId, x, y, z);
  }

  AudioParam get positionX => AudioParam(
      ctx, listenerId, LabSound().AudioListener_positionX(listenerId));
  AudioParam get positionY => AudioParam(
      ctx, listenerId, LabSound().AudioListener_positionY(listenerId));
  AudioParam get positionZ => AudioParam(
      ctx, listenerId, LabSound().AudioListener_positionZ(listenerId));

  setOrientation(
      double x, double y, double z, double upX, double upY, double upZ) {
    LabSound().AudioListener_setOrientation(listenerId, x, y, z, upX, upY, upZ);
  }

  setForward(double x, double y, double z) {
    LabSound().AudioListener_setForward(listenerId, x, y, z);
  }

  AudioParam get forwardX => AudioParam(
      ctx, listenerId, LabSound().AudioListener_forwardX(listenerId));
  AudioParam get forwardY => AudioParam(
      ctx, listenerId, LabSound().AudioListener_forwardY(listenerId));
  AudioParam get forwardZ => AudioParam(
      ctx, listenerId, LabSound().AudioListener_forwardZ(listenerId));

  setUpVector(double x, double y, double z) {
    LabSound().AudioListener_setUpVector(listenerId, x, y, z);
  }

  AudioParam get upX =>
      AudioParam(ctx, listenerId, LabSound().AudioListener_upX(listenerId));
  AudioParam get upY =>
      AudioParam(ctx, listenerId, LabSound().AudioListener_upY(listenerId));
  AudioParam get upZ =>
      AudioParam(ctx, listenerId, LabSound().AudioListener_upZ(listenerId));

  setVelocity(double x, double y, double z) {
    LabSound().AudioListener_setVelocity(listenerId, x, y, z);
  }

  AudioParam get velocityX => AudioParam(
      ctx, listenerId, LabSound().AudioListener_velocityX(listenerId));
  AudioParam get velocityY => AudioParam(
      ctx, listenerId, LabSound().AudioListener_velocityY(listenerId));
  AudioParam get velocityZ => AudioParam(
      ctx, listenerId, LabSound().AudioListener_velocityZ(listenerId));

  setDopplerFactor(double dopplerFactor) {
    LabSound().AudioListener_setDopplerFactor(listenerId, dopplerFactor);
  }

  AudioParam get dopplerFactor => AudioParam(
      ctx, listenerId, LabSound().AudioListener_dopplerFactor(listenerId));

  setSpeedOfSound(double dopplerFactor) {
    LabSound().AudioListener_setSpeedOfSound(listenerId, dopplerFactor);
  }

  AudioParam get speedOfSound => AudioParam(
      ctx, listenerId, LabSound().AudioListener_speedOfSound(listenerId));
}
