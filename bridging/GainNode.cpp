#define DART_CALL __attribute__((visibility("default"))) __attribute__((used))
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
using namespace lab;

extern "C" DART_CALL
int createGain(AudioContext* context) {
    auto node = std::make_shared<GainNode>(*context);
    return keepNode(node);
}

extern "C" DART_CALL
int GainNode_gain(int nodeId) {
    return keepAudioParam(nodeId, 0, std::static_pointer_cast<GainNode>(audioNodes.find(nodeId)->second)->gain());
}