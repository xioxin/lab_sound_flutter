#ifndef BRIDGING_STRUCT_H
#define BRIDGING_STRUCT_H

#include "stdint.h"
#include "string.h"

typedef struct CharArray
{
	char* string;
	int len;
} CharArray;

typedef struct FloatArray
{
	float* array;
	int len;
} FloatArray;

typedef struct IntArray
{
	int* array;
	int len;
} IntArray;

typedef struct AudioDeviceInfoBridge
{
    int index;
    char*  identifier;
    int  identifier_len;
    int num_output_channels;
    int num_input_channels;
    FloatArray supported_samplerates;
    float nominal_samplerate;
    int is_default_output;
    int is_default_input;
} AudioDeviceInfoBridge;

typedef struct AudioDeviceInfoList {
    AudioDeviceInfoBridge* audioDeviceList;
    int length;
} AudioDeviceInfoList;

#endif

