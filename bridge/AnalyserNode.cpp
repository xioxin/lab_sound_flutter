#include "./dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
#include "struct.h"
using namespace lab;

DART_EXPORT int createAnalyserNode(AudioContext* context) {
    auto node = std::make_shared<AnalyserNode>(*context);
    return keepNode(node);
}

DART_EXPORT int createAnalyserNodeFftSize(AudioContext* context, int fftSize) {
    auto node = std::make_shared<AnalyserNode>(*context, fftSize);
    return keepNode(node);
}

DART_EXPORT void AnalyserNode_setFftSize(int nodeId, AudioContext* context, int fftSize) {
    ContextRenderLock r(context, "setFftSize");
    auto node = std::static_pointer_cast<AnalyserNode>(getNode(nodeId));
    if(node) node->setFftSize(r, fftSize);
}

DART_EXPORT int AnalyserNode_fftSize(int nodeId) {
    auto node = std::static_pointer_cast<AnalyserNode>(getNode(nodeId));
    return node ? node->fftSize() : 0;
}

DART_EXPORT int AnalyserNode_frequencyBinCount(int nodeId) {
    auto node = std::static_pointer_cast<AnalyserNode>(getNode(nodeId));
    return node ? node->frequencyBinCount() : 0;
}

DART_EXPORT void AnalyserNode_setMinDecibels(int nodeId, double k) {
    auto node = std::static_pointer_cast<AnalyserNode>(getNode(nodeId));
    if(node) node->setMinDecibels(k);
}

DART_EXPORT int AnalyserNode_minDecibels(int nodeId) {
    auto node = std::static_pointer_cast<AnalyserNode>(getNode(nodeId));
    return node ? node->minDecibels() : 0;
}

DART_EXPORT void AnalyserNode_setMaxDecibels(int nodeId, double k) {
    auto node = std::static_pointer_cast<AnalyserNode>(getNode(nodeId));
    if(node) node->setMaxDecibels(k);
}

DART_EXPORT int AnalyserNode_maxDecibels(int nodeId) {
    auto node = std::static_pointer_cast<AnalyserNode>(getNode(nodeId));
    return node ? node->maxDecibels() : 0;
}

DART_EXPORT void AnalyserNode_setSmoothingTimeConstant(int nodeId, double k) {
    auto node = std::static_pointer_cast<AnalyserNode>(getNode(nodeId));
    if(node) node->setSmoothingTimeConstant(k);
}

DART_EXPORT int AnalyserNode_smoothingTimeConstant(int nodeId) {
    auto node = std::static_pointer_cast<AnalyserNode>(getNode(nodeId));
    return node ? node->smoothingTimeConstant() : 0;
}

DART_EXPORT void AnalyserNode_getFloatFrequencyData(int nodeId, float* array) {
    auto node = std::static_pointer_cast<AnalyserNode>(getNode(nodeId));
    if(!node) return;
    int bufferSize = node->frequencyBinCount();
    std::vector<float> analyserBuffer(bufferSize);
    node->getFloatFrequencyData(analyserBuffer);
    memcpy(array, &analyserBuffer[0], analyserBuffer.size() * sizeof(float));
}

DART_EXPORT void AnalyserNode_getByteFrequencyData(int nodeId, uint8_t* array, int resample) {
    auto node = std::static_pointer_cast<AnalyserNode>(getNode(nodeId));
    if(!node) return;
    int bufferSize = node->frequencyBinCount();
    std::vector<uint8_t> analyserBuffer(bufferSize);
    node->getByteFrequencyData(analyserBuffer, resample > 0);
    memcpy(array, &analyserBuffer[0], analyserBuffer.size() * sizeof(uint8_t));
}

DART_EXPORT void AnalyserNode_getFloatTimeDomainData(int nodeId, float* array) {
    auto node = std::static_pointer_cast<AnalyserNode>(getNode(nodeId));
    if(!node) return;
    int bufferSize = node->frequencyBinCount();
    std::vector<float> analyserBuffer(bufferSize);
    node->getFloatTimeDomainData(analyserBuffer);
    memcpy(array, &analyserBuffer[0], analyserBuffer.size() * sizeof(float));
}

DART_EXPORT void AnalyserNode_getByteTimeDomainData(int nodeId, uint8_t* array) {
    auto node = std::static_pointer_cast<AnalyserNode>(getNode(nodeId));
    if(!node) return;
    int bufferSize = node->frequencyBinCount();
    std::vector<uint8_t> analyserBuffer(bufferSize);
    node->getByteTimeDomainData(analyserBuffer);
    memcpy(array, &analyserBuffer[0], analyserBuffer.size() * sizeof(uint8_t));
}

