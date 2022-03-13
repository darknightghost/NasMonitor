if (WIN32)
    message (FATAL_ERROR    "Windows is not supported.")

endif ()

# Build type
if (NOT CMAKE_BUILD_TYPE)
    set (CMAKE_BUILD_TYPE "Debug")

endif ()

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_definitions ("-DDEBUG")

endif ()

set (CMAKE_BUILD_TYPE "${CMAKE_BUILD_TYPE}"  CACHE STRING "${CMAKE_BUILD_TYPE}" FORCE)

if (GENERATOR_IS_MULTI_CONFIG OR CMAKE_CONFIGURATION_TYPES)
    set (CMAKE_CONFIGURATION_TYPES "${CMAKE_BUILD_TYPE}" CACHE STRING "${CMAKE_BUILD_TYPE}" FORCE)

endif()

message (STATUS "Build Type - ${CMAKE_BUILD_TYPE}.")
message (STATUS "Host System - ${CMAKE_HOST_SYSTEM_NAME}.")
message (STATUS "Host Processor - ${CMAKE_HOST_SYSTEM_PROCESSOR}.")
message (STATUS "Target System - ${CMAKE_SYSTEM_NAME}.")
message (STATUS "Target Processor - ${CMAKE_SYSTEM_PROCESSOR}.")

# Environment.
include_directories ("${CMAKE_CURRENT_SOURCE_DIR}/include")

# Output path.
execute_process (
    COMMAND             lsb_release -ir
    RESULT_VARIABLE     lsb_result
    OUTPUT_VARIABLE     lsb_output)

if (lsb_result EQUAL 0)
    string (REGEX REPLACE   ".*Distributor[ \t]+ID:[ \t]+([^\n]+).*"
        "\\1"
        DISTRO_NAME
        "${lsb_output}")
    string (REGEX REPLACE   ".*Release:[ \t]+([^\n]+).*"
        "\\1"
        DISTRO_RELEASE
        "${lsb_output}")
    if (${DISTRO_RELEASE} STREQUAL "rolling")
        set (HOST_DISTRO        "${DISTRO_NAME}" CACHE STRING "Host distro." FORCE)

    else ()
        set (HOST_DISTRO        "${DISTRO_NAME} ${DISTRO_RELEASE}" CACHE STRING "Host distro." FORCE)

    endif ()

else ()
    set (HOST_DISTRO        "Unknow" CACHE STRING "Host distro." FORCE)

endif ()

unset (lsb_result)
unset (lsb_output)

if (NOT TARGET_DISTRO)
    set (TARGET_DISTRO      "${HOST_DISTRO}" CACHE STRING "Target distro." FORCE)

endif ()

set (OUTPUT_SUB_DIR "${CMAKE_BUILD_TYPE}/${CMAKE_SYSTEM_NAME}/${TARGET_DISTRO}/${CMAKE_SYSTEM_PROCESSOR}")

message (STATUS "Host Distro - ${HOST_DISTRO}.")
message (STATUS "Target Distro - ${TARGET_DISTRO}.")


set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY  "${CMAKE_CURRENT_SOURCE_DIR}/lib/${OUTPUT_SUB_DIR}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY  "${CMAKE_CURRENT_SOURCE_DIR}/lib/${OUTPUT_SUB_DIR}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY  "${CMAKE_CURRENT_SOURCE_DIR}/bin/${OUTPUT_SUB_DIR}")

# Platform options.
# Debug/Release.
# Enable address sanitizer in debug mode if possible.
if (${CMAKE_BUILD_TYPE} STREQUAL "Debug")
    if (${CMAKE_CXX_COMPILER_ID} STREQUAL "Clang"
            OR ${CMAKE_CXX_COMPILER_ID} STREQUAL "AppleClang"
            OR ${CMAKE_CXX_COMPILER_ID} STREQUAL "GNU")
        # Enable address sanitizer.
        add_compile_options (-fno-omit-frame-pointer -fsanitize=address)
        add_link_options (-fno-omit-frame-pointer -fsanitize=address)
        message (STATUS "Address sanitizer is enabled.")

    endif()

endif ()

if (${CMAKE_BUILD_TYPE} STREQUAL "Release")
    add_definitions ("-DQT_NO_DEBUG=1")

endif ()

# Compiler.
add_compile_options ("-Werror")
if (${CMAKE_BUILD_TYPE} STREQUAL "Release")
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
    set (CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -g")

endif ()

# Dependencies
find_package (PythonInterp 
    REQUIRED        3)

find_package (OpenSSL   1.1.1   REQUIRED
    COMPONENTS      SSL Crypto)
include_directories ("${OPENSSL_INCLUDE_DIR}")

find_package (Qt5       5.14.1  REQUIRED
    COMPONENTS  Core Widgets Network Xml)

find_package (Doxygen)

if (NOT DOXYGEN_EXECUTABLE)
    message (STATUS "Doxygen is not found. Code document will not be generated.")
    
endif()

find_package(Boost      1.35.0  REQUIRED 
    COMPONENTS container 
)

include_directories (${Boost_INCLUDE_DIR})
link_directories( ${Boost_LIBRARY_DIR})

set (GENERATE_RESOURCE_SCRIPT   "${CMAKE_CURRENT_SOURCE_DIR}/generate_resources.py")
set (GENERATE_RESOURCE_CMD      "${PYTHON_EXECUTABLE}" "${GENERATE_RESOURCE_SCRIPT}")
