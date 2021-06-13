#include "./dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
using namespace lab;

DART_EXPORT int createPowerMonitorNode(AudioContext* context) {
    auto node = std::make_shared<PowerMonitorNode>(*context);
    return keepNode(node);
}

DART_EXPORT int PowerMonitorNode_windowSize(int nodeId) {
    auto node = std::static_pointer_cast<PowerMonitorNode>(getNode(nodeId));
    return node ? node->windowSize() : 0;
}

DART_EXPORT float PowerMonitorNode_db(int nodeId) {
    auto node = std::static_pointer_cast<PowerMonitorNode>(getNode(nodeId));
    return node ? node->db() : 0.0;
}

DART_EXPORT void PowerMonitorNode_setWindowSize(int nodeId, int ws) {
    auto node = std::static_pointer_cast<PowerMonitorNode>(getNode(nodeId));
    if(node)node->windowSize(ws);
}
