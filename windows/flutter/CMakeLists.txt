cmake_minimum_required(VERSION 3.14)

# Set strict compiler checks
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(EPHEMERAL_DIR "${CMAKE_CURRENT_SOURCE_DIR}/ephemeral")

# Verify ephemeral directory exists
if(NOT EXISTS "${EPHEMERAL_DIR}")
    message(FATAL_ERROR "Ephemeral directory not found: ${EPHEMERAL_DIR}")
endif()

# Configuration provided via flutter tool.
include(${EPHEMERAL_DIR}/generated_config.cmake)

# Wrapper root directory
set(WRAPPER_ROOT "${EPHEMERAL_DIR}/cpp_client_wrapper")

# Set fallback configurations for older versions of the flutter tool.
if(NOT DEFINED FLUTTER_TARGET_PLATFORM)
    set(FLUTTER_TARGET_PLATFORM "windows-x64")
endif()

# === Flutter Library ===
set(FLUTTER_LIBRARY "${EPHEMERAL_DIR}/flutter_windows.dll")

# Verify Flutter library exists
if(NOT EXISTS "${FLUTTER_LIBRARY}")
    message(WARNING "Flutter library not found: ${FLUTTER_LIBRARY}")
endif()

# Published to parent scope for install step.
set(FLUTTER_LIBRARY ${FLUTTER_LIBRARY} PARENT_SCOPE)
set(FLUTTER_ICU_DATA_FILE "${EPHEMERAL_DIR}/icudtl.dat" PARENT_SCOPE)
set(PROJECT_BUILD_DIR "${PROJECT_DIR}/build/" PARENT_SCOPE)
set(AOT_LIBRARY "${PROJECT_DIR}/build/windows/app.so" PARENT_SCOPE)

# Define Flutter headers
set(FLUTTER_LIBRARY_HEADERS
    "flutter_export.h"
    "flutter_windows.h"
    "flutter_messenger.h"
    "flutter_plugin_registrar.h"
    "flutter_texture_registrar.h"
)
list(TRANSFORM FLUTTER_LIBRARY_HEADERS PREPEND "${EPHEMERAL_DIR}/")

# Create Flutter interface library
add_library(flutter INTERFACE)
target_include_directories(flutter INTERFACE "${EPHEMERAL_DIR}")
target_link_libraries(flutter INTERFACE "${FLUTTER_LIBRARY}.lib")
add_dependencies(flutter flutter_assemble)

# === Wrapper ===
# Core wrapper sources
set(CPP_WRAPPER_SOURCES_CORE
    "core_implementations.cc"
    "standard_codec.cc"
)
list(TRANSFORM CPP_WRAPPER_SOURCES_CORE PREPEND "${WRAPPER_ROOT}/")

# Plugin wrapper sources
set(CPP_WRAPPER_SOURCES_PLUGIN
    "plugin_registrar.cc"
)
list(TRANSFORM CPP_WRAPPER_SOURCES_PLUGIN PREPEND "${WRAPPER_ROOT}/")

# App wrapper sources
set(CPP_WRAPPER_SOURCES_APP
    "flutter_engine.cc"
    "flutter_view_controller.cc"
)
list(TRANSFORM CPP_WRAPPER_SOURCES_APP PREPEND "${WRAPPER_ROOT}/")

# Plugin wrapper library
add_library(flutter_wrapper_plugin STATIC
    ${CPP_WRAPPER_SOURCES_CORE}
    ${CPP_WRAPPER_SOURCES_PLUGIN}
)
apply_standard_settings(flutter_wrapper_plugin)
set_target_properties(flutter_wrapper_plugin PROPERTIES
    POSITION_INDEPENDENT_CODE ON
    CXX_VISIBILITY_PRESET hidden
)
target_link_libraries(flutter_wrapper_plugin PUBLIC flutter)
target_include_directories(flutter_wrapper_plugin PUBLIC "${WRAPPER_ROOT}/include")
add_dependencies(flutter_wrapper_plugin flutter_assemble)

# App wrapper library
add_library(flutter_wrapper_app STATIC
    ${CPP_WRAPPER_SOURCES_CORE}
    ${CPP_WRAPPER_SOURCES_APP}
)
apply_standard_settings(flutter_wrapper_app)
target_link_libraries(flutter_wrapper_app PUBLIC flutter)
target_include_directories(flutter_wrapper_app PUBLIC "${WRAPPER_ROOT}/include")
add_dependencies(flutter_wrapper_app flutter_assemble)

# === Flutter tool backend ===
set(PHONY_OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/_phony_")
set_source_files_properties("${PHONY_OUTPUT}" PROPERTIES SYMBOLIC TRUE)

# Ensure FLUTTER_ROOT is defined
if(NOT DEFINED FLUTTER_ROOT)
    message(FATAL_ERROR "FLUTTER_ROOT must be defined")
endif()

add_custom_command(
    OUTPUT ${FLUTTER_LIBRARY} ${FLUTTER_LIBRARY_HEADERS}
        ${CPP_WRAPPER_SOURCES_CORE} ${CPP_WRAPPER_SOURCES_PLUGIN}
        ${CPP_WRAPPER_SOURCES_APP}
        ${PHONY_OUTPUT}
    COMMAND ${CMAKE_COMMAND} -E env
        ${FLUTTER_TOOL_ENVIRONMENT}
        "${FLUTTER_ROOT}/packages/flutter_tools/bin/tool_backend.bat"
            ${FLUTTER_TARGET_PLATFORM} $<CONFIG>
    VERBATIM
)

add_custom_target(flutter_assemble DEPENDS
    "${FLUTTER_LIBRARY}"
    ${FLUTTER_LIBRARY_HEADERS}
    ${CPP_WRAPPER_SOURCES_CORE}
    ${CPP_WRAPPER_SOURCES_PLUGIN}
    ${CPP_WRAPPER_SOURCES_APP}
)