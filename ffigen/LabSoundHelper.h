#include "../bridge/struct.h"
#include "stdint.h"
#include "string.h"
#include <stdbool.h>

#define AudioContext void

typedef struct AudioStreamConfig {
    int32_t device_index;
    uint32_t desired_channels;
    float desired_samplerate;
} AudioStreamConfig;


typedef struct AudioDeviceIndex
{
    uint32_t index;
    int valid;
} AudioDeviceIndex;

AudioDeviceInfoList labSound_MakeAudioDeviceList();

AudioDeviceIndex labSound_GetDefaultOutputAudioDeviceIndex();
AudioDeviceIndex labSound_GetDefaultInputAudioDeviceIndex();

int labSound_MakeAudioHardwareInputNode(AudioContext* context);


////////////
/// PORT ///
////////////

intptr_t InitDartApiDL(void* data);

void registerDecodeAudioSendPort(int sendPort);

void registerAudioSampleOnEndedSendPort(int sendPort);

void registerOfflineRenderCompleteSendPort(int sendPort);

////////////////////
/// AudioContext ///
////////////////////

AudioContext* createRealtimeAudioContext(AudioStreamConfig outputConfig, AudioStreamConfig inputConfig);

AudioContext* createOfflineAudioContext(AudioStreamConfig outputConfig, double recordTimeMilliseconds);

int AudioContext_startOfflineRendering(AudioContext* context);

int AudioContext_makeAudioHardwareInputNode(AudioContext* context);


// AudioContext can pull node(s) at the end of each render quantum even
// when they are not connected to any downstream nodes. These two methods
// are called by the nodes who want to add/remove themselves into/from the
// automatic pull lists.
void AudioContext_addAutomaticPullNode(AudioContext* context, int nodeId);

void AudioContext_removeAutomaticPullNode(AudioContext* context, int nodeId);


// Called right before handlePostRenderTasks() to handle nodes which need to
// be pulled even when they are not connected to anything.
// Only an AudioHardwareDeviceNode should call this.
void AudioContext_processAutomaticPullNodes(AudioContext* context, int framesToProcess);

// Called at the start of each render quantum.
void AudioContext_handlePreRenderTasks(AudioContext* context);

// Called at the end of each render quantum.
void AudioContext_handlePostRenderTasks(AudioContext* context);

// connecting and disconnecting busses and parameters occurs asynchronously.
// synchronizeConnections will block until there are no pending connections,
// or until the timeout occurs.
void AudioContext_synchronizeConnections(AudioContext* context, int timeOut_ms);

// suspend the progression of time in the audio context, any queued samples will play
void AudioContext_suspend(AudioContext* context);

// if the context was suspended, resume the progression of time and processing in the audio context
void AudioContext_resume(AudioContext* context);

// The current time, measured at the start of the render quantum currently
// being processed. Most useful in a Node's process routine.
double AudioContext_currentTime(AudioContext* context);


// The current time, accurate versus the audio clock. Whereas currentTime
// advances discretely, once per render quanta, predictedCurrentTime
// is the sum of currentTime, and the amount of realworld time that has
// elapsed since the start of the current render quanta. This is useful on
// the main thread of an application in order to precisely synchronize
// expected audio events and other systems.
double AudioContext_predictedCurrentTime(AudioContext* context);

float AudioContext_sampleRate(AudioContext* context);

int AudioContext_isInitialized(AudioContext* context);

int AudioContext_isConnected(AudioContext* context, int destinationIndex, int sourceIndex);

void AudioContext_setDeviceNode(AudioContext* context, int nodeId);

int AudioContext_device(AudioContext* context);

int AudioContext_isOfflineContext(AudioContext* context);

uint64_t AudioContext_currentSampleFrame(AudioContext* context);

void AudioContext_connect(AudioContext* context, int destination, int source, int destIdx, int srcIdx);

// completely disconnect the node from the graph
void AudioContext_disconnect(AudioContext* context, int destination, int source, int destIdx, int srcIdx);

