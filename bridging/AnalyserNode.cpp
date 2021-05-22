#include "dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
#include "struct.h"
using namespace lab;

DART_EXPORT int createAnalyserNode(AudioContext* context) {
    auto sample = std::make_shared<AnalyserNode>(*context);
    return keepNode(sample);
}

DART_EXPORT int createAnalyserNodeFftSize(AudioContext* context, int fftSize) {
    auto sample = std::make_shared<AnalyserNode>(*context, fftSize);
    return keepNode(sample);
}

DART_EXPORT void AnalyserNode_setFftSize(int nodeIndex, AudioContext* context, int fftSize) {
    ContextRenderLock r(context, "setFftSize");
    std::dynamic_pointer_cast<AnalyserNode>(audioNodes.find(nodeIndex)->second)->setFftSize(r, fftSize);
}

DART_EXPORT int AnalyserNode_fftSize(int nodeIndex) {
    return std::dynamic_pointer_cast<AnalyserNode>(audioNodes.find(nodeIndex)->second)->fftSize();
}

DART_EXPORT int AnalyserNode_frequencyBinCount(int nodeIndex) {
    return std::dynamic_pointer_cast<AnalyserNode>(audioNodes.find(nodeIndex)->second)->frequencyBinCount();
}

DART_EXPORT void AnalyserNode_setMinDecibels(int nodeIndex, double k) {
    std::dynamic_pointer_cast<AnalyserNode>(audioNodes.find(nodeIndex)->second)->setMinDecibels(k);
}

DART_EXPORT int AnalyserNode_minDecibels(int nodeIndex) {
    return std::dynamic_pointer_cast<AnalyserNode>(audioNodes.find(nodeIndex)->second)->minDecibels();
}

DART_EXPORT void AnalyserNode_setMaxDecibels(int nodeIndex, double k) {
    std::dynamic_pointer_cast<AnalyserNode>(audioNodes.find(nodeIndex)->second)->setMaxDecibels(k);
}

DART_EXPORT int AnalyserNode_maxDecibels(int nodeIndex) {
    return std::dynamic_pointer_cast<AnalyserNode>(audioNodes.find(nodeIndex)->second)->maxDecibels();
}

DART_EXPORT void AnalyserNode_setSmoothingTimeConstant(int nodeIndex, double k) {
    std::dynamic_pointer_cast<AnalyserNode>(audioNodes.find(nodeIndex)->second)->setSmoothingTimeConstant(k);
}

DART_EXPORT int AnalyserNode_smoothingTimeConstant(int nodeIndex) {
    return std::dynamic_pointer_cast<AnalyserNode>(audioNodes.find(nodeIndex)->second)->smoothingTimeConstant();
}

DART_EXPORT void AnalyserNode_getFloatFrequencyData(int nodeIndex, float* array) {
    auto analyserNode = std::dynamic_pointer_cast<AnalyserNode>(audioNodes.find(nodeIndex)->second);
    int bufferSize = analyserNode->frequencyBinCount();
    std::vector<float> analyserBuffer(bufferSize);
    analyserNode->getFloatFrequencyData(analyserBuffer);
    memcpy(array, &analyserBuffer[0], analyserBuffer.size() * sizeof(float));
}

DART_EXPORT void AnalyserNode_getByteFrequencyData(int nodeIndex, uint8_t* array, bool resample) {
    auto analyserNode = std::dynamic_pointer_cast<AnalyserNode>(audioNodes.find(nodeIndex)->second);
    int bufferSize = analyserNode->frequencyBinCount();
    std::vector<uint8_t> analyserBuffer(bufferSize);
    analyserNode->getByteFrequencyData(analyserBuffer, resample);
    memcpy(array, &analyserBuffer[0], analyserBuffer.size() * sizeof(uint8_t));
}

DART_EXPORT void AnalyserNode_getFloatTimeDomainData(int nodeIndex, float* array) {
    auto analyserNode = std::dynamic_pointer_cast<AnalyserNode>(audioNodes.find(nodeIndex)->second);
    int bufferSize = analyserNode->frequencyBinCount();
    std::vector<float> analyserBuffer(bufferSize);
    analyserNode->getFloatTimeDomainData(analyserBuffer);
    memcpy(array, &analyserBuffer[0], analyserBuffer.size() * sizeof(float));
}

DART_EXPORT void AnalyserNode_getByteTimeDomainData(int nodeIndex, uint8_t* array) {
    auto analyserNode = std::dynamic_pointer_cast<AnalyserNode>(audioNodes.find(nodeIndex)->second);
    int bufferSize = analyserNode->frequencyBinCount();
    std::vector<uint8_t> analyserBuffer(bufferSize);
    analyserNode->getByteTimeDomainData(analyserBuffer);
    memcpy(array, &analyserBuffer[0], analyserBuffer.size() * sizeof(uint8_t));
}

