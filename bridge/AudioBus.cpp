#include "./dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "Port.cpp"

using namespace lab;


int bufferCount;
std::map<int,std::shared_ptr<AudioBus>> audioBuffers;

std::shared_ptr<AudioBus> getBus(int busId) {
    std::map<int,std::shared_ptr<AudioBus>>::iterator ite = audioBuffers.find(busId);
    if (ite != audioBuffers.end()) {
        return ite->second;
    }
    return nullptr;
}

int keepBus(std::shared_ptr<AudioBus> audioBus) {
    int busId = bufferCount++;
    audioBuffers.insert(std::pair<int,std::shared_ptr<AudioBus>>(busId, audioBus));
    return busId;
}

void decodeAudioDataRun(const int id, const char *file)
{
    std::shared_ptr<AudioBus> audioBus = MakeBusFromFile(file, false);
    audioBuffers.insert(std::pair<int,std::shared_ptr<AudioBus>>(id, audioBus));
    sendAudioAusStatus(id, 1);
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

DART_EXPORT int decodeAudioDataHasCheck(int busId) {
    std::map<int,std::shared_ptr<AudioBus>>::iterator ite = audioBuffers.find(busId);
    if(ite != audioBuffers.end()){
        if(ite->second) {
            return 1;
        } else {
            return -1;
        }
    }
    return 0;
}

DART_EXPORT int AudioBus_numberOfChannels(int busId){
    auto bus = getBus(busId);
    return bus ? bus->numberOfChannels() : 0;
}

DART_EXPORT int AudioBus_length(int busId){
    auto bus = getBus(busId);
    return bus ? bus->length() : 0;
}

DART_EXPORT float AudioBus_sampleRate(int busId){
    auto bus = getBus(busId);
    return bus ? bus->sampleRate() : 0.;
}

DART_EXPORT void AudioBus_zero(int busId){
    auto bus = getBus(busId);
    if(bus)bus->zero();
}

DART_EXPORT void AudioBus_setChannelMemory(int busId, int channelIndex, float * storage, int length){
    auto bus = getBus(busId);
    if(bus)bus->setChannelMemory(channelIndex, storage, length);
}

DART_EXPORT void AudioBus_resizeSmaller(int busId, int newLength){
    auto bus = getBus(busId);
    if(bus)bus->resizeSmaller(newLength);
}

DART_EXPORT void AudioBus_clearSilentFlag(int busId){
    auto bus = getBus(busId);
    if(bus)bus->clearSilentFlag();
}

DART_EXPORT void AudioBus_scale(int busId, float scale){
    auto bus = getBus(busId);
    if(bus)bus->scale(scale);
}

DART_EXPORT void AudioBus_reset(int busId){
    auto bus = getBus(busId);
    if(bus) bus->reset();
}

DART_EXPORT int AudioBus_isSilent(int busId){
    auto bus = getBus(busId);
    return bus ? bus->isSilent() : 0;
}

DART_EXPORT int AudioBus_isFirstTime(int busId){
    auto bus = getBus(busId);
    return bus ? bus->isFirstTime() : 0;
}

DART_EXPORT void AudioBus_setSampleRate(int busId, float sampleRate){
    auto bus = getBus(busId);
    if(bus) bus->setSampleRate(sampleRate);
}

DART_EXPORT void releaseAudioBus(int index){
    audioBuffers.erase(index);
    // sendAudioAusStatus(index, -1);
}