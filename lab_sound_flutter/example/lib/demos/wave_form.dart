import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:path_provider/path_provider.dart';

class WaveFormPage extends StatefulWidget {
  @override
  State<WaveFormPage> createState() => _WaveFormPageState();
}

class _WaveFormPageState extends State<WaveFormPage> {

  List<double> waveData = [];
  AudioBus? musicBus;

  Duration? time;

  Future<String> loadAsset(String path) async {
    final tempDir = await getTemporaryDirectory();
    final file = File(tempDir.path + '/' + path);
    await file.writeAsBytes(
        (await rootBundle.load('assets/' + path)).buffer.asUint8List());
    return file.path;
  }

  loadBus() async {
    final bus = await AudioBus.fromFile(await loadAsset('music3.mp3'));
    setState(() {
      musicBus = bus;
    });
  }


  generate(int width) async {
    final startTime = DateTime.now();
    final channel = musicBus?.channel(1);
    if(channel == null) return;
    final int length = channel.length;
    final binSize = length ~/ width;
    final data = channel.getData();

    final List<double> wave = [];
    for(int i = 0; i < width; i += 1) {
      final subList = data.skip(i * binSize).take(binSize).toList();
      final maxValue = subList.reduce((value, element) => max(element.abs(), value));
      wave.add(maxValue);
    }
     setState(() {
       this.waveData = wave;
       this.time = DateTime.now().difference(startTime);
     });
  }


  @override
  void initState() {
    super.initState();
    loadBus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WaveFormPage'),),
      body: Column(
        children: [
          if(musicBus == null)Text("loading data"),
          Container(
            height: 200,
            child: Row(
              children: [
                for(final db in waveData)Container(
                  color: Colors.green,
                  width: 1,
                  height: 200 * db,
                ),
              ],
            ),
          ),
          if(musicBus != null)OutlinedButton(onPressed: () {
            generate(MediaQuery.of(context).size.width.toInt());
          }, child: Text("generate")),
          if(time != null)Text("${time!.inMilliseconds}ms"),
        ],
      ),
    );
  }
}