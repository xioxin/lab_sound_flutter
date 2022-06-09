import 'package:lab_sound_flutter/lab_sound_flutter.dart';

abstract class Tone {
  String get name;
  final AudioContext context;
  final AudioNode destination;
  Tone(this.context, this.destination);
  trigger(double time);
}