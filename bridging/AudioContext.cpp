#include "dart_api/dart_api.h"
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

DART_EXPORT AudioContext* createRealtimeAudioContext(int channels,float sampleRate){
    AudioStreamConfig outputConfig = AudioStreamConfig();
    outputConfig.desired_channels = channels;
    outputConfig.desired_samplerate = sampleRate;
    auto context = MakeRealtimeAudioContext(outputConfig, AudioStreamConfig()).release();
    return context;
}

DART_EXPORT AudioContext* createOfflineAudioContext(int channels,float sampleRate,float timeMills){
    AudioStreamConfig offlineConfig = AudioStreamConfig();
    offlineConfig.desired_channels = channels;
    offlineConfig.desired_samplerate = sampleRate;
    offlineConfig.device_index = 0;
    auto context = MakeOfflineAudioContext(offlineConfig,timeMills).release();
    return context;
}

DART_EXPORT void AudioContext_startOfflineRendering(AudioContext* context,int recorderIndex,const char* file_path){
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

DART_EXPORT double AudioContext_currentTime(AudioContext* context){
    return context->currentTime();
}

DART_EXPORT double AudioContext_predictedCurrentTime(AudioContext* context){
    return context->predictedCurrentTime();
}

DART_EXPORT float AudioContext_sampleRate(AudioContext* context){
    return context->sampleRate();
}

DART_EXPORT int AudioContext_isInitialized(AudioContext* context){
    return context->isInitialized();
}

DART_EXPORT int AudioContext_isConnected(AudioContext* context, int destinationIndex, int sourceIndex){
    return context->isConnected(
        audioNodes.find(destinationIndex)->second,
        audioNodes.find(sourceIndex)->second
    );
}

DART_EXPORT int AudioContext_device(AudioContext* context){
    return keepNode(context->device());
}

DART_EXPORT void AudioContext_setDeviceNode(AudioContext* context, int nodeIndex){
    context->setDeviceNode(audioNodes.find(nodeIndex)->second);
}

DART_EXPORT int AudioContext_isOfflineContext(AudioContext* context){
    return context->isOfflineContext();
}

DART_EXPORT uint64_t AudioContext_currentSampleFrame(AudioContext* context){
    return context->currentSampleFrame();
}

DART_EXPORT void AudioContext_connect(AudioContext* context, int destination, int source, int destIdx = 0, int srcIdx = 0) {
    std::shared_ptr<AudioNode> dst;
    if(destination == -1){
        dst = context->device();
    }else{
        dst = audioNodes.find(destination)->second;
    }
    context->connect(dst,audioNodes.find(source)->second, destIdx, srcIdx);
}

DART_EXPORT void AudioContext_disconnect(AudioContext* context, int destination, int source, int destIdx = 0, int srcIdx = 0) {
    std::shared_ptr<AudioNode> dst;
    if(destination == -1){
        dst = context->device();
    }else{
        dst = audioNodes.find(destination)->second;
    }
    context->disconnect(dst,audioNodes.find(source)->second, destIdx, srcIdx);
}

// completely disconnect the node from the graph
DART_EXPORT void AudioContext_disconnect2(AudioContext* context, int node, int destIdx = 0) {
    context->disconnect(audioNodes.find(node)->second, destIdx);
}

DART_EXPORT void AudioContext_releaseContext(AudioContext* ctx) {
    delete ctx;
}