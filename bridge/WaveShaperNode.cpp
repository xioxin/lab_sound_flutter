#include "./dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
#include "struct.h"
using namespace lab;

DART_EXPORT int createWaveShaperNode(AudioContext* context) {
    auto node = std::make_shared<WaveShaperNode>(*context);
    return keepNode(node);
}

DART_EXPORT void WaveShaperNode_setCurve(*float curve) {
    // todo
}
