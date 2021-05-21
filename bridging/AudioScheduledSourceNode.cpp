#define DART_CALL __attribute__((visibility("default"))) __attribute__((used))
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
using namespace lab;

extern "C" DART_CALL
int AudioScheduledSourceNode_isPlayingOrScheduled(int nodeId) {
    return std::static_pointer_cast<AudioScheduledSourceNode>(audioNodes.find(nodeId)->second)->isPlayingOrScheduled();
}

extern "C" DART_CALL
void AudioScheduledSourceNode_stop(int nodeId, float when) {
    std::static_pointer_cast<AudioScheduledSourceNode>(audioNodes.find(nodeId)->second)->stop(when);
}

extern "C" DART_CALL
int AudioScheduledSourceNode_hasFinished(int nodeId) {
    return std::static_pointer_cast<AudioScheduledSourceNode>(audioNodes.find(nodeId)->second)->hasFinished();
}

extern "C" DART_CALL
uint64_t AudioScheduledSourceNode_startWhen(int nodeId) {
    return std::static_pointer_cast<AudioScheduledSourceNode>(audioNodes.find(nodeId)->second)->startWhen();
}

extern "C" DART_CALL
void AudioScheduledSourceNode_start(int nodeId, float when) {
    std::static_pointer_cast<AudioScheduledSourceNode>(audioNodes.find(nodeId)->second)->start(when);
}

extern "C" DART_CALL
int AudioScheduledSourceNode_playbackState(int nodeId) {
    return static_cast<int>(std::static_pointer_cast<AudioScheduledSourceNode>(audioNodes.find(nodeId)->second)->playbackState());
}
