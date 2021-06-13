#include "./dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
#include "struct.h"
using namespace lab;

DART_EXPORT int createNoiseNode(AudioContext* context) {
    auto node = std::make_shared<NoiseNode>(*context);
    return keepNode(node);
}

DART_EXPORT int NoiseNode_type(int nodeId) {
    auto node = std::static_pointer_cast<NoiseNode>(getNode(nodeId));
    return node ? static_cast<int>(node->type()) : 0;
}

DART_EXPORT void NoiseNode_setType(int nodeId, int type) {
    auto node = std::static_pointer_cast<NoiseNode>(getNode(nodeId));
    if(node) node->setType(NoiseNode::NoiseType(type));
}

