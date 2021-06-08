#include "./dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
#include "struct.h"
using namespace lab;

DART_EXPORT int createBiquadFilterNode(AudioContext* context) {
    auto node = std::make_shared<BiquadFilterNode>(*context);
    return keepNode(node);
}

DART_EXPORT int BiquadFilterNode_type(int nodeId) {
    auto node = std::static_pointer_cast<BiquadFilterNode>(getNode(nodeId));
    return node ? static_cast<int>(node->type()) : 0;
}

DART_EXPORT void BiquadFilterNode_setType(int nodeId, int type) {
    auto node = std::static_pointer_cast<BiquadFilterNode>(getNode(nodeId));
    if(node) node->setType(FilterType(type));
}

DART_EXPORT int BiquadFilterNode_frequency(int nodeId) {
    auto node = std::static_pointer_cast<BiquadFilterNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 1, node->frequency()) : -1;
}

DART_EXPORT int BiquadFilterNode_q(int nodeId) {
    auto node = std::static_pointer_cast<BiquadFilterNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 2, node->q()) : -1;
}

DART_EXPORT int BiquadFilterNode_gain(int nodeId) {
    auto node = std::static_pointer_cast<BiquadFilterNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 3, node->gain()) : -1;
}

DART_EXPORT int BiquadFilterNode_detune(int nodeId) {
    auto node = std::static_pointer_cast<BiquadFilterNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 4, node->detune()) : -1;
}
