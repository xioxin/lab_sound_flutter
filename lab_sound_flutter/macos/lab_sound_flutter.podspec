#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint lab_sound_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'lab_sound_flutter'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/xioxin/lab_sound_flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'xioxin' => 'i@xioxin.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.15'
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES'  }
  s.swift_version = '5.0'

  s.preserve_paths = 'LabSoundBridge.framework'
  s.vendored_frameworks = 'LabSoundBridge.framework'
  s.library = 'c++'
end
