#ifndef PORT_CPP
#define PORT_CPP

#include "dart_api/dart_api.h"
#include "dart_api/dart_native_api.h"
#include "dart_api/dart_api_dl.h"


// Initialize `dart_api_dl.h`
DART_EXPORT intptr_t InitDartApiDL(void* data) {
  return Dart_InitializeApiDL(data);
}

Dart_Port decodeAudioSendPort;

DART_EXPORT void registerDecodeAudioSendPort(Dart_Port sendPort) {
    decodeAudioSendPort = sendPort;
}

void sendAudioAusStatus(int busId, int status) {
    if(!decodeAudioSendPort) return;

    Dart_CObject dart_busId;
    dart_busId.type = Dart_CObject_kInt32;
    dart_busId.value.as_int32 = busId;

    Dart_CObject dart_status;
    dart_status.type = Dart_CObject_kInt32;
    dart_status.value.as_int32 = status;

    Dart_CObject* c_request_arr[] = {&dart_busId, &dart_status};

    Dart_CObject dart_object;
    dart_object.type = Dart_CObject_kArray;
    dart_object.value.as_array.values = c_request_arr;
    dart_object.value.as_array.length = 2;
    Dart_PostCObject_DL(decodeAudioSendPort, &dart_object);
}


#endif