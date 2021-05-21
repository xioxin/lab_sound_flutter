#define DART_CALL __attribute__((visibility("default"))) __attribute__((used))
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
#include "struct.h"
using namespace lab;

extern "C" DART_CALL
int createAnalyserNode(AudioContext* context) {
    auto sample = std::make_shared<AnalyserNode>(*context);
    return keepNode(sample);
}

extern "C" DART_CALL
int createAnalyserNodeFftSize(AudioContext* context, int fftSize) {
    auto sample = std::make_shared<AnalyserNode>(*context, fftSize);
    return keepNode(sample);
}

extern "C" DART_CALL
void AnalyserNode_setFftSize(int nodeIndex, AudioContext* context, int fftSize) {
    ContextRenderLock r(context, "setFftSize");
    std::dynamic_pointer_cast<AnalyserNode>(audioNodes.find(nodeIndex)->second)->setFftSize(r, fftSize);
}

extern "C" DART_CALL
int AnalyserNode_fftSize(int nodeIndex) {
    return std::dynamic_pointer_cast<AnalyserNode>(audioNodes.find(nodeIndex)->second)->fftSize();
}

extern "C" DART_CALL
int AnalyserNode_frequencyBinCount(int nodeIndex) {
    return std::dynamic_pointer_cast<AnalyserNode>(audioNodes.find(nodeIndex)->second)->frequencyBinCount();
}

extern "C" DART_CALL
void AnalyserNode_setMinDecibels(int nodeIndex, double k) {
    std::dynamic_pointer_cast<AnalyserNode>(audioNodes.find(nodeIndex)->second)->setMinDecibels(k);
}

extern "C" DART_CALL
int AnalyserNode_minDecibels(int nodeIndex) {
    return std::dynamic_pointer_cast<AnalyserNode>(audioNodes.find(nodeIndex)->second)->minDecibels();
}

extern "C" DART_CALL
void AnalyserNode_setMaxDecibels(int nodeIndex, double k) {
    std::dynamic_pointer_cast<AnalyserNode>(audioNodes.find(nodeIndex)->second)->setMaxDecibels(k);
}

extern "C" DART_CALL
int AnalyserNode_maxDecibels(int nodeIndex) {
    return std::dynamic_pointer_cast<AnalyserNode>(audioNodes.find(nodeIndex)->second)->maxDecibels();
}

extern "C" DART_CALL
void AnalyserNode_setSmoothingTimeConstant(int nodeIndex, double k) {
    std::dynamic_pointer_cast<AnalyserNode>(audioNodes.find(nodeIndex)->second)->setSmoothingTimeConstant(k);
}

extern "C" DART_CALL
int AnalyserNode_smoothingTimeConstant(int nodeIndex) {
    return std::dynamic_pointer_cast<AnalyserNode>(audioNodes.find(nodeIndex)->second)->smoothingTimeConstant();
}

extern "C" DART_CALL
void AnalyserNode_getFloatFrequencyData(int nodeIndex, float* array) {
    auto analyserNode = std::dynamic_pointer_cast<AnalyserNode>(audioNodes.find(nodeIndex)->second);
    int bufferSize = analyserNode->frequencyBinCount();
    std::vector<float> analyserBuffer(bufferSize);
    analyserNode->getFloatFrequencyData(analyserBuffer);
    memcpy(array, &analyserBuffer[0], analyserBuffer.size() * sizeof(float));
}
