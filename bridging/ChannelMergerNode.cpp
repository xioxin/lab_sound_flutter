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
    auto node = std::static_pointer_cast<ChannelMergerNode>(getNode(nodeId));
    if(node) node->addInputs(n);
}

DART_EXPORT void ChannelMergerNode_setOutputChannelCount(int nodeIndex, int n) {
    auto node = std::static_pointer_cast<ChannelMergerNode>(getNode(nodeId));
    if(node) node->setOutputChannelCount(n);
}

