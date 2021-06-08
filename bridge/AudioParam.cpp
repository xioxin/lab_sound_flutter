#include "./dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
using namespace lab;

DART_EXPORT float AudioParam_value(int nodeId, int paramIndex) {
    auto param = getKeepAudioParam(nodeId, paramIndex);
    if(param) {
        return param->value();
    }
    return 0.0;
}

DART_EXPORT void AudioParam_setValue(int nodeId, int paramIndex, float value) {
    auto param = getKeepAudioParam(nodeId, paramIndex);
    if(param) {
        param->setValue(value);
    } else {
    }
}

DART_EXPORT float AudioParam_finalValue(int nodeId, int paramIndex, AudioContext* context) {
    auto param = getKeepAudioParam(nodeId, paramIndex);
    if(param) {
        ContextRenderLock r(context,"finalValue");
        return param->finalValue(r);
    }
    return 0.0;
}

DART_EXPORT void AudioParam_setValueCurveAtTime(int nodeId, int paramIndex, float curve[],float time,float duration) {
    auto param = getKeepAudioParam(nodeId, paramIndex);
    if(param) {
        std::vector<float> curveVec;
        int length = sizeof(&curve)/sizeof(curve[0]);
        for(int i=0;i<length;i++){
            curveVec.push_back(curve[i]);
        }
        param->setValueCurveAtTime(curveVec,time,duration);
    }
}

DART_EXPORT void AudioParam_cancelScheduledValues(int nodeId, int paramIndex, float startTime) {
    auto param = getKeepAudioParam(nodeId, paramIndex);
    if(param) {
        param->cancelScheduledValues(startTime);
    }
}


DART_EXPORT void AudioParam_setValueAtTime(int nodeId, int paramIndex,float value,float time) {
    auto param = getKeepAudioParam(nodeId, paramIndex);
    if(param) {
        param->setValueAtTime(value,time);
    }
}

DART_EXPORT void AudioParam_exponentialRampToValueAtTime(int nodeId, int paramIndex,float value,float time) {
    auto param = getKeepAudioParam(nodeId, paramIndex);
    if(param) {
        param->exponentialRampToValueAtTime(value,time);
    }
}

DART_EXPORT void AudioParam_linearRampToValueAtTime(int nodeId, int paramIndex, float value,float time) {
    auto param = getKeepAudioParam(nodeId, paramIndex);
    if(param) {
        param->linearRampToValueAtTime(value,time);
    }
}

DART_EXPORT void AudioParam_setTargetAtTime(int nodeId, int paramIndex, float target, float time, float timeConstant) {
    auto param = getKeepAudioParam(nodeId, paramIndex);
    if(param) {
        param->setTargetAtTime(target, time, timeConstant);
    }
}

DART_EXPORT float AudioParam_minValue(int nodeId, int paramIndex) {
    auto param = getKeepAudioParam(nodeId, paramIndex);
    if(param) {
        return param->minValue();
    }else {
        return 0.0;
    }
}


DART_EXPORT float AudioParam_maxValue(int nodeId, int paramIndex) {
    auto param = getKeepAudioParam(nodeId, paramIndex);
    if(param) {
        return param->maxValue();
    }else {
        return 0.0;
    }
}

DART_EXPORT float AudioParam_defaultValue(int nodeId, int paramIndex) {
    auto param = getKeepAudioParam(nodeId, paramIndex);
    if(param) {
        return param->defaultValue();
    }else {
        return 0.0;
    }
}

DART_EXPORT void AudioParam_resetSmoothedValue(int nodeId, int paramIndex) {
    auto param = getKeepAudioParam(nodeId, paramIndex);
    if(param) {
        param->resetSmoothedValue();
    }
}

DART_EXPORT void AudioParam_setSmoothingConstant(int nodeId, int paramIndex, double k) {
    auto param = getKeepAudioParam(nodeId, paramIndex);
    if(param) {
        param->setSmoothingConstant(k);
    }
}

DART_EXPORT void AudioParam_hasSampleAccurateValues(int nodeId, int paramIndex) {
    auto param = getKeepAudioParam(nodeId, paramIndex);
    if(param) {
        param->hasSampleAccurateValues();
    }
}

