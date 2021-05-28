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



// suspend the progression of time in the audio context, any queued samples will play
DART_EXPORT void AudioContext_suspend(AudioContext* context) {
    context->suspend();
}

// if the context was suspended, resume the progression of time and processing in the audio context
DART_EXPORT void AudioContext_resume(AudioContext* context) {
    context->resume();
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

DART_EXPORT int AudioContext_isConnected(AudioContext* context, int destination, int source){
    std::shared_ptr<AudioNode> destinationNode = getNode(destination);
    std::shared_ptr<AudioNode> sourceNode = getNode(source);
    return sourceNode && destinationNode ? context->isConnected(
        destinationNode,
        sourceNode
    ) : 0;
}

DART_EXPORT int AudioContext_device(AudioContext* context){
    return keepNode(context->device());
}

DART_EXPORT void AudioContext_setDeviceNode(AudioContext* context, int nodeId){
    auto node = getNode(nodeId);
    if(node) context->setDeviceNode(node);
}

DART_EXPORT int AudioContext_isOfflineContext(AudioContext* context){
    return context->isOfflineContext();
}

DART_EXPORT uint64_t AudioContext_currentSampleFrame(AudioContext* context){
    return context->currentSampleFrame();
}

DART_EXPORT void AudioContext_connect(AudioContext* context, int destination, int source, int destIdx = 0, int srcIdx = 0) {
    std::shared_ptr<AudioNode> destinationNode = getNode(destination);
    std::shared_ptr<AudioNode> sourceNode = getNode(source);
    if(destinationNode && sourceNode) context->connect(destinationNode, sourceNode, destIdx, srcIdx);
}

DART_EXPORT void AudioContext_disconnect(AudioContext* context, int destination, int source, int destIdx = 0, int srcIdx = 0) {
    std::shared_ptr<AudioNode> destinationNode = getNode(destination);
    std::shared_ptr<AudioNode> sourceNode = getNode(source);
    sourceNode = getNode(source);
    if(destinationNode && sourceNode) context->disconnect(destinationNode, sourceNode, destIdx, srcIdx);
}

// completely disconnect the node from the graph
DART_EXPORT void AudioContext_disconnect2(AudioContext* context, int nodeId, int destIdx = 0) {
    auto node = getNode(nodeId);
    if(node) context->disconnect(node, destIdx);
}

DART_EXPORT void AudioContext_releaseContext(AudioContext* ctx) {
    int devId = keepNode(ctx->device());
    keepNodeRelease(devId);
    delete ctx;
}