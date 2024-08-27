import 'package:flutter/material.dart';

import 'package:lab_sound_flutter_example/demos/audio_playback.dart';
import 'package:lab_sound_flutter_example/demos/dial.dart';
import 'package:lab_sound_flutter_example/demos/recorder.dart';

import 'demos/audio_device.dart';
import 'demos/audio_listener_demo.dart';
import 'demos/convolver_demo.dart';
import 'demos/sfxr.dart';
import 'demos/zelda.dart';
import 'package:lab_sound_inspector/lab_sound_inspector.dart';

import 'fragment_shader/fragment_shader.dart';
import 'lab808/lab808.dart';
import 'labsound/labsound_examples.dart';
import 'oscillofun/oscillofun.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget shaderButton(String fragName, [String? musicPath]) {
    return ListTile(
        title: Text('Shader: ' + fragName),
        subtitle: Text(musicPath ?? "./assets/music4.mp3"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FragmentShaderDemo(
                      path: musicPath ?? "./assets/music4.mp3",
                      shaderAssetKey: "shaders/$fragName.frag",
                    )),
          );
        });
  }

  String? musicName = 'music1.mp3';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DebugGraph()),
                  );
                },
                icon: Icon(Icons.bug_report)),
            DropdownButton<String>(
                value: musicName,
                items: [
                  DropdownMenuItem(
                    child: Text("stereo-music-clip.wav"),
                    value: "stereo-music-clip.wav",
                  ),
                  DropdownMenuItem(
                    child: Text("music1.mp3"),
                    value: "music1.mp3",
                  ),
                  DropdownMenuItem(
                    child: Text("music2.mp3"),
                    value: "music2.mp3",
                  ),
                  DropdownMenuItem(
                    child: Text("music3.mp3"),
                    value: "music3.mp3",
                  ),
                  DropdownMenuItem(
                    child: Text("music4.mp3"),
                    value: "music4.mp3",
                  ),
                  DropdownMenuItem(
                    child: Text("oscillofun.wav"),
                    value: "oscillofun.wav",
                  ),
                  DropdownMenuItem(
                    child: Text("Attack Vector.wav"),
                    value: "Attack Vector.wav",
                  ),
                  DropdownMenuItem(
                    child: Text(
                        "Jerobeam Fenderson - How To Draw Mushrooms On An Oscilloscope With Sound.mp3"),
                    value:
                        "Jerobeam Fenderson - How To Draw Mushrooms On An Oscilloscope With Sound.mp3",
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    musicName = value;
                  });
                })
          ],
        ),
        body: ListView(
          children: [
            ListTile(
                title: Text("Simple audio playback"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AudioPlayback()),
                  );
                }),

            ListTile(
                title: Text("Dialpad"),
                subtitle: Text("OscillatorNode Demo"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dial()),
                  );
                }),

            ListTile(
                title: Text("Device List"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AudioDeviceList()),
                  );
                }),
            ListTile(
                title: Text("Microphone recording"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Recorder()),
                  );
                }),
            ListTile(
                title: Text("808"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Lab808()),
                  );
                }),

            if(musicName != null)shaderButton('audio_eclipse', "./assets/" + musicName!),
            if(musicName != null)shaderButton('sound_eclipse', "./assets/" + musicName!),
            if(musicName != null)shaderButton('audio_surf', "./assets/" + musicName!),
            if(musicName != null)shaderButton('2d_led_spectrum', "./assets/" + musicName!),
            if(musicName != null)shaderButton('polar_react', "./assets/" + musicName!),
            if(musicName != null)shaderButton('2d_audio_visualizer_v2', "./assets/" + musicName!),
            if(musicName != null)shaderButton('mf_audio_visualizer', "./assets/" + musicName!),
            if(musicName != null)shaderButton('blast_radius', "./assets/" + musicName!),
            if(musicName != null)shaderButton('procedural_gradient_visualiser', "./assets/" + musicName!),
            if(musicName != null)shaderButton('inercia_intended_one', "./assets/" + musicName!),

            if(musicName != null) ListTile(
                title: Text("Oscillofun"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Oscillofun(
                              path: "./assets/" + musicName!
                            )),
                  );
                }),

            ListTile(
                title: Text("Zelda"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Zelda()),
                  );
                }),
            ListTile(
                title: Text("3D positional sound"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AudioListenerDemo()),
                  );
                }),
            ListTile(
                title: Text("Room effects and filter"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConvolverDemo()),
                  );
                }),

            ListTile(
                title: Text("Sfxr"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Sfxr()),
                  );
                }),

            // ListTile(
            //     title: Text("Render Demo"),
            //     onTap: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => RenderAudioPage()),
            //       );
            //     }),
            // ListTile(
            //     title: Text("Microphone recorder"),
            //     onTap: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => Recorder()),
            //       );
            //     }),
            // ListTile(
            //     title: Text("zelda"),
            //     onTap: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => Zelda()),
            //       );
            //     }),
            ListTile(
                title: Text("LabSoundExamples"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LabSoundExamples()),
                  );
                }),

            // ListTile(
            //     title: Text("WaveFormPage"),
            //     onTap: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => WaveFormPage()),
            //       );
            //     })
          ],
        ));
  }
}
