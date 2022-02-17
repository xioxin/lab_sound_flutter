import 'package:flutter/material.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';

class AudioDeviceList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceList = LabSound().makeAudioDeviceList();
    print(deviceList.join("\n"));

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: deviceList
            .map((e) => ListTile(
                  leading: audioIcon(e),
                  title: Text("[${e.index}] ${e.identifier ?? "no name"}"),
                  subtitle: e.supportedSampleRates == null
                      ? Text("${e.nominalSampleRate}")
                      : Wrap(
                      spacing: 4.0,
                          children: e.supportedSampleRates!
                              .map((sr) => Text(
                                    "$sr",
                                    style: sr != e.nominalSampleRate
                                        ? Theme.of(context).textTheme.caption
                                        : Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(color: Colors.black),
                                  ))
                              .toList(),
                        ),
                  trailing: ((e.isDefaultInput ?? false) ||
                          (e.isDefaultOutput ?? false))
                      ? Icon(Icons.check)
                      : null,
                ))
            .toList(),
      ),
    );
  }

  Widget audioIcon(AudioDeviceInfo device) {
    if (device.numInputChannels != 0) {
      return Icon(
        Icons.mic,
      );
    } else if (device.numOutputChannels != 0) {
      return Icon(
        Icons.headphones,
      );
    }
    return Icon(
      Icons.help_outline,
    );
  }
}