// completely disconnect the node from the graph
void AudioContext_disconnectCompletely(AudioContext* context, int node, int destIdx);

// connect a parameter to receive the indexed output of a node
void AudioContext_connectParam(AudioContext* context, int paramNodeId, int paramId, int driverNodeId, int index);

// connect destinationNode's named parameter input to driver's indexed output
void AudioContext_connectParamByName(AudioContext* context, int destinationNodeId, char const*const parameterName, int driverNodeId, int index);

// disconnect a parameter from the indexed output of a node
void AudioContext_disconnectParam(AudioContext* context, int paramNodeId, int paramId, int driverNodeId, int index);


void AudioContext_releaseContext(AudioContext* ctx);

//////////////////
/// AudioParam ///
//////////////////

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


/////////////////
/// AudioNode ///
/////////////////

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

////////////////////////
/// SampledAudioNode ///
////////////////////////

int createAudioSampleNode(AudioContext* context);

// setting the bus is an asynchronous operation. getBus returns the most
// recent set request in order that the interface work in a predictable way.
// In the future, setBus and getBus could be deprecated in favor of another
// schedule method that takes a source bus as an argument.
void SampledAudioNode_setBus(int nodeId, AudioContext* context, int busIndex);

// loopCount of -1 will loop forever
// all the schedule routines will call start(0) if necessary, so that a
// schedule is sufficient for this node to start producing a signal.
void SampledAudioNode_schedule(int nodeId, double when);

void SampledAudioNode_schedule2(int nodeId, double when, int loopCount);

void SampledAudioNode_schedule3(int nodeId, double when, double grainOffset, int loopCount);

void SampledAudioNode_schedule4(int nodeId, double when, double grainOffset, double grainDuration, int loopCount);


// this will clear anything playing or pending, without stopping the node itself.
void SampledAudioNode_clearSchedules(int nodeId);


// note: start is not virtual. start on the ScheduledAudioNode is relative,
// but start here is in absolute time.
void SampledAudioNode_start(int nodeId, double when);

void SampledAudioNode_start2(int nodeId, double when, int loopCount);

void SampledAudioNode_start3(int nodeId, double when, double grainOffset, int loopCount);

void SampledAudioNode_start4(int nodeId, double when, double grainOffset, double grainDuration, int loopCount);

// returns the greatest sample index played back by any of the scheduled
// instances in the most recent render quantum. A value less than zero
// indicates nothing's playing.
int SampledAudioNode_getCursor(int index);

int SampledAudioNode_playbackRate(int index);

int SampledAudioNode_detune(int index);

////////////////
/// AudioBus ///
////////////////

int makeBusFromFile(const char *file, int mixToMono, float targetSampleRate);

int makeBusFromMemory(const uint8_t* buffer, const int bufferLen, const char *extension, int mixToMono);

int audioBusHasCheck(int busId);

// Channels
int AudioBus_numberOfChannels(int busIndex);

// Number of sample-frames
int AudioBus_length(int busIndex);

// Sample-rate : 0.0 if unknown or "don't care"
float AudioBus_sampleRate(int busIndex);

void AudioBus_setSampleRate(int busIndex, float sampleRate);

// Zeroes all channels.
void AudioBus_zero(int busIndex);

// Clears the silent flag on all channels.
void AudioBus_clearSilentFlag(int busIndex);

// Scales all samples by the same amount.
void AudioBus_scale(int busIndex, float scale);

// for de-zippering
void AudioBus_reset(int busIndex);

// Returns true if the silent bit is set on all channels.
int AudioBus_isSilent(int busIndex);

int AudioBus_isFirstTime(int busIndex);

void releaseAudioBus(int index);

////////////////
/// GainNode ///
////////////////

int createGain(AudioContext* context);

int GainNode_gain(int nodeId);

////////////////////
/// RecorderNode ///
////////////////////

// create a recorder with a specific configuration
int createRecorderNode(AudioContext* context, int channelCount);

int createRecorderNodeByConfig(AudioContext* context, AudioStreamConfig outputConfig );

