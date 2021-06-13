#include "./dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
#include "struct.h"
using namespace lab;

DART_EXPORT int createSfxrNode(AudioContext* context) {
    auto node = std::make_shared<SfxrNode>(*context);
    return keepNode(node);
}

// todo AudioSetting: preset waveType  

DART_EXPORT int SfxrNode_attackTime(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 1, node->attackTime()) : -1;
}
DART_EXPORT int SfxrNode_sustainTime(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 2, node->sustainTime()) : -1;
}
DART_EXPORT int SfxrNode_sustainPunch(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 3, node->sustainPunch()) : -1;
}
DART_EXPORT int SfxrNode_decayTime(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 4, node->decayTime()) : -1;
}

DART_EXPORT int SfxrNode_startFrequency(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 5, node->startFrequency()) : -1;
}
DART_EXPORT int SfxrNode_minFrequency(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 6, node->minFrequency()) : -1;
}
DART_EXPORT int SfxrNode_slide(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 7, node->slide()) : -1;
}
DART_EXPORT int SfxrNode_deltaSlide(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 8, node->deltaSlide()) : -1;
}
DART_EXPORT int SfxrNode_vibratoDepth(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 9, node->vibratoDepth()) : -1;
}
DART_EXPORT int SfxrNode_vibratoSpeed(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 10, node->vibratoSpeed()) : -1;
}

DART_EXPORT int SfxrNode_changeAmount(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 11, node->changeAmount()) : -1;
}
DART_EXPORT int SfxrNode_changeSpeed(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 12, node->changeSpeed()) : -1;
}

DART_EXPORT int SfxrNode_squareDuty(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 13, node->squareDuty()) : -1;
}
DART_EXPORT int SfxrNode_dutySweep(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 14, node->dutySweep()) : -1;
}

DART_EXPORT int SfxrNode_repeatSpeed(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 15, node->repeatSpeed()) : -1;
}
DART_EXPORT int SfxrNode_phaserOffset(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 16, node->phaserOffset()) : -1;
}
DART_EXPORT int SfxrNode_phaserSweep(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 17, node->phaserSweep()) : -1;
}


DART_EXPORT int SfxrNode_lpFilterCutoff(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 18, node->lpFilterCutoff()) : -1;
}
DART_EXPORT int SfxrNode_lpFilterCutoffSweep(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 19, node->lpFilterCutoffSweep()) : -1;
}
DART_EXPORT int SfxrNode_lpFiterResonance(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 20, node->lpFiterResonance()) : -1;
}
DART_EXPORT int SfxrNode_hpFilterCutoff(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 21, node->hpFilterCutoff()) : -1;
}
DART_EXPORT int SfxrNode_hpFilterCutoffSweep(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 22, node->hpFilterCutoffSweep()) : -1;
}


DART_EXPORT void SfxrNode_setStartFrequencyInHz(int nodeId, float value) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    if(node) node->setStartFrequencyInHz(value);
}
DART_EXPORT void SfxrNode_setVibratoSpeedInHz(int nodeId, float value) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    if(node) node->setVibratoSpeedInHz(value);
}

DART_EXPORT float SfxrNode_envelopeTimeInSeconds(int nodeId, float sfxrEnvTime) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? node->envelopeTimeInSeconds(sfxrEnvTime) : 0.0;
}
DART_EXPORT float SfxrNode_envelopeTimeInSfxrUnits(int nodeId, float t) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? node->envelopeTimeInSfxrUnits(t) : 0.0;
}
DART_EXPORT float SfxrNode_frequencyInSfxrUnits(int nodeId, float hz) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? node->frequencyInSfxrUnits(hz) : 0.0;
}
DART_EXPORT float SfxrNode_frequencyInHz(int nodeId, float sfxr) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? node->frequencyInHz(sfxr) : 0.0;
}
DART_EXPORT float SfxrNode_vibratoInSfxrUnits(int nodeId, float hz) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? node->vibratoInSfxrUnits(hz) : 0.0;
}
DART_EXPORT float SfxrNode_vibratoInHz(int nodeId, float sfxr) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? node->vibratoInHz(sfxr) : 0.0;
}
DART_EXPORT float SfxrNode_filterFreqInHz(int nodeId, float sfxr) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? node->filterFreqInHz(sfxr) : 0.0;
}

DART_EXPORT float SfxrNode_filterFreqInSfxrUnits(int nodeId, float hz) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    return node ? node->filterFreqInSfxrUnits(hz) : 0.0;
}





DART_EXPORT void SfxrNode_setDefaultBeep(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    if(node)node->setDefaultBeep();
}
DART_EXPORT void SfxrNode_coin(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    if(node)node->coin();
}
DART_EXPORT void SfxrNode_laser(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    if(node)node->laser();
}
DART_EXPORT void SfxrNode_explosion(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    if(node)node->explosion();
}
DART_EXPORT void SfxrNode_powerUp(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    if(node)node->powerUp();
}
DART_EXPORT void SfxrNode_hit(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    if(node)node->hit();
}
DART_EXPORT void SfxrNode_jump(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    if(node)node->jump();
}
DART_EXPORT void SfxrNode_select(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    if(node)node->select();
}



DART_EXPORT void SfxrNode_mutate(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    if(node)node->mutate();
}
DART_EXPORT void SfxrNode_randomize(int nodeId) {
    auto node = std::static_pointer_cast<SfxrNode>(getNode(nodeId));
    if(node)node->randomize();
}
