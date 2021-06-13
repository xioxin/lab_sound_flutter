#include "LabSound/LabSound.h"
#include <thread>

#include "struct.h"

#include "Port.cpp"
#include "test.cpp"
#include "KeepNode.cpp"
#include "AudioBus.cpp"
#include "AudioContext.cpp"
#include "AudioNode.cpp"
#include "AudioScheduledSourceNode.cpp"
#include "AudioParam.cpp"
#include "GainNode.cpp"
#include "RecorderNode.cpp"
#include "SampledAudioNode.cpp"
#include "AnalyserNode.cpp"
#include "OscillatorNode.cpp"
#include "BiquadFilterNode.cpp"
#include "PannerNode.cpp"

#include "ChannelMergerNode.cpp"
#include "ChannelSplitterNode.cpp"

#include "AudioHardwareDeviceNode.cpp"
#include "DynamicsCompressorNode.cpp"

#include "NoiseNode.cpp"
#include "WaveShaperNode.cpp"
#include "PolyBLEPNode.cpp"


using namespace lab;

DART_EXPORT void labTest() {

}


DART_EXPORT AudioDeviceInfoList labSoundMakeAudioDeviceList() {
    const std::vector<AudioDeviceInfo> audioDevices = MakeAudioDeviceList();
    AudioDeviceInfoBridge* devices = (AudioDeviceInfoBridge*)malloc(sizeof(AudioDeviceInfoBridge)*audioDevices.size());
    for (int i = 0; i < audioDevices.size(); ++i)
	{
		devices[i].index = audioDevices[i].index;
		devices[i].identifier = const_cast<char*>(audioDevices[i].identifier.c_str());
        devices[i].identifier_len = sizeof(devices[i].identifier);
		devices[i].num_output_channels = audioDevices[i].num_output_channels;
		devices[i].num_input_channels = audioDevices[i].num_input_channels;
		devices[i].nominal_samplerate = audioDevices[i].nominal_samplerate;
		devices[i].is_default_output = audioDevices[i].is_default_output;
		devices[i].is_default_input = audioDevices[i].is_default_input;
        if (!audioDevices[i].supported_samplerates.empty())
        {
            float* supported_samplerates = (float*)malloc(sizeof(float)*audioDevices[i].supported_samplerates.size());
            memcpy(supported_samplerates, &audioDevices[i].supported_samplerates[0], audioDevices[i].supported_samplerates.size() * sizeof(float));
            devices[i].supported_samplerates.array = supported_samplerates;
            devices[i].supported_samplerates.len = audioDevices[i].supported_samplerates.size();
        }
	}

    AudioDeviceInfoList deviceList;
    deviceList.audioDeviceList = devices;
    deviceList.length = audioDevices.size();
    return deviceList;
}