void RecorderNode_startRecording(int nodeId);

void RecorderNode_stopRecording(int nodeId);

float RecorderNode_recordedLengthInSeconds(int nodeId);

// create a bus from the recording; it can be used by other nodes
// such as a SampledAudioNode.
int RecorderNode_createBusFromRecording(int nodeId, int mixToMono);

// returns true for success
int RecorderNode_writeRecordingToWav(int nodeId, char *file, int mixToMono);

////////////////////
/// AnalyserNode ///
////////////////////

int createAnalyserNode(AudioContext* context);

int createAnalyserNodeFftSize(AudioContext* context, int fftSize);

void AnalyserNode_setFftSize(int nodeId, AudioContext* context, int fftSize);

int AnalyserNode_fftSize(int nodeId);

// a value large enough to hold all the data return from get*FrequencyData
int AnalyserNode_frequencyBinCount(int nodeId);

void AnalyserNode_setMinDecibels(int nodeId, double k);

int AnalyserNode_minDecibels(int nodeId);

void AnalyserNode_setMaxDecibels(int nodeId, double k);

int AnalyserNode_maxDecibels(int nodeId);

void AnalyserNode_setSmoothingTimeConstant(int nodeId, double k);

int AnalyserNode_smoothingTimeConstant(int nodeId);

// frequency bins, reported in db
void AnalyserNode_getFloatFrequencyData(int nodeId, float* array);

// frequency bins, reported as a linear mapping of minDecibels to maxDecibles onto 0-255.
// if resample is true, then the computed values will be linearly resampled
void AnalyserNode_getByteFrequencyData(int nodeId, uint8_t* array, int resample);

void AnalyserNode_getFloatTimeDomainData(int nodeId, float* array);

void AnalyserNode_getByteTimeDomainData(int nodeId, uint8_t* array);


//////////////////////
/// OscillatorNode ///
//////////////////////

int createOscillatorNode(AudioContext* context);
int OscillatorNode_type(int nodeId);
void OscillatorNode_setType(int nodeId, int type);

// default 1.0
int OscillatorNode_amplitude(int nodeId);

// hz
int OscillatorNode_frequency(int nodeId);

// default 0.0
int OscillatorNode_bias(int nodeId);

// Detune value in Cents.
int OscillatorNode_detune(int nodeId);

/// BiquadFilterNode
int createBiquadFilterNode(AudioContext* context);
int BiquadFilterNode_type(int nodeId);
void BiquadFilterNode_setType(int nodeId, int type);
int BiquadFilterNode_frequency(int nodeId);
int BiquadFilterNode_q(int nodeId);
int BiquadFilterNode_gain(int nodeId);
int BiquadFilterNode_detune(int nodeId);


//////////////////
/// PannerNode ///
//////////////////

int createPannerNode(AudioContext* context);

int PannerNode_panningModel(int nodeId);
void PannerNode_setPanningModel(int nodeId, int m);
int PannerNode_distanceModel(int nodeId);
void PannerNode_setDistanceModel(int nodeId, int m);

void PannerNode_setPosition(int nodeId, float x, float y, float z);
int PannerNode_positionX(int nodeId);
int PannerNode_positionY(int nodeId);
int PannerNode_positionZ(int nodeId);

// The orientation property indicates the X component of the direction in
// which the audio source is facing, in cartesian space. The complete
// vector is defined by the position of the audio source, and the direction
// in which it is facing.
void PannerNode_setOrientation(int nodeId, float x, float y, float z);
int PannerNode_orientationX(int nodeId);
int PannerNode_orientationY(int nodeId);
int PannerNode_orientationZ(int nodeId);

void PannerNode_setVelocity(int nodeId, float x, float y, float z);
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

///////////////////////////
/// ChannelSplitterNode ///
///////////////////////////
int createChannelSplitterNode(AudioContext* context);
void ChannelSplitterNode_addOutputs(int nodeId, int n);

/////////////////////////
/// ChannelMergerNode ///
/////////////////////////

