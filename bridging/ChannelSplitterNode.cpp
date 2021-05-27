#include "dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
#include "struct.h"
using namespace lab;

DART_EXPORT int createChannelSplitterNode(AudioContext* context) {
    auto sample = std::make_shared<ChannelSplitterNode>(*context);
    return keepNode(sample);
}

DART_EXPORT void ChannelSplitterNode_addOutputs(int nodeIndex, int n) {
    std::dynamic_pointer_cast<ChannelSplitterNode>(audioNodes.find(nodeIndex)->second)->addOutputs(n);
}
