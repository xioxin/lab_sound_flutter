#include "dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
using namespace lab;

DART_EXPORT int AudioScheduledSourceNode_isPlayingOrScheduled(int nodeId) {
    return std::static_pointer_cast<AudioScheduledSourceNode>(audioNodes.find(nodeId)->second)->isPlayingOrScheduled();
}

DART_EXPORT void AudioScheduledSourceNode_stop(int nodeId, float when) {
    std::static_pointer_cast<AudioScheduledSourceNode>(audioNodes.find(nodeId)->second)->stop(when);
}

DART_EXPORT int AudioScheduledSourceNode_hasFinished(int nodeId) {
    return std::static_pointer_cast<AudioScheduledSourceNode>(audioNodes.find(nodeId)->second)->hasFinished();
}

DART_EXPORT uint64_t AudioScheduledSourceNode_startWhen(int nodeId) {
    return std::static_pointer_cast<AudioScheduledSourceNode>(audioNodes.find(nodeId)->second)->startWhen();
}

DART_EXPORT void AudioScheduledSourceNode_start(int nodeId, float when) {
    std::static_pointer_cast<AudioScheduledSourceNode>(audioNodes.find(nodeId)->second)->start(when);
}

DART_EXPORT int AudioScheduledSourceNode_playbackState(int nodeId) {
    return static_cast<int>(std::static_pointer_cast<AudioScheduledSourceNode>(audioNodes.find(nodeId)->second)->playbackState());
}
