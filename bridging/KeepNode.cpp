#ifndef KEEP_NODE_CPP
#define KEEP_NODE_CPP

std::map<int, std::map<int, std::shared_ptr<AudioParam>>> audioParams;

std::shared_ptr<AudioParam> getKeepAudioParam(int nodeIndex, int key) {
    std::map<int, std::map<int, std::shared_ptr<AudioParam>>>::iterator ite = audioParams.find(nodeIndex);
    if (ite != audioParams.end()) {
       std::map<int, std::shared_ptr<AudioParam>>::iterator ite2 = ite->second.find(key);
       if(ite2 != ite->second.end()) {
           return ite2->second;
       }
    }
    return nullptr;
}

int keepAudioParam(int nodeIndex, int key, std::shared_ptr<AudioParam> audioParam){
    std::map<int, std::map<int, std::shared_ptr<AudioParam>>>::iterator ite = audioParams.find(nodeIndex);
    if (ite != audioParams.end()) {
        ite->second.insert(std::pair<int,std::shared_ptr<AudioParam>>(key, audioParam));
    }else {
        std::map<int, std::shared_ptr<AudioParam>> temp;
        temp.insert(std::pair<int,std::shared_ptr<AudioParam>>(key, audioParam));
        audioParams.insert(std::pair<int, std::map<int, std::shared_ptr<AudioParam>>>(nodeIndex, temp));
    }
    return key;
}


int nodeCount;
std::map<int,std::shared_ptr<AudioNode>> audioNodes;
int keepNode(std::shared_ptr<AudioNode> node){
    nodeCount++;
    audioNodes.insert(std::pair<int,std::shared_ptr<AudioNode>>(nodeCount,node));
    return nodeCount;
}

#endif