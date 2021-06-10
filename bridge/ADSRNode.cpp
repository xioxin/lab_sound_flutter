# next todo!
#include "./dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
#include "struct.h"
using namespace lab;

DART_EXPORT int createADSRNode(AudioContext* context) {
    auto node = std::make_shared<OscillatorNode>(*context);
    return keepNode(node);
}

DART_EXPORT int ADSRNode_gate(int nodeId) {
    auto node = std::static_pointer_cast<ADSRNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 1, node->gate()) : -1;
}

DART_EXPORT int ADSRNode_oneShot(int nodeId) {
    auto node = std::static_pointer_cast<ADSRNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 2, node->oneShot()) : -1;
}

DART_EXPORT int ADSRNode_attackTime(int nodeId) {
    auto node = std::static_pointer_cast<ADSRNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 3, node->attackTime()) : -1;
}

DART_EXPORT int ADSRNode_attackLevel(int nodeId) {
    auto node = std::static_pointer_cast<ADSRNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 4, node->attackLevel()) : -1;
}

DART_EXPORT int ADSRNode_decayTime(int nodeId) {
    auto node = std::static_pointer_cast<ADSRNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 5, node->decayTime()) : -1;
}

DART_EXPORT int ADSRNode_sustainTime(int nodeId) {
    auto node = std::static_pointer_cast<ADSRNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 6, node->sustainTime()) : -1;
}

DART_EXPORT int ADSRNode_sustainLevel(int nodeId) {
    auto node = std::static_pointer_cast<ADSRNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 7, node->sustainLevel()) : -1;
}

DART_EXPORT int ADSRNode_releaseTime(int nodeId) {
    auto node = std::static_pointer_cast<ADSRNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 8, node->releaseTime()) : -1;
}