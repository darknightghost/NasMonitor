cmake_minimum_required(VERSION 3.0.0 FATAL_ERROR)

set (CMAKE_CXX_STANDARD 17) 

cmake_policy(SET CMP0054 NEW)

# Project
project (NasMonitor C CXX)

set (CMAKE_PROJECT_VERSION_MAJOR        0)
set (CMAKE_PROJECT_VERSION_MINOR        1)
set (CMAKE_PROJECT_VERSION_PATCH        0)

include (CPackComponent)

# Environment.
list (APPEND    CMAKE_MODULE_PATH       "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include (env)

# Targets.
list (APPEND    CMAKE_MODULE_PATH       "${CMAKE_CURRENT_SOURCE_DIR}")
include (NasMonitord)
include (NasStatusBoard)
##Doc
#if (DOXYGEN_EXECUTABLE)
#    add_custom_target("doc" ALL
#        COMMAND             ${DOXYGEN_EXECUTABLE}
#        WORKING_DIRECTORY   ${CMAKE_CURRENT_SOURCE_DIR})
#   
#endif ()

# Pack.
set (CPACK_PACKAGE_NAME         "NasMonitor")
set (CPACK_PACKAGE_DESCRIPTION  "Nas monitor.")
set (CPACK_PACKAGE_CONTACT      "wangsiyuan <darknightghost.cn@gmail.com>")

list (APPEND    CMAKE_MODULE_PATH       "${CMAKE_CURRENT_SOURCE_DIR}/cpack")
include (arch)
include (deb)
include (CPack)
