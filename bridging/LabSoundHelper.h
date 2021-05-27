#include "struct.h"

/// PORT

intptr_t InitDartApiDL(void* data);

void registerDecodeAudioSendPort(int sendPort);

void registerAudioSampleOnEndedSendPort(int sendPort);

/// AudioContext

AudioContext* createRealtimeAudioContext(int channels,float sampleRate);

AudioContext* createOfflineAudioContext(int channels,float sampleRate,float timeMills);

void AudioContext_startOfflineRendering(AudioContext* context,int recorderIndex,const char* file_path);

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

void SampledAudioNode_setBus(int nodeIndex, AudioContext* context, int busIndex);

void SampledAudioNode_schedule(int nodeId, double when);

void SampledAudioNode_schedule2(int nodeId, double when, int loopCount);

void SampledAudioNode_schedule3(int nodeId, double when, double grainOffset, int loopCount);

void SampledAudioNode_schedule4(int nodeId, double when, double grainOffset, double grainDuration, int loopCount);

void SampledAudioNode_clearSchedules(int nodeId);

void SampledAudioNode_start(int nodeIndex, double when);

void SampledAudioNode_start2(int nodeIndex, double when, int loopCount);

void SampledAudioNode_start3(int nodeIndex, double when, double grainOffset, int loopCount);

void SampledAudioNode_start4(int nodeIndex, double when, double grainOffset, double grainDuration, int loopCount);

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

void AnalyserNode_setFftSize(int nodeIndex, AudioContext* context, int fftSize);

int AnalyserNode_fftSize(int nodeIndex);

int AnalyserNode_frequencyBinCount(int nodeIndex);

void AnalyserNode_setMinDecibels(int nodeIndex, double k);

int AnalyserNode_minDecibels(int nodeIndex);

void AnalyserNode_setMaxDecibels(int nodeIndex, double k);

int AnalyserNode_maxDecibels(int nodeIndex);

void AnalyserNode_setSmoothingTimeConstant(int nodeIndex, double k);

int AnalyserNode_smoothingTimeConstant(int nodeIndex);

void AnalyserNode_getFloatFrequencyData(int nodeIndex, float* array);

void AnalyserNode_getByteFrequencyData(int nodeIndex, uint8_t* array, bool resample);

void AnalyserNode_getFloatTimeDomainData(int nodeIndex, float* array);

void AnalyserNode_getByteTimeDomainData(int nodeIndex, uint8_t* array);


/// OscillatorNode
int createOscillatorNode(AudioContext* context);
int OscillatorNode_type(int nodeIndex);
void OscillatorNode_setType(int nodeIndex, int type);
int OscillatorNode_amplitude(int nodeId);
int OscillatorNode_frequency(int nodeId);
int OscillatorNode_detune(int nodeId);
int OscillatorNode_bias(int nodeId);

/// BiquadFilterNode
int createBiquadFilterNode(AudioContext* context);
int BiquadFilterNode_type(int nodeIndex);
void BiquadFilterNode_setType(int nodeIndex, int type);
int BiquadFilterNode_frequency(int nodeId);
int BiquadFilterNode_q(int nodeId);
int BiquadFilterNode_gain(int nodeId);
int BiquadFilterNode_detune(int nodeId);


/// PannerNode

int createPannerNode(AudioContext* context);

int PannerNode_panningModel(int nodeIndex);
void PannerNode_setPanningModel(int nodeIndex, int m);
int PannerNode_distanceModel(int nodeIndex);
void PannerNode_setDistanceModel(int nodeIndex, int m);

void PannerNode_setPosition(int nodeIndex, float x, float y, float z);
void PannerNode_setOrientation(int nodeIndex, float x, float y, float z);
void PannerNode_setVelocity(int nodeIndex, float x, float y, float z);

int PannerNode_positionX(int nodeIndex);
int PannerNode_positionY(int nodeIndex);
int PannerNode_positionZ(int nodeIndex);

int PannerNode_orientationX(int nodeIndex);
int PannerNode_orientationY(int nodeIndex);
int PannerNode_orientationZ(int nodeIndex);

int PannerNode_velocityX(int nodeIndex);
int PannerNode_velocityY(int nodeIndex);
int PannerNode_velocityZ(int nodeIndex);

int PannerNode_distanceGain(int nodeIndex);
int PannerNode_coneGain(int nodeIndex);

float PannerNode_refDistance(int nodeIndex);
void PannerNode_setRefDistance(int nodeIndex, float refDistance);

float PannerNode_maxDistance(int nodeIndex);
void PannerNode_setMaxDistance(int nodeIndex, float maxDistance);

float PannerNode_rolloffFactor(int nodeIndex);
void PannerNode_setRolloffFactor(int nodeIndex, float rolloffFactor);

float PannerNode_coneInnerAngle(int nodeIndex);
void PannerNode_setConeInnerAngle(int nodeIndex, float angle);

float PannerNode_coneOuterAngle(int nodeIndex);
void PannerNode_setConeOuterAngle(int nodeIndex, float angle);

float PannerNode_coneOuterGain(int nodeIndex);
void PannerNode_setConeOuterGain(int nodeIndex, float angle);

void PannerNode_getAzimuthElevation(int nodeIndex, AudioContext* context, double * outAzimuth, double * outElevation);
void PannerNode_dopplerRate(int nodeIndex, AudioContext* context);

/// ChannelSplitterNode

int createChannelSplitterNode(AudioContext* context);
void ChannelSplitterNode_addOutputs(int nodeIndex, int n);

///ChannelMergerNode

int createChannelMergerNode(AudioContext* context);
void ChannelMergerNode_addInputs(int nodeIndex, int n);
void ChannelMergerNode_setOutputChannelCount(int nodeIndex, int n);
