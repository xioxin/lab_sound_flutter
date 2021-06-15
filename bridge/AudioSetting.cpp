#include "./dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
using namespace lab;

DART_EXPORT const char * AudioSetting_name(int nodeId, int settingIndex) {
    auto setting = getKeepAudioSetting(nodeId, settingIndex);
    if(setting) {
        return setting->name().c_str();
    }
    return "";
}
DART_EXPORT const char * AudioSetting_shortName(int nodeId, int settingIndex) {
    auto setting = getKeepAudioSetting(nodeId, settingIndex);
    if(setting) {
        return setting->shortName().c_str();
    }
    return "";
}
DART_EXPORT int AudioSetting_type(int nodeId, int settingIndex) {
    auto setting = getKeepAudioSetting(nodeId, settingIndex);
    if(setting) {
        return static_cast<int>(setting->type());
    }
    return 0;
}
DART_EXPORT int AudioSetting_valueBool(int nodeId, int settingIndex) {
    auto setting = getKeepAudioSetting(nodeId, settingIndex);
    if(setting) {
        return setting->valueBool();
    }
    return 0;
}
DART_EXPORT float AudioSetting_valueFloat(int nodeId, int settingIndex) {
    auto setting = getKeepAudioSetting(nodeId, settingIndex);
    if(setting) {
        return setting->valueFloat();
    }
    return 0.0;
}
DART_EXPORT uint32_t AudioSetting_valueUint32(int nodeId, int settingIndex) {
    auto setting = getKeepAudioSetting(nodeId, settingIndex);
    if(setting) {
        return setting->valueUint32();
    }
    return 0;
}
DART_EXPORT int AudioSetting_valueBus(int nodeId, int settingIndex) {
    auto setting = getKeepAudioSetting(nodeId, settingIndex);
    if(setting) {
        return keepBus(setting->valueBus());
    }
    return -1;
}


DART_EXPORT void AudioSetting_setBool(int nodeId, int settingIndex, int v, int notify) {
    auto setting = getKeepAudioSetting(nodeId, settingIndex);
    if(setting) {
        setting->setBool(v > 0, notify > 0);
    }
}

DART_EXPORT void AudioSetting_setFloat(int nodeId, int settingIndex, float v, int notify) {
    auto setting = getKeepAudioSetting(nodeId, settingIndex);
    if(setting) {
        setting->setFloat(v, notify > 0);
    }
}

DART_EXPORT void AudioSetting_setUint32(int nodeId, int settingIndex, uint32_t v, int notify) {
    auto setting = getKeepAudioSetting(nodeId, settingIndex);
    if(setting) {
        setting->setUint32(v, notify > 0);
    }
}

DART_EXPORT void AudioSetting_setEnumeration(int nodeId, int settingIndex, int v, int notify) {
    auto setting = getKeepAudioSetting(nodeId, settingIndex);
    if(setting) {
        setting->setEnumeration(v, notify > 0);
    }
}

DART_EXPORT void AudioSetting_setString(int nodeId, int settingIndex, char const*const v, int notify) {
    auto setting = getKeepAudioSetting(nodeId, settingIndex);
    if(setting) {
        setting->setString(v , notify > 0);
    }
}