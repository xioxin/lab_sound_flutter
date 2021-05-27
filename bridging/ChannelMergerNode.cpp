#include "dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
#include "struct.h"
using namespace lab;

DART_EXPORT int createChannelMergerNode(AudioContext* context) {
    auto sample = std::make_shared<ChannelMergerNode>(*context);
    return keepNode(sample);
}

DART_EXPORT void ChannelMergerNode_addInputs(int nodeIndex, int n) {
    std::dynamic_pointer_cast<ChannelMergerNode>(audioNodes.find(nodeIndex)->second)->addInputs(n);
}

DART_EXPORT void ChannelMergerNode_setOutputChannelCount(int nodeIndex, int n) {
    std::dynamic_pointer_cast<ChannelMergerNode>(audioNodes.find(nodeIndex)->second)->setOutputChannelCount(n);
}

