#define DART_CALL __attribute__((visibility("default"))) __attribute__((used))
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
using namespace lab;

class BoolData{
private:
    bool data = false;
public:
    bool value(){
        return data;
    }
    void setValue(bool v){
        data = v;
    }
};

extern "C" DART_CALL
AudioContext* createRealtimeAudioContext(int channels,float sampleRate){
    AudioStreamConfig outputConfig = AudioStreamConfig();
    outputConfig.desired_channels = channels;
    outputConfig.desired_samplerate = sampleRate;
    auto context = MakeRealtimeAudioContext(outputConfig, AudioStreamConfig()).release();
    return context;
}

extern "C" DART_CALL
AudioContext* createOfflineAudioContext(int channels,float sampleRate,float timeMills){
    AudioStreamConfig offlineConfig = AudioStreamConfig();
    offlineConfig.desired_channels = channels;
    offlineConfig.desired_samplerate = sampleRate;
    offlineConfig.device_index = 0;
    auto context = MakeOfflineAudioContext(offlineConfig,timeMills).release();
    return context;
}

extern "C" DART_CALL
void AudioContext_startOfflineRendering(AudioContext* context,int recorderIndex,const char* file_path){
    RecorderNode* recorder = static_cast<RecorderNode*>(audioNodes.find(recorderIndex)->second.get());
    recorder->startRecording();

    BoolData* renderComplete = new BoolData();
    context->offlineRenderCompleteCallback = [recorderIndex,&context, &recorder,file_path,renderComplete]() {
        recorder->stopRecording();
        context->removeAutomaticPullNode(audioNodes.find(recorderIndex)->second);
        recorder->writeRecordingToWav(file_path, false);
        renderComplete->setValue(true);
    };

    context->startOfflineRendering();
    // ((NullDeviceNode*)context->device().get())->joinRenderThread();
}

extern "C" DART_CALL
double AudioContext_currentTime(AudioContext* context){
    return context->currentTime();
}

extern "C" DART_CALL
double AudioContext_predictedCurrentTime(AudioContext* context){
    return context->predictedCurrentTime();
}

extern "C" DART_CALL
float AudioContext_sampleRate(AudioContext* context){
    return context->sampleRate();
}

extern "C" DART_CALL
int AudioContext_isInitialized(AudioContext* context){
    return context->isInitialized();
}

extern "C" DART_CALL
int AudioContext_isConnected(AudioContext* context, int destinationIndex, int sourceIndex){
    return context->isConnected(
        audioNodes.find(destinationIndex)->second,
        audioNodes.find(sourceIndex)->second
    );
}

extern "C" DART_CALL
void AudioContext_setDeviceNode(AudioContext* context, int nodeIndex){
    context->setDeviceNode(audioNodes.find(nodeIndex)->second);
}

extern "C" DART_CALL
int AudioContext_isOfflineContext(AudioContext* context){
    return context->isOfflineContext();
}

extern "C" DART_CALL
uint64_t AudioContext_currentSampleFrame(AudioContext* context){
    return context->currentSampleFrame();
}

extern "C" DART_CALL
void AudioContext_connect(AudioContext* context, int destination, int source) {
    std::shared_ptr<AudioNode> dst;
    if(destination == -1){
        dst = context->device();
    }else{
        dst = audioNodes.find(destination)->second;
    }
    context->connect(dst,audioNodes.find(source)->second,0,0);
}

extern "C" DART_CALL
void AudioContext_disconnect(AudioContext* context, int destination, int source) {
    std::shared_ptr<AudioNode> dst;
    if(destination == -1){
        dst = context->device();
    }else{
        dst = audioNodes.find(destination)->second;
    }
    context->disconnect(dst,audioNodes.find(source)->second,0,0);
}

extern "C" DART_CALL
void AudioContext_resetDevice(AudioContext* context){
    ContextRenderLock r(context, "reset");
    context->device()->reset(r);
}

extern "C" DART_CALL
void AudioContext_releaseContext(AudioContext* ctx) {
    delete ctx;
}