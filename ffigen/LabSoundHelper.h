#include "struct.h"

/// PORT

intptr_t InitDartApiDL(void* data);

void registerDecodeAudioSendPort(int sendPort);

void registerAudioSampleOnEndedSendPort(int sendPort);

/// AudioContext

AudioContext* createRealtimeAudioContext(int channels,float sampleRate);

AudioContext* createOfflineAudioContext(int channels,float sampleRate,float timeMills);

void AudioContext_startOfflineRendering(AudioContext* context,int recorderIndex, const char* file_path);

// suspend the progression of time in the audio context, any queued samples will play
void AudioContext_suspend(AudioContext* context);

// if the context was suspended, resume the progression of time and processing in the audio context
void AudioContext_resume(AudioContext* context);

double AudioContext_currentTime(AudioContext* context);

double AudioContext_predictedCurrentTime(AudioContext* context);

float AudioContext_sampleRate(AudioContext* context);

int AudioContext_isInitialized(AudioContext* context);

int AudioContext_isConnected(AudioContext* context, int destinationIndex, int sourceIndex);

void AudioContext_setDeviceNode(AudioContext* context, int nodeId);

int AudioContext_device(AudioContext* context);

int AudioContext_isOfflineContext(AudioContext* context);

uint64_t AudioContext_currentSampleFrame(AudioContext* context);

void AudioContext_connect(AudioContext* context, int destination, int source, int destIdx = 0, int srcIdx = 0);

void AudioContext_disconnect(AudioContext* context, int destination, int source, int destIdx = 0, int srcIdx = 0);

// completely disconnect the node from the graph
void AudioContext_disconnect2(AudioContext* context, int node, int destIdx = 0)

void AudioContext_releaseContext(AudioContext* ctx);

/// AudioParam

float AudioParam_value(int nodeId, int paramIndex);

void AudioParam_setValue(int nodeId, int paramIndex, float value);

float AudioParam_finalValue(int nodeId, int paramIndex, AudioContext* context);

void AudioParam_setValueCurveAtTime(int nodeId, int paramIndex, float curve[],float time,float duration);

void AudioParam_cancelScheduledValues(int nodeId, int paramIndex, float startTime);

void AudioParam_setValueAtTime(int nodeId, int paramIndex,float value,float time);

void AudioParam_exponentialRampToValueAtTime(int nodeId, int paramIndex,float value,float time);

void AudioParam_linearRampToValueAtTime(int nodeId, int paramIndex, float value,float time);

void AudioParam_setTargetAtTime(int nodeId, int paramIndex, float target, float time, float timeConstant);

float AudioParam_minValue(int nodeId, int paramIndex);
float AudioParam_maxValue(int nodeId, int paramIndex);
float AudioParam_defaultValue(int nodeId, int paramIndex);

void AudioParam_resetSmoothedValue(int nodeId, int paramIndex);

void AudioParam_setSmoothingConstant(int nodeId, int paramIndex, double k);

int AudioParam_hasSampleAccurateValues(int nodeId, int paramIndex);


/// AudioNode

void AudioNode_initialize(int nodeId);

void AudioNode_uninitialize(int nodeId);

int AudioNode_isScheduledNode(int nodeId);

int AudioNode_numberOfInputs(int nodeId);

int AudioNode_numberOfOutputs(int nodeId);

int AudioNode_channelCount(int nodeId);

void AudioNode_reset(int nodeId, AudioContext* context);

char * AudioNode_name(int nodeId);

void releaseNode(int nodeId);

int hasNode(int nodeId);

/// AudioScheduledSourceNode

int AudioScheduledSourceNode_isPlayingOrScheduled(int nodeId);

void AudioScheduledSourceNode_stop(int nodeId, float when);

int AudioScheduledSourceNode_hasFinished(int nodeId);

uint64_t AudioScheduledSourceNode_startWhen(int nodeId);

void AudioScheduledSourceNode_start(int nodeId, float when);

int AudioScheduledSourceNode_playbackState(int nodeId);

/// SampledAudioNode

int createAudioSampleNode(AudioContext* context);

void SampledAudioNode_setBus(int nodeId, AudioContext* context, int busIndex);

void SampledAudioNode_schedule(int nodeId, double when);

void SampledAudioNode_schedule2(int nodeId, double when, int loopCount);

void SampledAudioNode_schedule3(int nodeId, double when, double grainOffset, int loopCount);

void SampledAudioNode_schedule4(int nodeId, double when, double grainOffset, double grainDuration, int loopCount);

void SampledAudioNode_clearSchedules(int nodeId);

void SampledAudioNode_start(int nodeId, double when);

void SampledAudioNode_start2(int nodeId, double when, int loopCount);

void SampledAudioNode_start3(int nodeId, double when, double grainOffset, int loopCount);

void SampledAudioNode_start4(int nodeId, double when, double grainOffset, double grainDuration, int loopCount);

int SampledAudioNode_getCursor(int index);

int SampledAudioNode_playbackRate(int index);

int SampledAudioNode_detune(int index);

/// AudioBus

int decodeAudioData(const char *file);

int decodeAudioDataAsync(const char *file);

int decodeAudioDataHasCheck(int busIndex);

int AudioBus_numberOfChannels(int busIndex);

int AudioBus_length(int busIndex);

float AudioBus_sampleRate(int busIndex);

void AudioBus_zero(int busIndex);

void AudioBus_clearSilentFlag(int busIndex);

void AudioBus_scale(int busIndex, float scale);

void AudioBus_reset(int busIndex);

