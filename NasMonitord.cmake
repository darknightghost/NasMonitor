set (TARGET_PREFIX              "NasMonitord")
set (${TARGET_PREFIX}_TARGET    "NasMonitord")

# Source.
file (GLOB_RECURSE ${TARGET_PREFIX}_SRC
    "${CMAKE_CURRENT_SOURCE_DIR}/source/NasMonitord/*.cc"
    "${CMAKE_CURRENT_SOURCE_DIR}/source/common/*.cc"
    )

# Target.
add_executable (${${TARGET_PREFIX}_TARGET}
    ${${TARGET_PREFIX}_SRC}
    )

target_link_libraries(${${TARGET_PREFIX}_TARGET}
    ${Boost_LIBRARIES}
    ${OPENSSL_LIBRARIES}
    ${OPENSSL_SSL_LIBRARY}
    ${OPENSSL_CRYPTO_LIBRARY}
    )

# Install.
set (${TARGET_PREFIX}_COMPONENT     "${TARGET_PREFIX}")

cpack_add_component ("${${TARGET_PREFIX}_COMPONENT}"
    DESCRIPTION     "Monitor daemon of the nas monitor."
    )
list (APPEND    CPACK_COMPONENTS_ALL    "${${TARGET_PREFIX}_COMPONENT}")  

install (TARGETS    "${${TARGET_PREFIX}_TARGET}"
    COMPONENT       "${${TARGET_PREFIX}_COMPONENT}"
    DESTINATION     bin
    )

# Install configs.
file (GLOB_RECURSE ${TARGET_PREFIX}_CONFIGS
    RELATIVE    "${CMAKE_CURRENT_SOURCE_DIR}/config"
    "${CMAKE_CURRENT_SOURCE_DIR}/config/NasMonitord/*"
    )
foreach (name IN LISTS ${TARGET_PREFIX}_CONFIGS)
    install (FILES      "${CMAKE_CURRENT_SOURCE_DIR}/config/${name}"
        COMPONENT       "${${TARGET_PREFIX}_COMPONENT}"
        DESTINATION     "/etc/NasMonitor"
        )

endforeach ()

unset (TARGET_PREFIX)
