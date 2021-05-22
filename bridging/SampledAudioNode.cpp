#include "dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
using namespace lab;

DART_EXPORT int createAudioSampleNode(AudioContext* context) {
    auto sample = std::make_shared<SampledAudioNode>(*context);
    return keepNode(sample);
}

DART_EXPORT void SampledAudioNode_setBus(int nodeIndex, AudioContext* context, int busIndex) {
    ContextRenderLock r(context,"setBus");
    std::dynamic_pointer_cast<SampledAudioNode>(audioNodes.find(nodeIndex)->second)->setBus(r, audioBuffers.find(busIndex)->second);
}

DART_EXPORT void SampledAudioNode_schedule(int nodeIndex, double when) {
    std::dynamic_pointer_cast<SampledAudioNode>(audioNodes.find(nodeIndex)->second)->schedule(when);
}

DART_EXPORT void SampledAudioNode_schedule2(int nodeIndex, double when, double grainOffset) {
    std::static_pointer_cast<SampledAudioNode>(audioNodes.find(nodeIndex)->second)->schedule(when, grainOffset);
}

DART_EXPORT void SampledAudioNode_schedule3(int nodeIndex, double when, double grainOffset, double grainDuration) {
    std::static_pointer_cast<SampledAudioNode>(audioNodes.find(nodeIndex)->second)->schedule(when, grainOffset, grainDuration);
}

DART_EXPORT void SampledAudioNode_schedule4(int nodeIndex, double when, double grainOffset, double grainDuration, int loopCount) {
    std::static_pointer_cast<SampledAudioNode>(audioNodes.find(nodeIndex)->second)->schedule(when, grainOffset, grainDuration, loopCount);
}

DART_EXPORT void SampledAudioNode_clearSchedules(int nodeIndex) {
    std::static_pointer_cast<SampledAudioNode>(audioNodes.find(nodeIndex)->second)->clearSchedules();
}

DART_EXPORT int SampledAudioNode_getCursor(int nodeId) {
    return std::static_pointer_cast<SampledAudioNode>(audioNodes.find(nodeId)->second)->getCursor();
}

DART_EXPORT int SampledAudioNode_playbackRate(int nodeId) {
    return keepAudioParam(nodeId, 0 , std::static_pointer_cast<SampledAudioNode>(audioNodes.find(nodeId)->second)->playbackRate());
}

DART_EXPORT int SampledAudioNode_detune(int nodeId) {
    return keepAudioParam(nodeId, 1 , std::static_pointer_cast<SampledAudioNode>(audioNodes.find(nodeId)->second)->detune());
}


