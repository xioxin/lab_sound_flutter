#define DART_CALL __attribute__((visibility("default"))) __attribute__((used))
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
using namespace lab;

extern "C" DART_CALL
int createRecorderNode(AudioContext* context, int channels, float sampleRate) {
    AudioStreamConfig offlineConfig = AudioStreamConfig();
    offlineConfig.desired_channels = channels;
    offlineConfig.desired_samplerate = sampleRate;
    offlineConfig.device_index = 0;
    auto recorder = std::make_shared<RecorderNode>(*context, offlineConfig);
    context->addAutomaticPullNode(recorder);
    return keepNode(recorder);
}
