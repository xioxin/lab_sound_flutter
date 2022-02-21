import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:lab_sound_flutter_example/draw_frequency.dart';
import 'package:lab_sound_flutter_example/draw_time_domain.dart';

import '../wave_form.dart';

class DebugGraph extends StatefulWidget {
  @override
  _DebugGraphState createState() => _DebugGraphState();
}

class _DebugGraphState extends State<DebugGraph> {

  late Timer timer;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: InteractiveViewer(
            constrained: false,
            boundaryMargin: EdgeInsets.all(100),
            minScale: 0.0001,
            maxScale: 10.6,
            child: graph.nodes.isEmpty ? Text("EMPTY") : GraphView(
              graph: graph,
              algorithm: SugiyamaAlgorithm(builder),
              paint: Paint()
                ..color = Colors.green
                ..strokeWidth = 1
                ..style = PaintingStyle.stroke,
              builder: (Node node) {
                return rectangleWidget(node.key!.value);
              },
            )));
  }

  Random r = Random();

  Widget audioParamWidget(String name, AudioParam param, {double step = 1}) {

    final fixed = param.maxValue.toStringAsFixed(2) == param.minValue.toStringAsFixed(2);

    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name + "${param.value.toStringAsFixed(2)} (Range:${param.minValue.toStringAsFixed(2)} - ${param.maxValue.toStringAsFixed(2)}, Def: ${param.defaultValue})"),
          if(!fixed) Column(
            children: [
              Slider(
                  value: param.value,
                  min: min(param.maxValue, param.minValue),
                  max: max(param.maxValue, param.minValue),
                  onChanged: (val) {
                    setState(() {
                      param.setValue(val);
                    });
                  }),
              Row(children: [
                TextButton(onPressed: () {
                  setState(() {
                    param.setValue(max(param.value - step, param.minValue));
                  });
                }, child: Text('-${step}')),
                TextButton(onPressed: () {
                  setState(() {
                    param.setValue(param.defaultValue);
                  });
                }, child: Text('Default')),
                TextButton(onPressed: () {
                  setState(() {
                    param.setValue(min(param.value + step, param.maxValue));
                  });
                }, child: Text('+${step}')),
              ])
            ],
          )
        ],
      ),
    );
  }

  Widget selectWidget(String name, List<String> list, String value, ValueChanged<String?> onChanged ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name + "${value})"),
        DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? newValue) {
            onChanged(newValue);
          },
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }


  Widget startStopButton(AudioScheduledSourceNode node) {
    return Row(
      children: [
        TextButton(onPressed: () {
          node.start();
        }, child: Text("Start")),
        TextButton(onPressed: () {
          node.stop();
        }, child: Text("Stop"))
      ],
    );
  }

  Widget labAudioWidget(dynamic node) {
    if (node is AudioBus) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 60,
            color: Colors.white,
            child: WaveForm(node, key: ObjectKey(node)),
          ),
          Text("name: ${node.debugName}"),
          Text("length: ${node.lengthInSeconds}s"),
          Text("sampleRate: ${node.sampleRate}"),
          Text("channels: ${node.numberOfChannels}"),
        ],
      );
    } else if (node is AudioSampleNode) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("position: ${node.position}"),
          SizedBox(height: 3, width: 200,child: LinearProgressIndicator(value: (node.position?.inMilliseconds ?? 0.0) / (node.duration?.inMilliseconds ?? 1.0),)),
          Text("playbackState: ${node.playbackState}"),
          audioParamWidget("playbackRate: ", node.playbackRate, step: 0.2),
          startStopButton(node),
        ],
      );
    } else if (node is AudioHardwareDeviceNode) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("channelCount: ${node.channelCount}"),
          Text("sampleRate: ${node.ctx.sampleRate}"),
        ],
      );
    } else if (node is OscillatorNode) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          selectWidget("type:", OscillatorType.values.map((e) => e.name).toList() , node.type.name, (String? value) {
            setState(() {
              if(value != null) node.setType(OscillatorType.values.firstWhere((element) => element.name == value));
            });
          }),
          audioParamWidget("frequency: ", node.frequency),
          audioParamWidget("detune: ", node.detune),
          audioParamWidget("amplitude: ", node.amplitude),
          audioParamWidget("bias: ", node.bias),
          startStopButton(node),
        ],
      );
    } else if (node is GainNode) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          audioParamWidget("gain: ", node.gain),
        ],
      );
    } else if (node is AnalyserNode) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("fftSize: ${node.fftSize}"),
          Divider(height: 1,),
          Container(
              width: 200,
              height: 50,
              color: Colors.white,
              child: DrawTimeDomain(node)
          ),
          Divider(height: 1,),
          Container(
            width: 200,
              height: 60,
              child: DrawFrequency(node)
          ),
        ],
      );
    } else if (node is DynamicsCompressorNode) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          audioParamWidget("threshold: ", node.threshold),
          audioParamWidget("knee: ", node.knee),
          audioParamWidget("ratio: ", node.ratio),
          audioParamWidget("attack: ", node.attack),
          audioParamWidget("release: ", node.release),
          audioParamWidget("reduction: ", node.reduction),
        ],
      );
    } else if (node is NoiseNode) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          selectWidget("type:", NoiseType.values.map((e) => e.name).toList() , node.type.name, (String? value) {
            setState(() {
              if(value != null) node.type = (NoiseType.values.firstWhere((element) => element.name == value));
            });
          }),
        ],
      );
    }
    return Text("No details");
  }

  Widget rectangleWidget(dynamic node) {
    String name = "";
    if (node is AudioNode) {
      name = node.name;
    } else if (node is AudioBus) {
      name = "AudioBus";
    }

    return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(color: Colors.blue[100]!, spreadRadius: 1),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(name),
            SizedBox(width: 200, child: DefaultTextStyle(child: labAudioWidget(node), style: Theme.of(context).textTheme.caption!,)),
          ],
        ));
  }

  Graph graph = Graph();
  SugiyamaConfiguration builder = SugiyamaConfiguration();

  buildNode() {
    graph.edges.clear();
    graph.nodes.clear();
    LabSound().allNodes.forEach((element) {
      if(element.released) return;
      final node = Node.Id(element);
      element.linked.forEach((dstNode) {
        if(dstNode.released) return;
        graph.addEdge(node, Node.Id(dstNode));
        if (element is AudioSampleNode) {
          final resource = element.resource;
          if (resource != null) {
            if(resource.released) return;
            graph.addEdge(Node.Id(resource), node);
          }
        }
      });
    });
  }

  check() {
    setState(() {
      buildNode();
    });
  }

  @override
  void initState() {

    buildNode();
    timer = Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      check();
    });

    builder
      ..nodeSeparation = (15)
      ..levelSeparation = (15)
      ..orientation = SugiyamaConfiguration.ORIENTATION_LEFT_RIGHT;
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
