#define DART_CALL __attribute__((visibility("default"))) __attribute__((used))

#include "LabSound/LabSound.h"
#include <thread>

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

extern "C" DART_CALL
void labTest() {
    LOG_INFO("test");
    const std::vector<AudioDeviceInfo> audioDevices = lab::MakeAudioDeviceList();
    for (std::vector<AudioDeviceInfo>::size_type ind = 0;ind != audioDevices.size(); ++ind) {
        LOG_INFO("dev: %d, %s", audioDevices[ind].index, audioDevices[ind].identifier.c_str());
    }
}