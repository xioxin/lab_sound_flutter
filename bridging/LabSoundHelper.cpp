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
#include "DynamicsCompressorNode.cpp"

DART_EXPORT void labTest() {

    LOG_INFO("test");
    
    {
        auto context = MakeRealtimeAudioContext(AudioStreamConfig(), AudioStreamConfig());
    }

    {
        auto context2 = MakeRealtimeAudioContext(AudioStreamConfig(), AudioStreamConfig()).release();
    }
}