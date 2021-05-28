#include "dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
#include "struct.h"
using namespace lab;

DART_EXPORT int createPannerNode(AudioContext* context) {
    auto sample = std::make_shared<PannerNode>(*context);
    return keepNode(sample);
}

DART_EXPORT int PannerNode_panningModel(int nodeId) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    return node ? static_cast<int>(node->type()) : 0;
}

DART_EXPORT void PannerNode_setPanningModel(int nodeId, int m) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    if(node) node->setPanningModel(PanningMode(m));
}

DART_EXPORT int PannerNode_distanceModel(int nodeId) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    return node ? static_cast<int>(node->distanceModel()) : 0;
}

DART_EXPORT void PannerNode_setDistanceModel(int nodeId, int m) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    if(node) node->setDistanceModel(lab::PannerNode::DistanceModel(m));
}

DART_EXPORT void PannerNode_setPosition(int nodeId, float x, float y, float z) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    if(node) node->setPosition(x, y, z);
}

DART_EXPORT void PannerNode_setOrientation(int nodeId, float x, float y, float z) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    if(node) node->setOrientation(FloatPoint3D(x, y, z));
}

DART_EXPORT void PannerNode_setVelocity(int nodeId, float x, float y, float z) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    if(node) node->setVelocity(x, y, z);
}

DART_EXPORT int PannerNode_positionX(int nodeId) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 1, node->positionX()) : -1;
}
DART_EXPORT int PannerNode_positionY(int nodeId) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 2, node->positionY()) : -1;
}
DART_EXPORT int PannerNode_positionZ(int nodeId) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 3, node->positionZ()) : -1;
}

DART_EXPORT int PannerNode_orientationX(int nodeId) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 4, node->orientationX()) : -1;
}
DART_EXPORT int PannerNode_orientationY(int nodeId) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 5, node->orientationY()) : -1;
}
DART_EXPORT int PannerNode_orientationZ(int nodeId) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 6, node->orientationZ()) : -1;
}


DART_EXPORT int PannerNode_velocityX(int nodeId) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 7, node->velocityX()) : -1;
}
DART_EXPORT int PannerNode_velocityY(int nodeId) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 8, node->velocityY()) : -1;
}
DART_EXPORT int PannerNode_velocityZ(int nodeId) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 9, node->velocityZ()) : -1;
}

DART_EXPORT int PannerNode_distanceGain(int nodeId) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 10, node->distanceGain()) : -1;
}
DART_EXPORT int PannerNode_coneGain(int nodeId) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    return node ? keepAudioParam(nodeId, 11, node->coneGain()) : -1;
}

DART_EXPORT float PannerNode_refDistance(int nodeId) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    return node ? node->refDistance() : 0.;
}
DART_EXPORT void PannerNode_setRefDistance(int nodeId, float refDistance) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    if(node) node->setRefDistance(refDistance);
}

DART_EXPORT float PannerNode_maxDistance(int nodeId) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    return node ? node->maxDistance() : 0.;
}
DART_EXPORT void PannerNode_setMaxDistance(int nodeId, float maxDistance) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    if(node) node->setMaxDistance(maxDistance);
}

DART_EXPORT float PannerNode_rolloffFactor(int nodeId) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    return node ? node->rolloffFactor() : 0.;
}
DART_EXPORT void PannerNode_setRolloffFactor(int nodeId, float rolloffFactor) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    if(node) node->setRolloffFactor(rolloffFactor);
}

DART_EXPORT float PannerNode_coneInnerAngle(int nodeId) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    return node ? node->coneInnerAngle() : 0.;
}
DART_EXPORT void PannerNode_setConeInnerAngle(int nodeId, float angle) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    if(node) node->setConeInnerAngle(angle);
}


DART_EXPORT float PannerNode_coneOuterAngle(int nodeId) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    return node ? node->coneOuterAngle() : 0.;
}
DART_EXPORT void PannerNode_setConeOuterAngle(int nodeId, float angle) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    if(node) node->setConeOuterAngle(angle);
}

DART_EXPORT float PannerNode_coneOuterGain(int nodeId) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    return node ? node->coneOuterGain() : 0.;
}
DART_EXPORT void PannerNode_setConeOuterGain(int nodeId, float angle) {
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    if(node) node->setConeOuterGain(angle);
}

DART_EXPORT void PannerNode_getAzimuthElevation(int nodeId, AudioContext* context, double * outAzimuth, double * outElevation) {
    ContextRenderLock r(context,"getAzimuthElevation");
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    if(node) node->getAzimuthElevation(r, outAzimuth, outElevation);
}

DART_EXPORT void PannerNode_dopplerRate(int nodeId, AudioContext* context) {
    ContextRenderLock r(context, "dopplerRate");
    auto node = std::static_pointer_cast<PannerNode>(getNode(nodeId));
    if(node) node->dopplerRate(r);
}
