#define DART_CALL __attribute__((visibility("default"))) __attribute__((used))
#include "LabSound/LabSound.h"
using namespace lab;
#include "dart_api/dart_api.h"
#include "dart_api/dart_native_api.h"
#include "dart_api/dart_api_dl.h"

Dart_Port decodeAudioSendPort;


DART_EXPORT void RegisterDecodeAudioSendPort(Dart_Port sendPort) {
    decodeAudioSendPort = sendPort;
}

int bufferCount;
std::map<int,std::shared_ptr<AudioBus>> audioBuffers;

void decodeAudioDataRun(const int id, const char *file)
{
    std::shared_ptr<AudioBus> audioBus = MakeBusFromFile(file, false);
    audioBuffers.insert(std::pair<int,std::shared_ptr<AudioBus>>(id, audioBus));
	return;
}

DART_EXPORT int decodeAudioData(const char *file) {
    int busId = bufferCount++;
    std::thread makeBus(decodeAudioDataRun, busId, file);
    makeBus.join();
    return busId;
}

DART_EXPORT int decodeAudioDataAsync(const char *file) {
    int busId = bufferCount++;
    std::thread makeBus(decodeAudioDataRun, busId, file);
    makeBus.detach();
    return busId;
}

DART_EXPORT int decodeAudioDataHasCheck(int busIndex) {
    std::map<int,std::shared_ptr<AudioBus>>::iterator ite = audioBuffers.find(busIndex);
    if(ite != audioBuffers.end()){
        if(ite->second) {
            return 1;
        } else {
            return -1;
        }
    }
    return 0;
}

DART_EXPORT int AudioBus_numberOfChannels(int busIndex){
    return std::static_pointer_cast<AudioBus>(audioBuffers.find(busIndex)->second)->numberOfChannels();
}

DART_EXPORT int AudioBus_length(int busIndex){
    return std::static_pointer_cast<AudioBus>(audioBuffers.find(busIndex)->second)->length();
}

DART_EXPORT float AudioBus_sampleRate(int busIndex){
    return std::static_pointer_cast<AudioBus>(audioBuffers.find(busIndex)->second)->sampleRate();
}

DART_EXPORT void AudioBus_zero(int busIndex){
    std::static_pointer_cast<AudioBus>(audioBuffers.find(busIndex)->second)->numberOfChannels();
}

DART_EXPORT void AudioBus_clearSilentFlag(int busIndex){
    std::static_pointer_cast<AudioBus>(audioBuffers.find(busIndex)->second)->clearSilentFlag();
}

DART_EXPORT void AudioBus_scale(int busIndex, float scale){
    std::static_pointer_cast<AudioBus>(audioBuffers.find(busIndex)->second)->scale(scale);
}

DART_EXPORT void AudioBus_reset(int busIndex){
    std::static_pointer_cast<AudioBus>(audioBuffers.find(busIndex)->second)->reset();
}

DART_EXPORT int AudioBus_isSilent(int busIndex){
    return std::static_pointer_cast<AudioBus>(audioBuffers.find(busIndex)->second)->isSilent();
}

DART_EXPORT int AudioBus_isFirstTime(int busIndex){
    return std::static_pointer_cast<AudioBus>(audioBuffers.find(busIndex)->second)->isFirstTime();
}

DART_EXPORT void AudioBus_setSampleRate(int busIndex, float sampleRate){
    std::static_pointer_cast<AudioBus>(audioBuffers.find(busIndex)->second)->setSampleRate(sampleRate);
}

DART_EXPORT void releaseAudioBus(int index){
    audioBuffers.erase(index);
}
