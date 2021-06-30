#include "./dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
using namespace lab;

DART_EXPORT int createBPMDelayNode(AudioContext* context, float tempo) {
    auto node = std::make_shared<BPMDelay>(*context, tempo);
    return keepNode(node);
}

DART_EXPORT void BPMDelayNode_setTempo(int nodeId, float newTempo) {
    auto node = std::static_pointer_cast<BPMDelay>(getNode(nodeId));
    if(node)node->SetTempo(newTempo);
}

DART_EXPORT void BPMDelayNode_setDelayIndex(int nodeId, int value) {
    auto node = std::static_pointer_cast<BPMDelay>(getNode(nodeId));
    if(node)node->SetDelayIndex(TempoSync(value));
}