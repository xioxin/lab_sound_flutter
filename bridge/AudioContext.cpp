#include "./dart_api/dart_api.h"
#include "LabSound/LabSound.h"
#include "KeepNode.cpp"
#include "Port.cpp"
using namespace lab;

DART_EXPORT AudioContext* createRealtimeAudioContext(AudioStreamConfig outputConfig, AudioStreamConfig inputConfig){
    auto context = MakeRealtimeAudioContext(outputConfig, inputConfig).release();
    return context;
}

DART_EXPORT AudioContext* createOfflineAudioContext(AudioStreamConfig outputConfig, double recordTimeMilliseconds){
    auto context = MakeOfflineAudioContext(outputConfig, recordTimeMilliseconds).release();
    return context;
}

int renderCount;
DART_EXPORT int AudioContext_startOfflineRendering(AudioContext* context){
    int renderId = renderCount++;
    context->offlineRenderCompleteCallback = [renderId]() {
        sendOfflineRenderComplete(renderId, 1);
    };
    context->startOfflineRendering();
    return renderId;
}

DART_EXPORT void AudioContext_addAutomaticPullNode(AudioContext* context, int nodeId){
    auto node = getNode(nodeId);
    if(node) context->addAutomaticPullNode(node);
}

DART_EXPORT void AudioContext_removeAutomaticPullNode(AudioContext* context, int nodeId){
    auto node = getNode(nodeId);
    if(node) context->removeAutomaticPullNode(node);
}

DART_EXPORT void AudioContext_processAutomaticPullNodes(AudioContext* context, int framesToProcess){
    ContextRenderLock r(context,"processAutomaticPullNodes");
    context->processAutomaticPullNodes(r, framesToProcess);
}

DART_EXPORT void AudioContext_handlePreRenderTasks(AudioContext* context, int framesToProcess){
    ContextRenderLock r(context,"handlePreRenderTasks");
    context->handlePreRenderTasks(r);
}
DART_EXPORT void AudioContext_handlePostRenderTasks(AudioContext* context, int framesToProcess){
    ContextRenderLock r(context,"handlePostRenderTasks");
    context->handlePostRenderTasks(r);
}

DART_EXPORT void AudioContext_synchronizeConnections(AudioContext* context, int timeOut_ms){
    context->synchronizeConnections(timeOut_ms);
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
DART_EXPORT void AudioContext_disconnectCompletely(AudioContext* context, int nodeId, int destIdx = 0) {
    auto node = getNode(nodeId);
    if(node) context->disconnect(node, destIdx);
}

// connect a parameter to receive the indexed output of a node
DART_EXPORT void  AudioContext_connectParam(AudioContext* context, int paramNodeId, int paramId, int driverNodeId, int index) {
    std::shared_ptr<AudioParam> param = getKeepAudioParam(paramNodeId, paramId);
    std::shared_ptr<AudioNode> driverNode = getNode(driverNodeId);
    if(param && driverNode) context->connectParam(param, driverNode, index);
}

// connect destinationNode's named parameter input to driver's indexed output
DART_EXPORT void  AudioContext_connectParamByName(AudioContext* context, int destinationNodeId, char const*const parameterName, int driverNodeId, int index) {
    std::shared_ptr<AudioNode> destinationNode = getNode(destinationNodeId);
    std::shared_ptr<AudioNode> driverNode = getNode(driverNodeId);
    if(destinationNode && driverNode) context->connectParam(destinationNode, parameterName, driverNode, index);
}

// disconnect a parameter from the indexed output of a node
DART_EXPORT void  AudioContext_disconnectParam(AudioContext* context, int paramNodeId, int paramId, int driverNodeId, int index) {
  std::shared_ptr<AudioParam> param = getKeepAudioParam(paramNodeId, paramId);
    std::shared_ptr<AudioNode> driverNode = getNode(driverNodeId);
    if(param && driverNode) context->disconnectParam(param, driverNode, index);
}

DART_EXPORT int AudioContext_makeAudioHardwareInputNode(AudioContext* context) {
    ContextRenderLock r(context, "MakeAudioHardwareInputNode");
    return keepNode(lab::MakeAudioHardwareInputNode(r));
}

DART_EXPORT void AudioContext_releaseContext(AudioContext* ctx) {
    int devId = keepNode(ctx->device());
    keepNodeRelease(devId);
    delete ctx;
}