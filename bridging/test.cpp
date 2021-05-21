// #include <stdio.h>
// #include <unistd.h>
// #include <pthread.h>






// typedef void (*VoidCallbackFunc)();

// void *thread_func(void *args) {
//     printf("thread_func Running on (%p)\n", pthread_self());
//     sleep(1 /* seconds */); // doing something

//     Dart_CObject dart_object;
//     dart_object.type = Dart_CObject_kInt64;
//     dart_object.value.as_int64 = reinterpret_cast<intptr_t>(args);
//     Dart_PostCObject_DL(send_port_, &dart_object);

//     pthread_exit(args);
// }

// DART_EXPORT void NativeAsyncCallback(VoidCallbackFunc callback) {
//     printf("NativeAsyncCallback Running on (%p)\n", pthread_self());
    
//     pthread_t callback_thread;
//     pthread_create(&callback_thread, NULL, thread_func, (void *)callback);
// }

// DART_EXPORT void ExecuteCallback(VoidCallbackFunc callback) {
//     printf("ExecuteCallback Running on (%p)\n", pthread_self());
//     callback();
// }