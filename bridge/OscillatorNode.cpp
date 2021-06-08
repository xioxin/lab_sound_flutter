#include "./dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
#include "struct.h"
using namespace lab;

DART_EXPORT int createOscillatorNode(AudioContext* context) {
    auto node = std::make_shared<OscillatorNode>(*context);
    return keepNode(node);
}

DART_EXPORT int OscillatorNode_type(int nodeId) {
    auto node = std::static_pointer_cast<OscillatorNode>(getNode(nodeId));
    return node ? static_cast<int>(node->type()) : 0;
}

DART_EXPORT void OscillatorNode_setType(int nodeId, int type) {
    auto node = std::static_pointer_cast<OscillatorNode>(getNode(nodeId));
    if(node) node->setType(OscillatorType(type));
}

DART_EXPORT int OscillatorNode_amplitude(int nodeId) {
    auto node = std::static_pointer_cast<OscillatorNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 1, node->amplitude()) : -1;
}

DART_EXPORT int OscillatorNode_frequency(int nodeId) {
    auto node = std::static_pointer_cast<OscillatorNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 2, node->frequency()) : -1;
}

DART_EXPORT int OscillatorNode_detune(int nodeId) {
    auto node = std::static_pointer_cast<OscillatorNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 3, node->detune()) : -1;
}

DART_EXPORT int OscillatorNode_bias(int nodeId) {
    auto node = std::static_pointer_cast<OscillatorNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 4, node->bias()) : -1;
}
