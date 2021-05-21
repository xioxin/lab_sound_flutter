#define DART_CALL __attribute__((visibility("default"))) __attribute__((used))
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
using namespace lab;

extern "C" DART_CALL
int AudioNode_isScheduledNode(int nodeId) {
    return audioNodes.find(nodeId)->second->isScheduledNode();
}

extern "C" DART_CALL
int AudioNode_numberOfInputs(int nodeId) {
    return audioNodes.find(nodeId)->second->numberOfInputs();
}

extern "C" DART_CALL
int AudioNode_numberOfOutputs(int nodeId) {
    return audioNodes.find(nodeId)->second->numberOfOutputs();
}

extern "C" DART_CALL
int AudioNode_channelCount(int nodeId) {
    return audioNodes.find(nodeId)->second->channelCount();
}

extern "C" DART_CALL
void AudioNode_reset(int nodeId, AudioContext* context) {
    ContextRenderLock r(context, "reset");
    audioNodes.find(nodeId)->second->reset(r);
}

extern "C" DART_CALL
void releaseNode(int nodeId){
    audioNodes.erase(nodeId);
    audioParams.erase(nodeId);
}


