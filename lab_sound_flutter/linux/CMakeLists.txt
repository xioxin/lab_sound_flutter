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

# List of absolute paths to libraries that should be bundled with the plugin
# set(lab_sound_flutter_bundled_libraries
#   "${lab_sound_flutter_SOURCE_DIR}/libLabSoundBridge.so"
#   PARENT_SCOPE
# )

set(lab_sound_flutter_bundled_libraries
  "$<TARGET_FILE:LabSoundBridge>"
  PARENT_SCOPE
)

add_subdirectory(../bridge LabSoundBridge)