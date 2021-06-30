cmake_minimum_required(VERSION 3.13)
project(LabSoundBridge)

SET(BUILD_EXAMPLE OFF CACHE BOOL "Build example application")

set(LABSOUND_BRIDGE_ROOT ${CMAKE_CURRENT_SOURCE_DIR})

add_subdirectory(LabSound EXCLUDE_FROM_ALL)

file(GLOB dart_api_h      "${LABSOUND_BRIDGE_ROOT}/bridge/dart_api/*")

add_library(LabSoundBridge SHARED
    ./bridge/LabSoundBridge.cpp
    ${dart_api_h}
)

target_link_libraries(LabSoundBridge LabSound)

set_target_properties(LabSoundBridge
    PROPERTIES
    OUTPUT_NAME_DEBUG LabSoundBridge_d
)

IF (WIN32)
	install(TARGETS LabSoundBridge
        LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}
        FRAMEWORK DESTINATION ${CMAKE_INSTALL_PREFIX}
    )
ELSE ()
    install(TARGETS LabSoundBridge
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
        FRAMEWORK DESTINATION lib
    )
ENDIF ()
