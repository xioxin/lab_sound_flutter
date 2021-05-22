#include "dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
using namespace lab;

DART_EXPORT int createGain(AudioContext* context) {
    auto node = std::make_shared<GainNode>(*context);
    return keepNode(node);
}

DART_EXPORT int GainNode_gain(int nodeId) {
    return keepAudioParam(nodeId, 0, std::static_pointer_cast<GainNode>(audioNodes.find(nodeId)->second)->gain());
}