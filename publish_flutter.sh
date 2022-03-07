#!/bin/sh

checkFile[0]="lab_sound_flutter/android/src/main/jniLibs/arm64-v8a/libLabSoundBridge.so"
checkFile[1]="lab_sound_flutter/android/src/main/jniLibs/armeabi-v7a/libLabSoundBridge.so"
checkFile[2]="lab_sound_flutter/android/src/main/jniLibs/x86/libLabSoundBridge.so"
checkFile[3]="lab_sound_flutter/android/src/main/jniLibs/x86_64/libLabSoundBridge.so"

checkFile[4]="lab_sound_flutter/ios/LabSoundBridge.framework/LabSoundBridge"

checkFile[5]="lab_sound_flutter/macos/LabSoundBridge.framework/LabSoundBridge"

checkFile[6]="lab_sound_flutter/linux/libLabSoundBridge.so"

checkFile[7]="lab_sound_flutter/windows/LabSoundBridge.dll"

fileMiss=0

for file in ${checkFile[@]}
do
	if [ ! -f "$file" ]; then
		fileMiss=1
		echo "MISS FILE! : $file"
  fi
done

if [ $fileMiss == 1 ] ; then
  exit 1
fi


dart pub publish --dry-run --directory="lab_sound_flutter"

read -r -p "Do you want to publish? [Y/n] " input

case $input in
    [yY][eE][sS]|[yY])

		;;

    *)
		exit 1
		;;
esac

echo "hello"