int AudioBus_isSilent(int busIndex);

int AudioBus_isFirstTime(int busIndex);

void AudioBus_setSampleRate(int busIndex, float sampleRate);

void releaseAudioBus(int index);

/// GainNode

int createGain(AudioContext* context);

int GainNode_gain(int nodeId);

/// RecorderNode

int createRecorderNode(AudioContext* context, int channels, float sampleRate);


/// AnalyserNode


int createAnalyserNode(AudioContext* context);

int createAnalyserNodeFftSize(AudioContext* context, int fftSize);

void AnalyserNode_setFftSize(int nodeId, AudioContext* context, int fftSize);

int AnalyserNode_fftSize(int nodeId);

int AnalyserNode_frequencyBinCount(int nodeId);

void AnalyserNode_setMinDecibels(int nodeId, double k);

int AnalyserNode_minDecibels(int nodeId);

void AnalyserNode_setMaxDecibels(int nodeId, double k);

int AnalyserNode_maxDecibels(int nodeId);

void AnalyserNode_setSmoothingTimeConstant(int nodeId, double k);

int AnalyserNode_smoothingTimeConstant(int nodeId);

void AnalyserNode_getFloatFrequencyData(int nodeId, float* array);

void AnalyserNode_getByteFrequencyData(int nodeId, uint8_t* array, bool resample);

void AnalyserNode_getFloatTimeDomainData(int nodeId, float* array);

void AnalyserNode_getByteTimeDomainData(int nodeId, uint8_t* array);


/// OscillatorNode
int createOscillatorNode(AudioContext* context);
int OscillatorNode_type(int nodeId);
void OscillatorNode_setType(int nodeId, int type);
int OscillatorNode_amplitude(int nodeId);
int OscillatorNode_frequency(int nodeId);
int OscillatorNode_detune(int nodeId);
int OscillatorNode_bias(int nodeId);

/// BiquadFilterNode
int createBiquadFilterNode(AudioContext* context);
int BiquadFilterNode_type(int nodeId);
void BiquadFilterNode_setType(int nodeId, int type);
int BiquadFilterNode_frequency(int nodeId);
int BiquadFilterNode_q(int nodeId);
int BiquadFilterNode_gain(int nodeId);
int BiquadFilterNode_detune(int nodeId);


/// PannerNode

int createPannerNode(AudioContext* context);

int PannerNode_panningModel(int nodeId);
void PannerNode_setPanningModel(int nodeId, int m);
int PannerNode_distanceModel(int nodeId);
void PannerNode_setDistanceModel(int nodeId, int m);

void PannerNode_setPosition(int nodeId, float x, float y, float z);
void PannerNode_setOrientation(int nodeId, float x, float y, float z);
void PannerNode_setVelocity(int nodeId, float x, float y, float z);

int PannerNode_positionX(int nodeId);
int PannerNode_positionY(int nodeId);
int PannerNode_positionZ(int nodeId);

int PannerNode_orientationX(int nodeId);
int PannerNode_orientationY(int nodeId);
int PannerNode_orientationZ(int nodeId);

int PannerNode_velocityX(int nodeId);
int PannerNode_velocityY(int nodeId);
int PannerNode_velocityZ(int nodeId);

int PannerNode_distanceGain(int nodeId);
int PannerNode_coneGain(int nodeId);

float PannerNode_refDistance(int nodeId);
void PannerNode_setRefDistance(int nodeId, float refDistance);

float PannerNode_maxDistance(int nodeId);
void PannerNode_setMaxDistance(int nodeId, float maxDistance);

float PannerNode_rolloffFactor(int nodeId);
void PannerNode_setRolloffFactor(int nodeId, float rolloffFactor);

float PannerNode_coneInnerAngle(int nodeId);
void PannerNode_setConeInnerAngle(int nodeId, float angle);

float PannerNode_coneOuterAngle(int nodeId);
void PannerNode_setConeOuterAngle(int nodeId, float angle);

float PannerNode_coneOuterGain(int nodeId);
void PannerNode_setConeOuterGain(int nodeId, float angle);

void PannerNode_getAzimuthElevation(int nodeId, AudioContext* context, double * outAzimuth, double * outElevation);
void PannerNode_dopplerRate(int nodeId, AudioContext* context);

/// ChannelSplitterNode

int createChannelSplitterNode(AudioContext* context);
void ChannelSplitterNode_addOutputs(int nodeId, int n);

///ChannelMergerNode

int createChannelMergerNode(AudioContext* context);
void ChannelMergerNode_addInputs(int nodeId, int n);
void ChannelMergerNode_setOutputChannelCount(int nodeId, int n);


///AudioHardwareDeviceNode

// Input and Output
struct AudioStreamConfig
{
    int32_t device_index{-1};
    uint32_t desired_channels{0};
    float desired_samplerate{0};
};

int createAudioHardwareDeviceNode(AudioContext* context, const AudioStreamConfig outputConfig, const AudioStreamConfig inputConfig);

void AudioHardwareDeviceNode_start(int nodeId);

void AudioHardwareDeviceNode_stop(int nodeId);

int AudioHardwareDeviceNode_isRunning(int nodeId);

AudioStreamConfig AudioHardwareDeviceNode_getOutputConfig(int nodeId);

AudioStreamConfig AudioHardwareDeviceNode_getInputConfig(int nodeId);

AudioStreamConfig createAudioStreamConfig(int device_index, uint32_t desired_channels, float desired_samplerate );

void AudioHardwareDeviceNode_backendReinitialize(int nodeId);
