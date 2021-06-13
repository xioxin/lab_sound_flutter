# lab_sound_flutter
**WIP**

lab_sound_flutter is the [LabSound](https://github.com/LabSound/LabSound) wrapper for Flutter.

Currently only the Android platform is available, other platforms have encountered some difficulties in integration, I am still working on it. If you have a good solution, please feel free to submit Issues or PR.

## Platform
* [x] Android
* [ ] iOS
* [ ] Mac
* [ ] Windows
* [ ] Linux




# Building

The project uses the git submodule so it is required that new users clone the repository with the `--recursive` option.

The submodules can be fetched after a clone with `git submodule update --init --recursive`

# Android
Requires cmake >= 3.13

If you are using cmake version 3.18.1 and you get an invalid version number error, please try upgrading the gradle version

## Binding

* [x] AnalyserNode
* [ ] AudioBasicInspectorNode
* [ ] AudioBasicProcessorNode
* [x] AudioBus & AudioFileReader
* [ ] AudioChannel
* [x] AudioContext
* [ ] AudioDevice
    * [x] AudioStreamConfig
* [x] AudioHardwareDeviceNode
* [ ] AudioHardwareInputNode
* [ ] AudioListener
* [x] AudioNode
* [ ] AudioNodeInput
* [ ] AudioNodeOutput
* [x] AudioParam & AudioParamTimeline
* [ ] AudioSummingJunction
* [x] BiquadFilterNode
* [x] ChannelMergerNode
* [x] ChannelSplitterNode
* [ ] ConvolverNode *next* <!-- 卷积 -->
* [ ] DelayNode  *next* <!-- 延迟 -->
* [x] DynamicsCompressorNode
* [x] GainNode
* [ ] NullDeviceNode
* [x] OscillatorNode
* [x] PannerNode
* [ ] RealtimeAnalyser
* [x] SampledAudioNode
* [ ] StereoPannerNode *next* <!-- 声道均衡 -->
* [x] WaveShaperNode

* [x] ADSRNode
* [ ] BPMDelayNode
* [ ] ClipNode
* [ ] DiodeNode
* [ ] FunctionNode
* [ ] GranulationNode <!-- 是一个音频合成 -->
* [x] NoiseNode
* [ ] PdNode
* [ ] PeakCompNode
* [ ] PingPongDelayNode
* [x] PolyBLEPNode
* [ ] PowerMonitorNode *next* <!-- 电平？ -->
* [ ] PWMNode
* [x] RecorderNode
* [ ] SfxrNode <!-- 一个很高级的功能 https://sfxr.me/ -->
* [ ] SpatializationNode
* [ ] SpectralMonitorNode
* [ ] SupersawNode

