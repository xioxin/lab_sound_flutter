#include "dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
using namespace lab;

DART_EXPORT int AudioNode_isScheduledNode(int nodeId) {
    return audioNodes.find(nodeId)->second->isScheduledNode();
}

DART_EXPORT int AudioNode_numberOfInputs(int nodeId) {
    return audioNodes.find(nodeId)->second->numberOfInputs();
}

DART_EXPORT int AudioNode_numberOfOutputs(int nodeId) {
    return audioNodes.find(nodeId)->second->numberOfOutputs();
}

DART_EXPORT int AudioNode_channelCount(int nodeId) {
    return audioNodes.find(nodeId)->second->channelCount();
}

DART_EXPORT const char * AudioNode_name(int nodeId) {
    return audioNodes.find(nodeId)->second->name();
}

DART_EXPORT void AudioNode_reset(int nodeId, AudioContext* context) {
    ContextRenderLock r(context, "reset");
    audioNodes.find(nodeId)->second->reset(r);
}

DART_EXPORT void releaseNode(int nodeId){
    audioNodes.erase(nodeId);
    audioParams.erase(nodeId);
}


