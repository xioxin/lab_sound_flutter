# lab_sound_flutter
**WIP**

lab_sound_flutter is the [LabSound](https://github.com/LabSound/LabSound) wrapper for Flutter.

There have been some difficulties with integration on Mac and iOS platforms, and I'm still working on it. If you have a good solution, please feel free to submit Issues or PR.

## Platform
* [x] Android
* [x] iOS
* [x] Mac
* [x] Windows
* [x] Linux
* [ ] Web

## Todo
* [x] iOS support
* [x] iOS simulator support (x86_64)
* [ ] macOS M1 support (arm64)
* [ ] Add Android backend selection (AAudio, OpenCL)
* [ ] Continue to improve binding
* [ ] Refactoring using the "endorsed federated plugin" pattern and bringing the API style closer to "dart: web_audio" to increase web support

## Binding

https://github.com/xioxin/lab_sound_bridge

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
* [x] ConvolverNode
* [x] DelayNode
* [x] DynamicsCompressorNode
* [x] GainNode
* [ ] NullDeviceNode
* [x] OscillatorNode
* [x] PannerNode
* [ ] RealtimeAnalyser
* [x] SampledAudioNode
* [x] StereoPannerNode
* [x] WaveShaperNode

* [x] ADSRNode
* [x] BPMDelayNode
* [ ] ClipNode
* [ ] DiodeNode
* [ ] FunctionNode
* [ ] GranulationNode <!-- 是一个音频合成 -->
* [x] NoiseNode
* [ ] PdNode
* [ ] PeakCompNode
* [ ] PingPongDelayNode
* [x] PolyBLEPNode
* [x] PowerMonitorNode
* [ ] PWMNode
* [x] RecorderNode
* [ ] SfxrNode <!-- 一个很高级的功能 https://sfxr.me/ -->
* [ ] SpatializationNode
* [ ] SpectralMonitorNode
* [ ] SupersawNode

