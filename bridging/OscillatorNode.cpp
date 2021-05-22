#include "dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
#include "struct.h"
using namespace lab;

DART_EXPORT int createOscillatorNode(AudioContext* context) {
    auto sample = std::make_shared<OscillatorNode>(*context);
    return keepNode(sample);
}

DART_EXPORT int OscillatorNode_type(int nodeIndex) {
    return static_cast<int>(std::dynamic_pointer_cast<OscillatorNode>(audioNodes.find(nodeIndex)->second)->type());
}

DART_EXPORT void OscillatorNode_setType(int nodeIndex, int type) {
    std::dynamic_pointer_cast<OscillatorNode>(audioNodes.find(nodeIndex)->second)->setType(OscillatorType(type));
}

DART_EXPORT int OscillatorNode_amplitude(int nodeId) {
    return keepAudioParam(nodeId, 1, std::static_pointer_cast<OscillatorNode>(audioNodes.find(nodeId)->second)->amplitude());
}

DART_EXPORT int OscillatorNode_frequency(int nodeId) {
    return keepAudioParam(nodeId, 2, std::static_pointer_cast<OscillatorNode>(audioNodes.find(nodeId)->second)->frequency());
}

DART_EXPORT int OscillatorNode_detune(int nodeId) {
    return keepAudioParam(nodeId, 3, std::static_pointer_cast<OscillatorNode>(audioNodes.find(nodeId)->second)->detune());
}

DART_EXPORT int OscillatorNode_bias(int nodeId) {
    return keepAudioParam(nodeId, 4, std::static_pointer_cast<OscillatorNode>(audioNodes.find(nodeId)->second)->bias());
}
