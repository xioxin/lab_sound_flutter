#include "dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
using namespace lab;

DART_EXPORT float AudioParam_value(int nodeIndex, int paramIndex) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        return param->value();
    }
    return 0.0;
}

DART_EXPORT void AudioParam_setValue(int nodeIndex, int paramIndex, float value) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        param->setValue(value);
    } else {
    }
}

DART_EXPORT void AudioParam_setValueCurveAtTime(int nodeIndex, int paramIndex, float curve[],float time,float duration) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        std::vector<float> curveVec;
        int length = sizeof(&curve)/sizeof(curve[0]);
        for(int i=0;i<length;i++){
            curveVec.push_back(curve[i]);
        }
        param->setValueCurveAtTime(curveVec,time,duration);
    }
}

DART_EXPORT void AudioParam_cancelScheduledValues(int nodeIndex, int paramIndex, float startTime) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        param->cancelScheduledValues(startTime);
    }
}


DART_EXPORT void AudioParam_setValueAtTime(int nodeIndex, int paramIndex,float value,float time) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        param->setValueAtTime(value,time);
    }
}

DART_EXPORT void AudioParam_exponentialRampToValueAtTime(int nodeIndex, int paramIndex,float value,float time) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        param->exponentialRampToValueAtTime(value,time);
    }
}

DART_EXPORT void AudioParam_linearRampToValueAtTime(int nodeIndex, int paramIndex, float value,float time) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        param->linearRampToValueAtTime(value,time);
    }
}

DART_EXPORT void AudioParam_setTargetAtTime(int nodeIndex, int paramIndex, float target, float time, float timeConstant) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        param->setTargetAtTime(target, time, timeConstant);
    }
}

DART_EXPORT float AudioParam_minValue(int nodeIndex, int paramIndex) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        return param->minValue();
    }else {
        return 0.0;
    }
}


DART_EXPORT float AudioParam_maxValue(int nodeIndex, int paramIndex) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        return param->maxValue();
    }else {
        return 0.0;
    }
}

DART_EXPORT float AudioParam_defaultValue(int nodeIndex, int paramIndex) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        return param->defaultValue();
    }else {
        return 0.0;
    }
}

DART_EXPORT void AudioParam_resetSmoothedValue(int nodeIndex, int paramIndex) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        param->resetSmoothedValue();
    }
}

DART_EXPORT void AudioParam_setSmoothingConstant(int nodeIndex, int paramIndex, double k) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        param->setSmoothingConstant(k);
    }
}

DART_EXPORT void AudioParam_hasSampleAccurateValues(int nodeIndex, int paramIndex) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        param->hasSampleAccurateValues();
    }
}

