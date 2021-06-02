#include "dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
using namespace lab;

DART_EXPORT int createRecorderNode(AudioContext* context, int channelCount ) {
    auto recorder = std::make_shared<RecorderNode>(*context, channelCount);
    return keepNode(recorder);
}
DART_EXPORT int createRecorderNodeConfig(AudioContext* context, AudioStreamConfig outputConfig ) {
    auto recorder = std::make_shared<RecorderNode>(*context, outputConfig);
    return keepNode(recorder);
}

DART_EXPORT void RecorderNode_startRecording(int nodeId) {
    auto node = std::static_pointer_cast<RecorderNode>(getNode(nodeId));
    if(node) node->startRecording();
}

DART_EXPORT void RecorderNode_stopRecording(int nodeId) {
    auto node = std::static_pointer_cast<RecorderNode>(getNode(nodeId));
    if(node) node->stopRecording();
}

DART_EXPORT float RecorderNode_recordedLengthInSeconds(int nodeId) {
    auto node = std::static_pointer_cast<RecorderNode>(getNode(nodeId));
    return node ? node->recordedLengthInSeconds() : 0.;
}

DART_EXPORT int RecorderNode_createBusFromRecording(int nodeId, int mixToMono) {
    auto node = std::static_pointer_cast<RecorderNode>(getNode(nodeId));
    return node ? keepBus(std::move(node->createBusFromRecording(mixToMono > 0))) : -1;
}

DART_EXPORT int RecorderNode_writeRecordingToWav(int nodeId, char *file, int mixToMono) {
    auto node = std::static_pointer_cast<RecorderNode>(getNode(nodeId));
    return node ? node->writeRecordingToWav(file, mixToMono > 0) : 0;
}
