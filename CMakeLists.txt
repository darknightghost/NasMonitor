cmake_minimum_required(VERSION 3.0.0 FATAL_ERROR)

set (CMAKE_CXX_STANDARD 17) 

cmake_policy(SET CMP0054 NEW)

# Project
project (NasMonitor C CXX)

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

