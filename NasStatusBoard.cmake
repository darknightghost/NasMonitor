set (TARGET_PREFIX              "NasStatusBoard")
set (${TARGET_PREFIX}_TARGET    "NasStatusBoard")

# Sources
file (GLOB_RECURSE ${TARGET_PREFIX}_SRC
    "${CMAKE_CURRENT_SOURCE_DIR}/source/NasStatusBoard/*.cc"
    "${CMAKE_CURRENT_SOURCE_DIR}/source/common/*.cc"
    )

# Headers
file (GLOB_RECURSE ${TARGET_PREFIX}_HEADERS
    "${CMAKE_CURRENT_SOURCE_DIR}/include/NasStatusBoard/*.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/include/NasStatusBoard/*.hpp"
    )

qt5_wrap_cpp (${TARGET_PREFIX}_WRAPPED_HEADERS
    ${${TARGET_PREFIX}_HEADERS}
    )

# Resources
set (${TARGET_PREFIX}_RESOURCE_LIST_FILE     
    "${CMAKE_CURRENT_SOURCE_DIR}/resources/NasStatusBoard/resources.qrc"
    )
file (GLOB_RECURSE ${TARGET_PREFIX}_RESOURCES
    "${CMAKE_CURRENT_SOURCE_DIR}/resources/NasStatusBoard/*"
    )
list (REMOVE_ITEM  ${TARGET_PREFIX}_RESOURCES 
    ${${TARGET_PREFIX}_RESOURCE_LIST_FILE})

add_custom_command (
    OUTPUT  ${${TARGET_PREFIX}_RESOURCE_LIST_FILE}
    COMMAND ${GENERATE_RESOURCE_CMD}
            "-s"
            "${CMAKE_CURRENT_SOURCE_DIR}"
            "-r" 
            "${CMAKE_CURRENT_SOURCE_DIR}/resources/NasStatusBoard" 
            "-c"
            "${CMAKE_CURRENT_SOURCE_DIR}/CHANGELOG" 
            "-o"
            "${${TARGET_PREFIX}_RESOURCE_LIST_FILE}"
            ${${TARGET_PREFIX}_RESOURCES} 
    DEPENDS ${${TARGET_PREFIX}_RESOURCES} 
            "${GENERATE_RESOURCE_SCRIPT}"
    )

qt5_add_resources (${TARGET_PREFIX}_WRAPPED_RESOURCES
    "${${TARGET_PREFIX}_RESOURCE_LIST_FILE}"
    )

add_executable(${${TARGET_PREFIX}_TARGET}
    ${${TARGET_PREFIX}_SRC}
    ${${TARGET_PREFIX}_WRAPPED_RESOURCES}
    ${${TARGET_PREFIX}_WRAPPED_HEADERS}
    )

target_link_libraries(${${TARGET_PREFIX}_TARGET}
    Qt5::Core
    Qt5::Widgets
    Qt5::Network
    Qt5::Xml
    ${Boost_LIBRARIES}
    ${OPENSSL_LIBRARIES}
    ${OPENSSL_SSL_LIBRARY}
    ${OPENSSL_CRYPTO_LIBRARY}
    )

unset (TARGET_PREFIX)
