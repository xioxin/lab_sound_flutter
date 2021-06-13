#include "./dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
#include "struct.h"
using namespace lab;

DART_EXPORT int createConvolverNode(AudioContext* context) {
    auto node = std::make_shared<ConvolverNode>(*context);
    return keepNode(node);
}

DART_EXPORT int ConvolverNode_normalize(int nodeId) {
    auto node = std::static_pointer_cast<ConvolverNode>(getNode(nodeId));
    return node ? node->normalize() : 0;
}

DART_EXPORT void ConvolverNode_setNormalize(int nodeId, int newN) {
    auto node = std::static_pointer_cast<ConvolverNode>(getNode(nodeId));
    if(node)node->setNormalize( newN > 0);
}


DART_EXPORT void ConvolverNode_setImpulse(int nodeId, int busId) {
    auto node = std::static_pointer_cast<ConvolverNode>(getNode(nodeId));
    auto bus = getBus(busId);
    if(node && bus) node->setImpulse(bus);
}

// DART_EXPORT void ConvolverNode_getImpulse(int nodeId) {
//     auto node = std::static_pointer_cast<ConvolverNode>(getNode(nodeId));
//     return node ? node->getImpulse() : -1;
// }