int createChannelMergerNode(AudioContext* context);
void ChannelMergerNode_addInputs(int nodeId, int n);
void ChannelMergerNode_setOutputChannelCount(int nodeId, int n);

///////////////////////////////
/// AudioHardwareDeviceNode ///
///////////////////////////////

int createAudioHardwareDeviceNode(AudioContext* context, const AudioStreamConfig outputConfig, const AudioStreamConfig inputConfig);

void AudioHardwareDeviceNode_start(int nodeId);

void AudioHardwareDeviceNode_stop(int nodeId);

int AudioHardwareDeviceNode_isRunning(int nodeId);

AudioStreamConfig AudioHardwareDeviceNode_getOutputConfig(int nodeId);

AudioStreamConfig AudioHardwareDeviceNode_getInputConfig(int nodeId);

AudioStreamConfig createAudioStreamConfig(int device_index, uint32_t desired_channels, float desired_samplerate );

void AudioHardwareDeviceNode_backendReinitialize(int nodeId);


//////////////////////////////
/// DynamicsCompressorNode ///
//////////////////////////////

int createDynamicsCompressorNode(AudioContext* context);

// Static compression curve parameters.
int DynamicsCompressorNode_threshold(int nodeId);
int DynamicsCompressorNode_knee(int nodeId);
int DynamicsCompressorNode_ratio(int nodeId);
int DynamicsCompressorNode_attack(int nodeId);
int DynamicsCompressorNode_release(int nodeId);

// Amount by which the compressor is currently compressing the signal in decibels.
int DynamicsCompressorNode_reduction(int nodeId);



////////////////
/// ADSRNode ///
////////////////


int createADSRNode(AudioContext* context);


int ADSRNode_finished(int nodeId, AudioContext* context);

void ADSRNode_set(int nodeId, float attack_time, float attack_level, float decay_time, float sustain_time, float sustain_level, float release_time);

// gate signal
int ADSRNode_gate(int nodeId);

// If zero, gate controls attack and sustain, else sustainTime controls sustain
int ADSRNode_oneShot(int nodeId);

// Duration in seconds
int ADSRNode_attackTime(int nodeId);

// Level
int ADSRNode_attackLevel(int nodeId);

// Duration in seconds
int ADSRNode_decayTime(int nodeId);

// Duration in seconds
int ADSRNode_sustainTime(int nodeId);

// Level
int ADSRNode_sustainLevel(int nodeId);

// Duration in seconds
int ADSRNode_releaseTime(int nodeId);


//////////////////////
/// WaveShaperNode ///
//////////////////////

int createWaveShaperNode(AudioContext* context);

void WaveShaperNode_setCurve(const int nodeId,  const int curveLen,  const float* curve);



/////////////////
/// NoiseNode ///
/////////////////

int createNoiseNode(AudioContext* context);

int NoiseNode_type(int nodeId);

void NoiseNode_setType(int nodeId, int type);


////////////////////
/// PolyBLEPNode ///
////////////////////
int createPolyBLEPNode(AudioContext* context);

int PolyBLEPNode_type(int nodeId);

void PolyBLEPNode_setType(int nodeId, int type);

int PolyBLEPNode_amplitude(int nodeId);

int PolyBLEPNode_frequency(int nodeId);


/////////////////
/// DelayNode ///
/////////////////

int createDelayNode(AudioContext* context);

int DelayNode_delayTime(int nodeId);


////////////////////
/// BPMDelayNode ///
////////////////////


int createBPMDelayNode(AudioContext* context, float tempo);

int BPMDelayNode_setTempo(int nodeId, float newTempo);

int BPMDelayNode_setDelayIndex(int nodeId, int value);


/////////////////////
/// ConvolverNode ///
/////////////////////

int createConvolverNode(AudioContext* context);

int ConvolverNode_normalize(int nodeId);

void ConvolverNode_setNormalize(int nodeId, int newN);

void ConvolverNode_setImpulse(int nodeId, int busId);


