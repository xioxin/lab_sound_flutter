#include "./dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
#include "struct.h"
using namespace lab;

DART_EXPORT int createAudioHardwareDeviceNode(AudioContext* context, const AudioStreamConfig outputConfig, const AudioStreamConfig inputConfig) {
    auto node = std::make_shared<lab::AudioHardwareDeviceNode>(*context, outputConfig, inputConfig);
    return keepNode(node);
}

DART_EXPORT void AudioHardwareDeviceNode_start(int nodeId) {
    auto node = std::static_pointer_cast<AudioHardwareDeviceNode>(getNode(nodeId));
    if(node) node->start();
}

DART_EXPORT void AudioHardwareDeviceNode_stop(int nodeId) {
    auto node = std::static_pointer_cast<AudioHardwareDeviceNode>(getNode(nodeId));
    if(node) node->stop();
}

DART_EXPORT int AudioHardwareDeviceNode_isRunning(int nodeId) {
    auto node = std::static_pointer_cast<AudioHardwareDeviceNode>(getNode(nodeId));
    return node ? node->isRunning() : 0;
}

DART_EXPORT AudioStreamConfig AudioHardwareDeviceNode_getOutputConfig(int nodeId) {
    auto node = std::static_pointer_cast<AudioHardwareDeviceNode>(getNode(nodeId));
    return node ? node->getOutputConfig() : AudioStreamConfig();
}

DART_EXPORT AudioStreamConfig AudioHardwareDeviceNode_getInputConfig(int nodeId) {
    auto node = std::static_pointer_cast<AudioHardwareDeviceNode>(getNode(nodeId));
    return node ? node->getInputConfig() : AudioStreamConfig();
}

DART_EXPORT void AudioHardwareDeviceNode_backendReinitialize(int nodeId) {
    auto node = std::static_pointer_cast<AudioHardwareDeviceNode>(getNode(nodeId));
    if(node) node->backendReinitialize();
}

DART_EXPORT AudioStreamConfig createAudioStreamConfig(int device_index, uint32_t desired_channels, float desired_samplerate) {
    AudioStreamConfig config;
    config.device_index = device_index;
    config.desired_channels = desired_channels;
    config.desired_samplerate = desired_samplerate;
    return config;
}
