#ifndef KEEP_NODE_CPP
#define KEEP_NODE_CPP

#include "LabSound/LabSound.h"
using namespace lab;


std::map<int, std::map<int, std::shared_ptr<AudioParam>>> audioParams;

std::shared_ptr<AudioParam> getKeepAudioParam(int nodeId, int key) {
    std::map<int, std::map<int, std::shared_ptr<AudioParam>>>::iterator ite = audioParams.find(nodeId);
    if (ite != audioParams.end()) {
       std::map<int, std::shared_ptr<AudioParam>>::iterator ite2 = ite->second.find(key);
       if(ite2 != ite->second.end()) {
           return ite2->second;
       }
    }
    return nullptr;
}

int keepAudioParam(int nodeId, int key, std::shared_ptr<AudioParam> audioParam){
    std::map<int, std::map<int, std::shared_ptr<AudioParam>>>::iterator ite = audioParams.find(nodeId);
    if (ite != audioParams.end()) {
        ite->second.insert(std::pair<int,std::shared_ptr<AudioParam>>(key, audioParam));
    }else {
        std::map<int, std::shared_ptr<AudioParam>> temp;
        temp.insert(std::pair<int,std::shared_ptr<AudioParam>>(key, audioParam));
        audioParams.insert(std::pair<int, std::map<int, std::shared_ptr<AudioParam>>>(nodeId, temp));
    }
    return key;
}

int nodeCount;
std::map<int,std::shared_ptr<AudioNode>> audioNodes;
std::map<std::shared_ptr<AudioNode>,int> audioNodeIdMap;

int keepNode(std::shared_ptr<AudioNode> node){
    std::map<std::shared_ptr<AudioNode>,int>::iterator ite = audioNodeIdMap.find(node);
    if (ite != audioNodeIdMap.end()) {
        return ite->second;
    }
    nodeCount++;
    audioNodes.insert(std::pair<int,std::shared_ptr<AudioNode>>(nodeCount,node));
    audioNodeIdMap.insert(std::pair<std::shared_ptr<AudioNode>,int>(node,nodeCount));
    return nodeCount;
}

std::shared_ptr<AudioNode> getNode(int nodeId) {
    std::map<int,std::shared_ptr<AudioNode>>::iterator ite = audioNodes.find(nodeId);
    if (ite != audioNodes.end()) {
        return ite->second;
    }
    return nullptr;
}

void keepNodeRelease(int nodeId) {
    std::map<int,std::shared_ptr<AudioNode>>::iterator ite = audioNodes.find(nodeId);
    if (ite != audioNodes.end()) {
        audioNodeIdMap.erase(ite->second);
    }
    audioNodes.erase(nodeId);
    audioParams.erase(nodeId);
}

#endif