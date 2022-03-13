set (TARGET_PREFIX              "NasMonitord")
set (${TARGET_PREFIX}_TARGET    "NasMonitord")

file (GLOB_RECURSE ${TARGET_PREFIX}_SRC
    "${CMAKE_CURRENT_SOURCE_DIR}/source/NasMonitord/*.cc"
    "${CMAKE_CURRENT_SOURCE_DIR}/source/common/*.cc"
    )

add_executable(${${TARGET_PREFIX}_TARGET}
    ${${TARGET_PREFIX}_SRC}
    )

target_link_libraries(${${TARGET_PREFIX}_TARGET}
    ${Boost_LIBRARIES}
    ${OPENSSL_LIBRARIES}
    ${OPENSSL_SSL_LIBRARY}
    ${OPENSSL_CRYPTO_LIBRARY}
    )

unset (TARGET_PREFIX)