////////////////////////
/// StereoPannerNode ///
////////////////////////
int createStereoPannerNode(AudioContext* context);
int StereoPannerNode_pan(int nodeId);



////////////////////////
/// PowerMonitorNode ///
////////////////////////

int createPowerMonitorNode(AudioContext* context);
int PowerMonitorNode_windowSize(int nodeId);
float PowerMonitorNode_db(int nodeId);
void PowerMonitorNode_setWindowSize(int nodeId, int ws);


////////////////
/// SfxrNode ///
////////////////


int createSfxrNode(AudioContext* context);

int SfxrNode_attackTime(int nodeId);
int SfxrNode_sustainTime(int nodeId);
int SfxrNode_sustainPunch(int nodeId);
int SfxrNode_decayTime(int nodeId);
int SfxrNode_startFrequency(int nodeId);
int SfxrNode_minFrequency(int nodeId);
int SfxrNode_slide(int nodeId);
int SfxrNode_deltaSlide(int nodeId);
int SfxrNode_vibratoDepth(int nodeId);
int SfxrNode_vibratoSpeed(int nodeId);

int SfxrNode_changeAmount(int nodeId);
int SfxrNode_changeSpeed(int nodeId);

int SfxrNode_squareDuty(int nodeId);
int SfxrNode_dutySweep(int nodeId);

int SfxrNode_repeatSpeed(int nodeId);
int SfxrNode_phaserOffset(int nodeId);
int SfxrNode_phaserSweep(int nodeId);


int SfxrNode_lpFilterCutoff(int nodeId);
int SfxrNode_lpFilterCutoffSweep(int nodeId);
int SfxrNode_lpFiterResonance(int nodeId);
int SfxrNode_hpFilterCutoff(int nodeId);
int SfxrNode_hpFilterCutoffSweep(int nodeId);


void SfxrNode_setStartFrequencyInHz(int nodeId, float value);
void SfxrNode_setVibratoSpeedInHz(int nodeId, float value);
float SfxrNode_envelopeTimeInSeconds(int nodeId, float sfxrEnvTime);
float SfxrNode_envelopeTimeInSfxrUnits(int nodeId, float t);
float SfxrNode_frequencyInSfxrUnits(int nodeId, float hz);
float SfxrNode_frequencyInHz(int nodeId, float sfxr);
float SfxrNode_vibratoInSfxrUnits(int nodeId, float hz);
float SfxrNode_vibratoInHz(int nodeId, float sfxr);
float SfxrNode_filterFreqInHz(int nodeId, float sfxr);

float SfxrNode_filterFreqInSfxrUnits(int nodeId, float hz);

void SfxrNode_setDefaultBeep(int nodeId);
void SfxrNode_coin(int nodeId);
void SfxrNode_laser(int nodeId);
void SfxrNode_explosion(int nodeId);
void SfxrNode_powerUp(int nodeId);
void SfxrNode_hit(int nodeId);
void SfxrNode_jump(int nodeId);
void SfxrNode_select(int nodeId);

void SfxrNode_mutate(int nodeId);
void SfxrNode_randomize(int nodeId);


////////////////////
/// AudioSetting ///
////////////////////

const char* AudioSetting_name(int nodeId, int settingIndex);
const char* AudioSetting_shortName(int nodeId, int settingIndex);
int AudioSetting_type(int nodeId, int settingIndex);
int AudioSetting_valueBool(int nodeId, int settingIndex);
float AudioSetting_valueFloat(int nodeId, int settingIndex);
uint32_t AudioSetting_valueUint32(int nodeId, int settingIndex);
int AudioSetting_valueBus(int nodeId, int settingIndex);
void AudioSetting_setBool(int nodeId, int settingIndex, int v, int notify);
void AudioSetting_setFloat(int nodeId, int settingIndex, float v, int notify);
void AudioSetting_setUint32(int nodeId, int settingIndex, uint32_t v, int notify);
void AudioSetting_setEnumeration(int nodeId, int settingIndex, int v, int notify);
void AudioSetting_setString(int nodeId, int settingIndex, char const*const v, int notify);
