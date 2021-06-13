#include "./dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
#include "struct.h"
using namespace lab;

DART_EXPORT int createPolyBLEPNode(AudioContext* context) {
    auto node = std::make_shared<PolyBLEPNode>(*context);
    return keepNode(node);
}

DART_EXPORT int PolyBLEPNode_type(int nodeId) {
    auto node = std::static_pointer_cast<PolyBLEPNode>(getNode(nodeId));
    return node ? static_cast<int>(node->type()) : 0;
}

DART_EXPORT void PolyBLEPNode_setType(int nodeId, int type) {
    auto node = std::static_pointer_cast<PolyBLEPNode>(getNode(nodeId));
    if(node) node->setType(PolyBLEPType(type));
}

DART_EXPORT int PolyBLEPNode_amplitude(int nodeId) {
    auto node = std::static_pointer_cast<PolyBLEPNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 1, node->amplitude()) : -1;
}

DART_EXPORT int PolyBLEPNode_frequency(int nodeId) {
    auto node = std::static_pointer_cast<PolyBLEPNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 2, node->frequency()) : -1;
}