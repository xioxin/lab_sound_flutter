#include "./dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
using namespace lab;

DART_EXPORT void AudioNode_initialize(int nodeId) {
    auto node = getNode(nodeId);
    if(node) node->initialize();
}

DART_EXPORT void AudioNode_uninitialize(int nodeId) {
    auto node = getNode(nodeId);
    if(node) node->uninitialize();
}

DART_EXPORT int AudioNode_isScheduledNode(int nodeId) {
    auto node = getNode(nodeId);
    return node ? node->isScheduledNode() : 0;
}

DART_EXPORT int AudioNode_numberOfInputs(int nodeId) {
    auto node = getNode(nodeId);
    return node ? node->numberOfInputs() : 0;
}

DART_EXPORT int AudioNode_numberOfOutputs(int nodeId) {
    auto node = getNode(nodeId);
    return node ? node->numberOfOutputs() : 0;
}

DART_EXPORT int AudioNode_channelCount(int nodeId) {
    auto node = getNode(nodeId);
    return node ? node->channelCount() : 0;
}

DART_EXPORT const char * AudioNode_name(int nodeId) {
    auto node = getNode(nodeId);
    return node ? node->name() : "";
}

DART_EXPORT void AudioNode_reset(int nodeId, AudioContext* context) {
    ContextRenderLock r(context, "reset");
    auto node = getNode(nodeId);
    if(node) node->reset(r);
}


DART_EXPORT int AudioNode_useCount(int nodeId) {
    auto node = getNode(nodeId);
    return node ? node.use_count() : 0;
}

DART_EXPORT void releaseNode(int nodeId){
    keepNodeRelease(nodeId);
}

DART_EXPORT int hasNode(int nodeId){
    auto node = getNode(nodeId);
    return node ? 1 : 0;
}

