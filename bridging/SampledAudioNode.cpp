#include "dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
#include "Port.cpp"
using namespace lab;

DART_EXPORT int createAudioSampleNode(AudioContext* context) {
    auto node = std::make_shared<SampledAudioNode>(*context);
    auto nodeId = keepNode(node);
    node->setOnEnded([nodeId]() {
        sendAudioSampleOnEnded(nodeId);
    });
    return nodeId;
}

DART_EXPORT void SampledAudioNode_setBus(int nodeId, AudioContext* context, int busId) {
    ContextRenderLock r(context,"setBus");
    auto node = std::static_pointer_cast<SampledAudioNode>(getNode(nodeId));
    auto bus = getBus(busId);
    if(node && bus) node->setBus(r, bus);
}

DART_EXPORT void SampledAudioNode_schedule(int nodeId, double when) {
    auto node = std::static_pointer_cast<SampledAudioNode>(getNode(nodeId));
    if(node) node->schedule(when);
}

DART_EXPORT void SampledAudioNode_schedule2(int nodeId, double when, int loopCount) {
    auto node = std::static_pointer_cast<SampledAudioNode>(getNode(nodeId));
    if(node) node->schedule(when, loopCount);
}

DART_EXPORT void SampledAudioNode_schedule3(int nodeId, double when, double grainOffset, int loopCount) {
    auto node = std::static_pointer_cast<SampledAudioNode>(getNode(nodeId));
    if(node) node->schedule(when, grainOffset, loopCount);
}

DART_EXPORT void SampledAudioNode_schedule4(int nodeId, double when, double grainOffset, double grainDuration, int loopCount) {
    auto node = std::static_pointer_cast<SampledAudioNode>(getNode(nodeId));
    if(node) node->schedule(when, grainOffset, grainDuration, loopCount);
}

DART_EXPORT void SampledAudioNode_start(int nodeId, double when) {
    auto node = std::static_pointer_cast<SampledAudioNode>(getNode(nodeId));
    if(node) node->start(when);
}

DART_EXPORT void SampledAudioNode_start2(int nodeId, double when, int loopCount) {
    auto node = std::static_pointer_cast<SampledAudioNode>(getNode(nodeId));
    if(node) node->start(when, loopCount);
}

DART_EXPORT void SampledAudioNode_start3(int nodeId, double when, double grainOffset, int loopCount) {
    auto node = std::static_pointer_cast<SampledAudioNode>(getNode(nodeId));
    if(node) node->start(when, grainOffset, loopCount);
}

DART_EXPORT void SampledAudioNode_start4(int nodeId, double when, double grainOffset, double grainDuration, int loopCount) {
    auto node = std::static_pointer_cast<SampledAudioNode>(getNode(nodeId));
    if(node) node->start(when, grainOffset, grainDuration, loopCount);
}

DART_EXPORT void SampledAudioNode_clearSchedules(int nodeId) {
    auto node = std::static_pointer_cast<SampledAudioNode>(getNode(nodeId));
    if(node) node->clearSchedules();
}

DART_EXPORT int SampledAudioNode_getCursor(int nodeId) {
    auto node = std::static_pointer_cast<SampledAudioNode>(getNode(nodeId));
    return node ? node->getCursor() : -1;
}

DART_EXPORT int SampledAudioNode_playbackRate(int nodeId) {
    auto node = std::static_pointer_cast<SampledAudioNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 0 , node->playbackRate()) : -1;
}

DART_EXPORT int SampledAudioNode_detune(int nodeId) {
    auto node = std::static_pointer_cast<SampledAudioNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 1 , node->detune()) : -1;
}
