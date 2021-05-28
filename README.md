# lab_sound_flutter

A new flutter plugin project.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

```shell script
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Build fingerprint: 'google/coral/coral:S/SPP1.210122.020.A3/7145137:user/release-keys'
Revision: 'MP1.0'
ABI: 'arm64'
Timestamp: 2021-05-28 10:55:42.955335038+0800
pid: 3955, tid: 4022, name: 1.ui  >>> com.example.lab_sound_flutter_example <<<
uid: 10278
signal 6 (SIGABRT), code -1 (SI_QUEUE), fault addr --------
Abort message: 'FORTIFY: pthread_mutex_lock called on a destroyed mutex (0x786915e5e0)'
    x0  0000000000000000  x1  0000000000000fb6  x2  0000000000000006  x3  000000788ba04a10
    x4  0000000000008080  x5  0000000000008080  x6  0000000000008080  x7  8080000000000000
    x8  00000000000000f0  x9  846f1911353549e7  x10 0000000000000000  x11 ffffff80fffffbdf
    x12 0000000000000001  x13 00001f46092a46fe  x14 00357734483f14e9  x15 0000000000000078
    x16 0000007bb56ed050  x17 0000007bb56c8010  x18 000000788ae9a000  x19 0000000000000f73
    x20 0000000000000fb6  x21 00000000ffffffff  x22 000000787ce88041  x23 000000788e496548
    x24 000000787ce88041  x25 000000788b931000  x26 b400007a4ea62920  x27 00000078f3ceea70
    x28 0000000000000004  x29 000000788ba04a90
    lr  0000007bb567bb08  sp  000000788ba049f0  pc  0000007bb567bb34  pst 0000000000000000
backtrace:
      #00 pc 000000000004fb34  libc.so (abort+164) (BuildId: 8b16fe3e93f719689cd94a44cb4bcce4)
      #01 pc 0000000000051c00  libc.so (__fortify_fatal(char const*, ...)+124) (BuildId: 8b16fe3e93f719689cd94a44cb4bcce4)
      #02 pc 00000000000b26e0  libc.so (HandleUsingDestroyedMutex(pthread_mutex_t*, char const*)+60) (BuildId: 8b16fe3e93f719689cd94a44cb4bcce4)
      #03 pc 00000000000b2518  libc.so (pthread_mutex_lock+156) (BuildId: 8b16fe3e93f719689cd94a44cb4bcce4)
      #04 pc 000000000027f7a8  libLabSound_d.so (BuildId: b642cf5b7307407efa85f101faa54e117eb119e5)
      #05 pc 000000000027f784  libLabSound_d.so (ma_mutex_lock+72) (BuildId: b642cf5b7307407efa85f101faa54e117eb119e5)
      #06 pc 00000000002821f0  libLabSound_d.so (ma_context_get_device_info+384) (BuildId: b642cf5b7307407efa85f101faa54e117eb119e5)
      #07 pc 000000000028355c  libLabSound_d.so (ma_device_init+3660) (BuildId: b642cf5b7307407efa85f101faa54e117eb119e5)
      #08 pc 00000000002a459c  libLabSound_d.so (lab::AudioDevice_Miniaudio::AudioDevice_Miniaudio(lab::AudioDeviceRenderCallback&, lab::AudioStreamConfig, lab::AudioStreamConfig)+408) (BuildId: b642cf5b7307407efa85f101faa54e117eb119e5)
      #09 pc 00000000002a43ac  libLabSound_d.so (lab::AudioDevice::MakePlatformSpecificDevice(lab::AudioDeviceRenderCallback&, lab::AudioStreamConfig, lab::AudioStreamConfig)+200) (BuildId: b642cf5b7307407efa85f101faa54e117eb119e5)
      #10 pc 00000000001aebec  libLabSound_d.so (lab::AudioHardwareDeviceNode::AudioHardwareDeviceNode(lab::AudioContext&, lab::AudioStreamConfig, lab::AudioStreamConfig)+444) (BuildId: b642cf5b7307407efa85f101faa54e117eb119e5)
      #11 pc 00000000002347e8  libLabSound_d.so (std::__ndk1::__compressed_pair_elem<lab::AudioHardwareDeviceNode, 1, false>::__compressed_pair_elem<lab::AudioContext&, lab::AudioStreamConfig const&, lab::AudioStreamConfig const&, 0ul, 1ul, 2ul>(std::__ndk1::piecewise_construct_t, std::__ndk1::tuple<lab::AudioContext&, lab::AudioStreamConfig const&, lab::AudioStreamConfig const&>, std::__ndk1::__tuple_indices<0ul, 1ul, 2ul>)+184) (BuildId: b642cf5b7307407efa85f101faa54e117eb119e5)
      #12 pc 00000000002342c0  libLabSound_d.so (std::__ndk1::__compressed_pair<std::__ndk1::allocator<lab::AudioHardwareDeviceNode>, lab::AudioHardwareDeviceNode>::__compressed_pair<std::__ndk1::allocator<lab::AudioHardwareDeviceNode>&, lab::AudioContext&, lab::AudioStreamConfig const&, lab::AudioStreamConfig const&>(std::__ndk1::piecewise_construct_t, std::__ndk1::tuple<std::__ndk1::allocator<lab::AudioHardwareDeviceNode>&>, std::__ndk1::tuple<lab::AudioContext&, lab::AudioStreamConfig const&, lab::AudioStreamConfig const&>)+128) (BuildId: b642cf5b7307407efa85f101faa54e117eb119e5)
      #13 pc 0000000000233e60  libLabSound_d.so (std::__ndk1::__shared_ptr_emplace<lab::AudioHardwareDeviceNode, std::__ndk1::allocator<lab::AudioHardwareDeviceNode> >::__shared_ptr_emplace<lab::AudioContext&, lab::AudioStreamConfig const&, lab::AudioStreamConfig const&>(std::__ndk1::allocator<lab::AudioHardwareDeviceNode>, lab::AudioContext&, lab::AudioStreamConfig const&, lab::AudioStreamConfig const&)+200) (BuildId: b642cf5b7307407efa85f101faa54e117eb119e5)
      #14 pc 0000000000233b60  libLabSound_d.so (std::__ndk1::shared_ptr<lab::AudioHardwareDeviceNode> std::__ndk1::shared_ptr<lab::AudioHardwareDeviceNode>::make_shared<lab::AudioContext&, lab::AudioStreamConfig const&, lab::AudioStreamConfig const&>(lab::AudioContext&, lab::AudioStreamConfig const&, lab::AudioStreamConfig const&)+252) (BuildId: b642cf5b7307407efa85f101faa54e117eb119e5)
      #15 pc 000000000023231c  libLabSound_d.so (BuildId: b642cf5b7307407efa85f101faa54e117eb119e5)
      #16 pc 0000000000232140  libLabSound_d.so (lab::MakeRealtimeAudioContext(lab::AudioStreamConfig, lab::AudioStreamConfig)+220) (BuildId: b642cf5b7307407efa85f101faa54e117eb119e5)
      #17 pc 0000000000154dc8  libLabSound_d.so (createRealtimeAudioContext+180) (BuildId: b642cf5b7307407efa85f101faa54e117eb119e5)
      #18 pc 00000000000066b4  <anonymous:787ce00000>
Lost connection to device.
```