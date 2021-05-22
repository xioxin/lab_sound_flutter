#include "dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
#include "struct.h"
using namespace lab;

DART_EXPORT int createBiquadFilterNode(AudioContext* context) {
    auto sample = std::make_shared<BiquadFilterNode>(*context);
    return keepNode(sample);
}

DART_EXPORT int BiquadFilterNode_type(int nodeIndex) {
    return static_cast<int>(std::dynamic_pointer_cast<BiquadFilterNode>(audioNodes.find(nodeIndex)->second)->type());
}

DART_EXPORT void BiquadFilterNode_setType(int nodeIndex, int type) {
    std::dynamic_pointer_cast<BiquadFilterNode>(audioNodes.find(nodeIndex)->second)->setType(FilterType(type));
}

DART_EXPORT int BiquadFilterNode_frequency(int nodeId) {
    return keepAudioParam(nodeId, 1, std::static_pointer_cast<BiquadFilterNode>(audioNodes.find(nodeId)->second)->frequency());
}

DART_EXPORT int BiquadFilterNode_q(int nodeId) {
    return keepAudioParam(nodeId, 2, std::static_pointer_cast<BiquadFilterNode>(audioNodes.find(nodeId)->second)->q());
}

DART_EXPORT int BiquadFilterNode_gain(int nodeId) {
    return keepAudioParam(nodeId, 3, std::static_pointer_cast<BiquadFilterNode>(audioNodes.find(nodeId)->second)->gain());
}

DART_EXPORT int BiquadFilterNode_detune(int nodeId) {
    return keepAudioParam(nodeId, 4, std::static_pointer_cast<BiquadFilterNode>(audioNodes.find(nodeId)->second)->detune());
}

