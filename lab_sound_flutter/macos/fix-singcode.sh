codesignIdentity=`security find-identity -p codesigning -v | grep -Eo "[0-9A-F]{40}" | head -n 1`;
codesign -s $codesignIdentity -f ./LabSoundBridge.framework
