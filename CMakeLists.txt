cmake_minimum_required(VERSION 3.10)
project(LabSoundBridge)
set(CMAKE_INSTALL_MESSAGE LAZY)

SET(BUILD_EXAMPLE OFF CACHE BOOL "Build example application")

set(LABSOUND_BRIDGE_ROOT ${CMAKE_CURRENT_SOURCE_DIR})

add_subdirectory(LabSound)

file(GLOB dart_api_h      "${LABSOUND_BRIDGE_ROOT}/bridge/dart_api/*")

add_library(LabSoundBridge SHARED
    ${dart_api_h}
    ./bridge/LabSoundBridge.cpp
)

target_link_libraries(LabSoundBridge LabSound)

set_target_properties(LabSoundBridge
    PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
    OUTPUT_NAME_DEBUG LabSoundBridge_d
)

install(TARGETS LabSoundBridge
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    FRAMEWORK DESTINATION lib
)