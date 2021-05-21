#define DART_CALL __attribute__((visibility("default"))) __attribute__((used))
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
using namespace lab;

extern "C" DART_CALL
float AudioParam_value(int nodeIndex, int paramIndex) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        return param->value();
    }
    return 0.0;
}

extern "C" DART_CALL
void AudioParam_setValue(int nodeIndex, int paramIndex, float value) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        param->setValue(value);
    } else {
    }
}

extern "C" DART_CALL
void AudioParam_setValueCurveAtTime(int nodeIndex, int paramIndex, float curve[],float time,float duration) {
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

extern "C" DART_CALL
void AudioParam_cancelScheduledValues(int nodeIndex, int paramIndex, float startTime) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        param->cancelScheduledValues(startTime);
    }
}


extern "C" DART_CALL
void AudioParam_setValueAtTime(int nodeIndex, int paramIndex,float value,float time) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        param->setValueAtTime(value,time);
    }
}

extern "C" DART_CALL
void AudioParam_exponentialRampToValueAtTime(int nodeIndex, int paramIndex,float value,float time) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        param->exponentialRampToValueAtTime(value,time);
    }
}

extern "C" DART_CALL
void AudioParam_linearRampToValueAtTime(int nodeIndex, int paramIndex, float value,float time) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        param->linearRampToValueAtTime(value,time);
    }
}

extern "C" DART_CALL
void AudioParam_setTargetAtTime(int nodeIndex, int paramIndex, float target, float time, float timeConstant) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        param->setTargetAtTime(target, time, timeConstant);
    }
}

extern "C" DART_CALL
float AudioParam_minValue(int nodeIndex, int paramIndex) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        return param->minValue();
    }else {
        return 0.0;
    }
}

extern "C" DART_CALL
void AudioParam_resetSmoothedValue(int nodeIndex, int paramIndex) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        param->resetSmoothedValue();
    }
}

extern "C" DART_CALL
void AudioParam_setSmoothingConstant(int nodeIndex, int paramIndex, double k) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        param->setSmoothingConstant(k);
    }
}

extern "C" DART_CALL
void AudioParam_hasSampleAccurateValues(int nodeIndex, int paramIndex) {
    auto param = getKeepAudioParam(nodeIndex, paramIndex);
    if(param) {
        param->hasSampleAccurateValues();
    }
}

