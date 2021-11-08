cmake_minimum_required(VERSION 3.13)
project(LabSoundBridge)

SET(BUILD_EXAMPLE OFF CACHE BOOL "Build example application")

set(LABSOUND_BRIDGE_ROOT ${CMAKE_CURRENT_SOURCE_DIR})

add_subdirectory(LabSound EXCLUDE_FROM_ALL)

file(GLOB dart_api_h      "${LABSOUND_BRIDGE_ROOT}/bridge/dart_api/*")

set(bridge_h "${LABSOUND_ROOT}/ffigen/LabSoundHelper.h")

add_library(LabSoundBridge SHARED
    ./bridge/LabSoundBridge.cpp
    ${dart_api_h}
)

target_link_libraries(LabSoundBridge LabSound)

set_target_properties(LabSoundBridge
    PROPERTIES
    OUTPUT_NAME_DEBUG LabSoundBridge_d
)


if (APPLE)
    set_target_properties(LabSoundBridge PROPERTIES
        FRAMEWORK TRUE
        FRAMEWORK_VERSION A
        MACOSX_FRAMEWORK_IDENTIFIER com.xioxin.LabSoundBridge
        VERSION 0.13.0
        SOVERSION 1.0.0
        PUBLIC_HEADER "${bridge_h}"
    )
    set_property(SOURCE ${bridge_h}
        PROPERTY MACOSX_PACKAGE_LOCATION Headers/LabSound/core)
endif()

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
