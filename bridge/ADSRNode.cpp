#include "./dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
#include "struct.h"
using namespace lab;

DART_EXPORT int createADSRNode(AudioContext* context) {
    auto node = std::make_shared<ADSRNode>(*context);
    return keepNode(node);
}

DART_EXPORT int ADSRNode_finished(int nodeId, AudioContext* context)
{
    auto node = std::static_pointer_cast<ADSRNode>(getNode(nodeId));
    if(node) {
        ContextRenderLock r(context,"ADSRNode_finished");
        return node->finished(r);
    }
    return 0;
}


DART_EXPORT void ADSRNode_set(int nodeId, float attack_time, float attack_level, float decay_time, float sustain_time, float sustain_level, float release_time)
{
    auto node = std::static_pointer_cast<ADSRNode>(getNode(nodeId));
    if(node) {
        node->set(attack_time, attack_level, decay_time, sustain_time, sustain_level, release_time);
    }
}

DART_EXPORT int ADSRNode_gate(int nodeId) {
    auto node = std::static_pointer_cast<ADSRNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 1, node->gate()) : -1;
}

DART_EXPORT int ADSRNode_oneShot(int nodeId) {
    auto node = std::static_pointer_cast<ADSRNode>(getNode(nodeId));
    return node ? keepAudioSetting(nodeId, 2, node->oneShot()) : -1;
}

DART_EXPORT int ADSRNode_attackTime(int nodeId) {
    auto node = std::static_pointer_cast<ADSRNode>(getNode(nodeId));
    return node ? keepAudioSetting(nodeId, 3, node->attackTime()) : -1;
}

DART_EXPORT int ADSRNode_attackLevel(int nodeId) {
    auto node = std::static_pointer_cast<ADSRNode>(getNode(nodeId));
    return node ? keepAudioSetting(nodeId, 4, node->attackLevel()) : -1;
}

DART_EXPORT int ADSRNode_decayTime(int nodeId) {
    auto node = std::static_pointer_cast<ADSRNode>(getNode(nodeId));
    return node ? keepAudioSetting(nodeId, 5, node->decayTime()) : -1;
}

DART_EXPORT int ADSRNode_sustainTime(int nodeId) {
    auto node = std::static_pointer_cast<ADSRNode>(getNode(nodeId));
    return node ? keepAudioSetting(nodeId, 6, node->sustainTime()) : -1;
}

DART_EXPORT int ADSRNode_sustainLevel(int nodeId) {
    auto node = std::static_pointer_cast<ADSRNode>(getNode(nodeId));
    return node ? keepAudioSetting(nodeId, 7, node->sustainLevel()) : -1;
}

DART_EXPORT int ADSRNode_releaseTime(int nodeId) {
    auto node = std::static_pointer_cast<ADSRNode>(getNode(nodeId));
    return node ? keepAudioSetting(nodeId, 8, node->releaseTime()) : -1;
}