#include "./dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
using namespace lab;

DART_EXPORT int createStereoPannerNode(AudioContext* context) {
    auto node = std::make_shared<StereoPannerNode>(*context);
    return keepNode(node);
}

DART_EXPORT int StereoPannerNode_pan(int nodeId) {
    auto node = std::static_pointer_cast<StereoPannerNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 0, node->pan()) : -1;
}
