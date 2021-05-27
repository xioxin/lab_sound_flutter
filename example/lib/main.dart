import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:lab_sound_flutter_example/demos/dial.dart';
import 'package:lab_sound_flutter_example/demos/player.dart';
import 'package:lab_sound_flutter_example/demos/test.dart';
import 'package:lab_sound_flutter_example/draw_frequency.dart';
import 'package:lab_sound_flutter_example/draw_time_domain.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
      home: MyApp()
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: [
            ListTile(title: Text("播放器"), onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlayerPage()),
              );
            }),
            ListTile(title: Text("测试"), onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TestPage()),
              );
            }),
            ListTile(title: Text("拨号盘"), onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dial()),
              );
            })
          ],
        )
    );
  }
}

