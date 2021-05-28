#include "LabSound/LabSound.h"
#include <thread>

#include "dart_api/dart_api.h"
#include "dart_api/dart_native_api.h"
#include "dart_api/dart_api_dl.h"

#if defined(__ANDROID__) 
#include <android/log.h>
#define LOG(fmt, args...) __android_log_print(ANDROID_LOG_INFO, "LabSound", fmt, ##args)
#define LOG_INFO(fmt, args...) __android_log_print(ANDROID_LOG_INFO, "LabSound", fmt, ##args)
#define LOG_ERROR(fmt, args...) __android_log_print(ANDROID_LOG_ERROR, "LabSound", fmt, ##args)
#endif

using namespace lab;
#include "test.cpp"
#include "KeepNode.cpp"
#include "AudioBus.cpp"
#include "AudioContext.cpp"
#include "AudioNode.cpp"
#include "AudioScheduledSourceNode.cpp"
#include "AudioParam.cpp"
#include "GainNode.cpp"
#include "RecorderNode.cpp"
#include "SampledAudioNode.cpp"
#include "AnalyserNode.cpp"
#include "OscillatorNode.cpp"
#include "BiquadFilterNode.cpp"
#include "PannerNode.cpp"

#include "ChannelMergerNode.cpp"
#include "ChannelSplitterNode.cpp"

#include "AudioHardwareDeviceNode.cpp"


// DART_EXPORT void labTest() {
//     LOG_INFO("test");
//     const std::vector<AudioDeviceInfo> audioDevices = lab::MakeAudioDeviceList();
//     for (std::vector<AudioDeviceInfo>::size_type ind = 0;ind != audioDevices.size(); ++ind) {
//         LOG_INFO("dev: %d, %s", audioDevices[ind].index, audioDevices[ind].identifier.c_str());
//     }
// }