#include "dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
using namespace lab;

DART_EXPORT int createDynamicsCompressorNode(AudioContext* context) {
    auto node = std::make_shared<DynamicsCompressorNode>(*context);
    return keepNode(node);
}

DART_EXPORT int DynamicsCompressorNode_threshold(int nodeId) {
    auto node = std::static_pointer_cast<DynamicsCompressorNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 1, node->threshold()) : -1;
}

DART_EXPORT int DynamicsCompressorNode_knee(int nodeId) {
    auto node = std::static_pointer_cast<DynamicsCompressorNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 2, node->knee()) : -1;
}

DART_EXPORT int DynamicsCompressorNode_ratio(int nodeId) {
    auto node = std::static_pointer_cast<DynamicsCompressorNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 3, node->ratio()) : -1;
}

DART_EXPORT int DynamicsCompressorNode_attack(int nodeId) {
    auto node = std::static_pointer_cast<DynamicsCompressorNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 4, node->attack()) : -1;
}

DART_EXPORT int DynamicsCompressorNode_release(int nodeId) {
    auto node = std::static_pointer_cast<DynamicsCompressorNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 5, node->release()) : -1;
}

DART_EXPORT int DynamicsCompressorNode_reduction(int nodeId) {
    auto node = std::static_pointer_cast<DynamicsCompressorNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 6, node->reduction()) : -1;
}

