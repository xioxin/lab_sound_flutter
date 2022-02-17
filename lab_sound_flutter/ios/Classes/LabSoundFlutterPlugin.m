#import "LabSoundFlutterPlugin.h"
#if __has_include(<lab_sound_flutter/lab_sound_flutter-Swift.h>)
#import <lab_sound_flutter/lab_sound_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "lab_sound_flutter-Swift.h"
#endif

@implementation LabSoundFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLabSoundFlutterPlugin registerWithRegistrar:registrar];
}
@end
