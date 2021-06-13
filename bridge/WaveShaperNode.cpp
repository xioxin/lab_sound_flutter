#include "./dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
#include "struct.h"
using namespace lab;

DART_EXPORT int createWaveShaperNode(AudioContext* context) {
    auto node = std::make_shared<WaveShaperNode>(*context);
    return keepNode(node);
}

DART_EXPORT void WaveShaperNode_setCurve(const int nodeId, const float* curve) {
    auto node = std::static_pointer_cast<WaveShaperNode>(getNode(nodeId));
    if(node) {
        std::vector<float> vecCurve(curve, curve + sizeof(curve)/sizeof(float));
        node->setCurve(vecCurve);
    }
}
