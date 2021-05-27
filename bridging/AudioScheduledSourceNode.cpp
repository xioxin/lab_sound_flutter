#include "dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
using namespace lab;

DART_EXPORT int AudioScheduledSourceNode_isPlayingOrScheduled(int nodeId) {
    auto node = std::static_pointer_cast<AudioScheduledSourceNode>(getNode(nodeId));
    return node ? node->isPlayingOrScheduled() : 0;
}

DART_EXPORT void AudioScheduledSourceNode_stop(int nodeId, float when) {
    auto node = std::static_pointer_cast<AudioScheduledSourceNode>(getNode(nodeId));
    if(node) node->stop(when);
}

DART_EXPORT int AudioScheduledSourceNode_hasFinished(int nodeId) {
    auto node = std::static_pointer_cast<AudioScheduledSourceNode>(getNode(nodeId));
    return node ? node->hasFinished() : 0;
}

DART_EXPORT uint64_t AudioScheduledSourceNode_startWhen(int nodeId) {
    auto node = std::static_pointer_cast<AudioScheduledSourceNode>(getNode(nodeId));
    return node ? node->startWhen() : 0;
}

DART_EXPORT void AudioScheduledSourceNode_start(int nodeId, float when) {
    auto node = std::static_pointer_cast<AudioScheduledSourceNode>(getNode(nodeId));
    if(node) node->start(when);
}

DART_EXPORT int AudioScheduledSourceNode_playbackState(int nodeId) {
    auto node = std::static_pointer_cast<AudioScheduledSourceNode>(getNode(nodeId));
    return node ? static_cast<int>(node->playbackState()) : 0;
}
