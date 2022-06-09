import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart'
    hide audioBusFromAsset;
import 'package:lab_sound_inspector/lab_sound_inspector.dart';

Future<AudioBus> audioBusFromAsset(String assetName,
    {String extension = '',
    AssetBundle? bundle,
    String? package,
    String? debugName,
    bool mixToMono = false}) async {
  String keyName = package == null ? assetName : 'packages/$package/$assetName';
  final AssetBundle chosenBundle = bundle ?? rootBundle;
  final asset = await chosenBundle.load(keyName);
  print("AudioBus.fromBuffer");
  return await AudioBus.fromBuffer(asset.buffer.asUint8List(),
      extension: extension,
      debugName: debugName ?? keyName,
      mixToMono: mixToMono);
}

class AudioListenerDemo extends StatefulWidget {
  const AudioListenerDemo({Key? key}) : super(key: key);

  @override
  State<AudioListenerDemo> createState() => _AudioListenerDemoState();
}

class _AudioListenerDemoState extends State<AudioListenerDemo> {
  Alignment? alignment;

  late AudioContext ctx;
  late AudioSampleNode audioSample;
  late PannerNode pannerNode;
  AudioBus? audioBus;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    ctx.dispose();
    super.dispose();
  }

  init() async {
    ctx = AudioContext();
    audioSample = AudioSampleNode(ctx);
    pannerNode = PannerNode(ctx);
    audioSample.connect(pannerNode);
    pannerNode.connect(ctx.destination);
    print("audioBusFromAsset stereo-music-clip.wav");
    audioBus = await audioBusFromAsset('assets/stereo-music-clip.wav');
    print("[OK]audioBusFromAsset stereo-music-clip.wav");

    setState(() {
      audioSample.setBus(audioBus!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.grey[200],
      body: DebugScaffold(
        child: SingleChildScrollView(
          child: Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Touch this box"),
              if (audioBus != null)
                GestureDetector(
                  onPanDown: (details) {
                    this.audioSample.start();
                    final offset =
                        (details.localPosition - Offset(150, 150)) / 150;
                    setState(() {
                      alignment = Alignment(offset.dx, offset.dy);
                    });
                    pannerNode.setPosition(offset.dx, offset.dy, 0);
                  },
                  onPanUpdate: (details) {
                    final offset =
                        (details.localPosition - Offset(150, 150)) / 150;
                    setState(() {
                      alignment = Alignment(offset.dx, offset.dy);
                    });
                    pannerNode.setPosition(offset.dx, offset.dy, -0.5);
                  },
                  child: Card(
                    elevation: 3,
                    child: Container(
                      width: 300,
                      height: 300,
                      color: Colors.white,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Icon(Icons.emoji_people),
                          ),
                          if (alignment != null)
                            Align(
                              alignment: alignment!,
                              child: Icon(Icons.volume_up),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          )),
        ),
      ),
    );
  }
}