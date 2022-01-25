# lab_sound_flutter
**开发中**

lab_sound_flutter 是 [LabSound](https://github.com/LabSound/LabSound) 的Flutter版封装。
它提供了类似于WebAudioApi类似的功能。

## 支持平台
* [x] Android
* [x] iOS
* [x] Mac
* [x] Windows
* [x] Linux
* [ ] Web

## Todo
* [x] iOS 支持
* [x] iOS 模拟器的支持（x86_64）
* [ ] macOS M1 CPU 支持 (arm64)
* [ ] 增加Android音频后端选择 (AAudio, OpenCL)
* [ ] 继续完善绑定
* [ ] 使用“受信的联合插件”模式重构，并将Api风格与"dart:web_audio"对齐，并增加Web支持。

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

