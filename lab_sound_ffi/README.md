# lab_sound_ffi

lab_sound_ffi is the [LabSound](https://github.com/LabSound/LabSound) wrapper for Dart.

-------

You need to manage the binary library yourself.

We provide compiled binaries: <https://github.com/xioxin/lab_sound_bridge>

Actions -> Select latest workflow -> Artifacts -> Download the platform you need

Or you can compile it yourself.

reference: https://github.com/xioxin/lab_sound_bridge/blob/main/.github/workflows/cmake.yml

LabSound is a lazy-loading singleton class, You need to override the DynamicLibrary load method before executing other methods.

```dart
LabSound.overrideDynamicLibrary(() => DynamicLibrary.open("LabSoundBridge.framework/LabSoundBridge"), OperatingSystem.macOS);
LabSound.overrideDynamicLibrary(() => DynamicLibrary.open("./path/libLabSoundBridge.so"), OperatingSystem.linux);
// ..... more platforms
```

> if you are a flutter project please use lab_sound_flutter, which already contains the binary library


**All API's might change without warning and no guarantees are given about stability. Do not use it in production.**


## Platform
* [x] Android
* [x] iOS
* [x] Mac
* [x] Windows
* [x] Linux
* [ ] Web

