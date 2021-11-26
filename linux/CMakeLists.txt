cmake_minimum_required(VERSION 3.10)
set(PROJECT_NAME "lab_sound_flutter")
project(${PROJECT_NAME} LANGUAGES CXX)

# This value is used when generating builds using this plugin, so it must
# not be changed
set(PLUGIN_NAME "lab_sound_flutter_plugin")

add_library(${PLUGIN_NAME} SHARED
  "lab_sound_flutter_plugin.cc"
)
apply_standard_settings(${PLUGIN_NAME})
set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter)
target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::GTK)

add_compile_options(-fPIC)

set(LABSOUND_PULSE 1)
# set(LABSOUND_JACK 1)
# set(LABSOUND_ASOUND 1)

# List of absolute paths to libraries that should be bundled with the plugin
set(lab_sound_flutter_bundled_libraries
  "$<TARGET_FILE:LabSoundBridge>"
  PARENT_SCOPE
)

add_subdirectory(../ LabSoundBridge)


# backends/RtAudio/RtAudio.cpp:7806:10: fatal error: 'alsa/asoundlib.h' file not found
# sudo apt-get install libasound2-dev

# backends/RtAudio/RtAudio.cpp:9261:10: fatal error: 'pulse/error.h' file not found
# sudo apt-get install libpulse-dev