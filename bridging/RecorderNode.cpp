#include "dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
using namespace lab;

DART_EXPORT int createRecorderNode(AudioContext* context, int channels, float sampleRate) {
    AudioStreamConfig offlineConfig = AudioStreamConfig();
    offlineConfig.desired_channels = channels;
    offlineConfig.desired_samplerate = sampleRate;
    offlineConfig.device_index = 0;
    auto recorder = std::make_shared<RecorderNode>(*context, offlineConfig);
    context->addAutomaticPullNode(recorder);
    return keepNode(recorder);
}
