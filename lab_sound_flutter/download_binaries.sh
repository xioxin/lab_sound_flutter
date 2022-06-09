#!/bin/bash

bridge_version=`cat ../../../BRIDGE_VERSION`
github="https://github.com/xioxin/lab_sound_bridge/releases/download/${bridge_version:5}"

curl "${github}/libLabSoundBridge_android_arm64.so" -o android/src/main/jniLibs/arm64-v8a/libLabSoundBridge.so --create-dirs -L
curl "${github}/libLabSoundBridge_android_armv7.so" -o android/src/main/jniLibs/armeabi-v7a/libLabSoundBridge.so --create-dirs -L
curl "${github}/libLabSoundBridge_android_x64.so" -o android/src/main/jniLibs/x86_64/libLabSoundBridge.so --create-dirs -L

curl "${github}/libLabSoundBridge_linux_x64.so" -o linux/libLabSoundBridge.so --create-dirs -L
curl "${github}/LabSoundBridge_windows_x64.dll" -o windows/LabSoundBridge.dll --create-dirs -L

curl "${github}/LabSoundBridge_ios.tar.gz" -o ios/LabSoundBridge_ios.tar.gz --create-dirs -L
curl "${github}/LabSoundBridge_macos_x64.tar.gz" -o macos/LabSoundBridge_macos_x64.tar.gz --create-dirs -L
