#include "./dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
using namespace lab;

DART_EXPORT int createDelayNode(AudioContext* context) {
    auto node = std::make_shared<DelayNode>(*context);
    return keepNode(node);
}

DART_EXPORT int DelayNode_delayTime(int nodeId) {
    auto node = std::static_pointer_cast<DelayNode>(getNode(nodeId));
    return node ? keepAudioSetting(nodeId, 0, node->delayTime()) : -1;
}
