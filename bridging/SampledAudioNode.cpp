#define DART_CALL __attribute__((visibility("default"))) __attribute__((used))
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
using namespace lab;

extern "C" DART_CALL
int createAudioSampleNode(AudioContext* context,int busIndex) {
    auto sample = std::make_shared<SampledAudioNode>(*context);
    ContextRenderLock r(context,"sample");
    sample->setBus(r, audioBuffers.find(busIndex)->second);
    return keepNode(sample);
}

extern "C" DART_CALL
void SampledAudioNode_schedule(int nodeIndex, double when) {
    std::dynamic_pointer_cast<SampledAudioNode>(audioNodes.find(nodeIndex)->second)->schedule(when);
}

extern "C" DART_CALL
void SampledAudioNode_schedule2(int nodeIndex, double when, double grainOffset) {
    std::static_pointer_cast<SampledAudioNode>(audioNodes.find(nodeIndex)->second)->schedule(when, grainOffset);
}

extern "C" DART_CALL
void SampledAudioNode_schedule3(int nodeIndex, double when, double grainOffset, double grainDuration) {
    std::static_pointer_cast<SampledAudioNode>(audioNodes.find(nodeIndex)->second)->schedule(when, grainOffset, grainDuration);
}

extern "C" DART_CALL
void SampledAudioNode_schedule4(int nodeIndex, double when, double grainOffset, double grainDuration, int loopCount) {
    std::static_pointer_cast<SampledAudioNode>(audioNodes.find(nodeIndex)->second)->schedule(when, grainOffset, grainDuration, loopCount);
}

extern "C" DART_CALL
void SampledAudioNode_clearSchedules(int nodeIndex) {
    std::static_pointer_cast<SampledAudioNode>(audioNodes.find(nodeIndex)->second)->clearSchedules();
}

extern "C" DART_CALL
int SampledAudioNode_getCursor(int nodeId) {
    return std::static_pointer_cast<SampledAudioNode>(audioNodes.find(nodeId)->second)->getCursor();
}

extern "C" DART_CALL
int SampledAudioNode_playbackRate(int nodeId) {
    return keepAudioParam(nodeId, 0 , std::static_pointer_cast<SampledAudioNode>(audioNodes.find(nodeId)->second)->playbackRate());
}

extern "C" DART_CALL
int SampledAudioNode_detune(int nodeId) {
    return keepAudioParam(nodeId, 1 , std::static_pointer_cast<SampledAudioNode>(audioNodes.find(nodeId)->second)->detune());
}


