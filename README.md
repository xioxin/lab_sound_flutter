# lab_sound_flutter

lab_sound_flutter is a wrapper for [LabSound](https://github.com/LabSound/LabSound)'s Flutter.

## Platform
* [x] Android
* [ ] iOS
* [ ] Mac
* [ ] Windows
* [ ] Linux

**WIP**


<!-- * [x] AnalyserNode
    * [x] setFftSize
    * [x] fftSize
    * [x] frequencyBinCount
    * [x] setMinDecibels
    * [x] minDecibels
    * [x] setMaxDecibels
    * [x] maxDecibels
    * [x] setSmoothingTimeConstant
    * [x] smoothingTimeConstant
    * [x] getFloatFrequencyData
    * [x] getByteFrequencyData
    * [x] getFloatTimeDomainData
    * [x] getByteTimeDomainData
* [ ] AudioBasicInspectorNode
* [ ] AudioBasicProcessorNode
* [ ] AudioBus
    * [ ] void setChannelMemory(int channelIndex, float * storage, int length);
    * [x] int numberOfChannels() const
    * [ ] AudioChannel * channel(int channel) 
    * [ ] AudioChannel * channelByType(Channel type);
    * [ ] const AudioChannel * channelByType(Channel type);
    * [x] int length()
    * [ ] void resizeSmaller(int newLength)
    * [x] float sampleRate()
    * [x] void setSampleRate(float sampleRate)
    * [x] void zero();
    * [x] void clearSilentFlag()
    * [x] bool isSilent()
    * [ ] bool topologyMatches(const AudioBus & sourceBus)
    * [x] void scale(float scale)
    * [x] void reset()
    * [ ] void copyFrom(const AudioBus & sourceBus, ChannelInterpretation = ChannelInterpretation::Speakers)
    * [ ] void sumFrom(const AudioBus & sourceBus, ChannelInterpretation = ChannelInterpretation::Speakers)
    * [ ] void copyWithGainFrom(const AudioBus & sourceBus, float * lastMixGain, float targetGain)
    * [ ] void copyWithSampleAccurateGainValuesFrom(const AudioBus & sourceBus, float * gainValues, int numberOfGainValues);
    * [ ] float maxAbsValue()
    * [ ] void normalize()
    * [x] bool isFirstTime()
    * [ ] static std::unique_ptr<AudioBus> createBufferFromRange(const AudioBus * sourceBus, int startFrame, int endFrame)
    * [ ] static std::unique_ptr<AudioBus> createBySampleRateConverting(const AudioBus * sourceBus, bool mixToMono, float newSampleRate)
    * [ ] static std::unique_ptr<AudioBus> createByMixingToMono(const AudioBus * sourceBus)
    * [ ] static std::unique_ptr<AudioBus> createByCloning(const AudioBus * sourceBus);
* [ ] AudioChannel
* [ ] AudioContext
* [ ] AudioDevice
* [ ] AudioHardwareDeviceNode
* [ ] AudioHardwareInputNode
* [ ] AudioListener
* [ ] AudioNode
    * [ ] AudioNodeScheduler
        * [ ] void start(double when);
        * [ ] void stop(double when);
        * [ ] void finish(ContextRenderLock&);
        * [ ] void reset();
        * [ ] SchedulingState playbackState();
        * [ ] bool hasFinished();
        * [ ] bool update(ContextRenderLock&, int epoch_length);
    * [x] AudioNode
        * [x] virtual const char* name()
        * [x] virtual void reset(ContextRenderLock &)
        * [ ] virtual double tailTime(ContextRenderLock & r)
        * [ ] virtual double latencyTime(ContextRenderLock & r)
        * [x] virtual bool isScheduledNode()
        * [x] virtual void initialize();
        * [x] virtual void uninitialize();
        * [x] bool isInitialized();
        * [ ] void addInput(ContextGraphLock&, std::unique_ptr<AudioNodeInput> input);
        * [ ] void addOutput(ContextGraphLock&, std::unique_ptr<AudioNodeOutput> output);
        * [x] int numberOfInputs() const { return static_cast<int>(m_inputs.size()); }
        * [x] int numberOfOutputs() const { return static_cast<int>(m_outputs.size()); }
        * [ ] std::shared_ptr<AudioNodeInput> input(int index);
        * [ ] std::shared_ptr<AudioNodeOutput> output(int index);
        * [ ] std::shared_ptr<AudioNodeOutput> output(char const* const str);
        * [ ] void processIfNecessary(ContextRenderLock & r, int bufferSize);
        * [ ] virtual void checkNumberOfChannelsForInput(ContextRenderLock &, AudioNodeInput *);
        * [ ] virtual void conformChannelCounts();
        * [ ] virtual bool propagatesSilence(ContextRenderLock & r) const;

    bool inputsAreSilent(ContextRenderLock &);
    void silenceOutputs(ContextRenderLock &);
    void unsilenceOutputs(ContextRenderLock &);

    int channelCount();
    void setChannelCount(ContextGraphLock & g, int channelCount);

    ChannelCountMode channelCountMode() const { return m_channelCountMode; }
    void setChannelCountMode(ContextGraphLock & g, ChannelCountMode mode);

    ChannelInterpretation channelInterpretation() const { return m_channelInterpretation; }
    void setChannelInterpretation(ChannelInterpretation interpretation) { m_channelInterpretation = interpretation; }
* [ ] AudioNodeInput
* [ ] AudioNodeOutput
* [ ] AudioParam
* [ ] AudioParamTimeline
* [ ] AudioSummingJunction
* [ ] BiquadFilterNode
* [ ] ChannelMergerNode
* [ ] ChannelSplitterNode
* [ ] ConvolverNode
* [ ] DelayNode
* [ ] DynamicsCompressorNode
* [ ] GainNode
* [ ] NullDeviceNode
* [ ] OscillatorNode
* [ ] PannerNode
* [ ] RealtimeAnalyser
* [x] SampledAudioNode
    * [x] void setBus(ContextRenderLock&, std::shared_ptr<AudioBus> sourceBus)
    * [ ] std::shared_ptr<AudioBus> getBus()
    * [x] void schedule(float relative_when)
    * [x] void schedule(float relative_when, int loopCount)
    * [x] void schedule(float relative_when, float grainOffset, int loopCount)
    * [x] void schedule(float relative_when, float grainOffset, float * [ ] grainDuration, int loopCount)
    * [x] void start(float abs_when)
    * [x] void start(float abs_when, int loopCount)
    * [x] void start(float abs_when, float grainOffset, int loopCount)
    * [x] void start(float abs_when, float grainOffset, float grainDuration, int loopCount)
    * [x] void clearSchedules()
    * [x] std::shared_ptr<AudioParam> playbackRate()
    * [x] std::shared_ptr<AudioParam> detune()
    * [x] std::shared_ptr<AudioParam> dopplerRate()
    * [x] int32_t getCursor() const;
* [ ] StereoPannerNode
* [ ] WaveShaperNode
* [ ] WaveTable -->
