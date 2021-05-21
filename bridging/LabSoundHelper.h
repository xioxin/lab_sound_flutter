#include "struct.h"

/// PORT

intptr_t InitDartApiDL(void* data);

void registerDecodeAudioSendPort(int sendPort);


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

int AudioContext_isOfflineContext(AudioContext* context);

uint64_t AudioContext_currentSampleFrame(AudioContext* context);

void AudioContext_connect(AudioContext* context, int destination, int source);

void AudioContext_disconnect(AudioContext* context, int destination, int source);

void AudioContext_resetDevice(AudioContext* context);

void AudioContext_releaseContext(AudioContext* ctx);

/// AudioParam

float AudioParam_value(int nodeId, int paramIndex);

void AudioParam_setValue(int nodeId, int paramIndex, float value);

void AudioParam_setValueCurveAtTime(int nodeId, int paramIndex, float curve[],float time,float duration);

void AudioParam_cancelScheduledValues(int nodeId, int paramIndex, float startTime);

void AudioParam_setValueAtTime(int nodeId, int paramIndex,float value,float time);

void AudioParam_exponentialRampToValueAtTime(int nodeId, int paramIndex,float value,float time);

void AudioParam_linearRampToValueAtTime(int nodeId, int paramIndex, float value,float time);

void AudioParam_setTargetAtTime(int nodeId, int paramIndex, float target, float time, float timeConstant);

float AudioParam_minValue(int nodeId, int paramIndex);

void AudioParam_resetSmoothedValue(int nodeId, int paramIndex);

void AudioParam_setSmoothingConstant(int nodeId, int paramIndex, double k);

int AudioParam_hasSampleAccurateValues(int nodeId, int paramIndex);


/// AudioNode

int AudioNode_isScheduledNode(int nodeId);

int AudioNode_numberOfInputs(int nodeId);

int AudioNode_numberOfOutputs(int nodeId);

int AudioNode_channelCount(int nodeId);

void AudioNode_reset(int nodeId, AudioContext* context);

void releaseNode(int nodeId);

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

void SampledAudioNode_schedule2(int nodeId, double when, double grainOffset);

void SampledAudioNode_schedule3(int nodeId, double when, double grainOffset, double grainDuration);

void SampledAudioNode_schedule4(int nodeId, double when, double grainOffset, double grainDuration, int loopCount);

void SampledAudioNode_clearSchedules(int nodeId);

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

AnalyserNode_getFloatFrequencyData(int nodeIndex, float* array);
