list (APPEND    CPACK_GENERATOR     "DEB")
set (CPACK_DEBIAN_PACKAGE_NAME      "${CPACK_DEBIAN_PACKAGE_NAME}")
set (CPACK_DEB_COMPONENT_INSTALL    ON)

# Genetate conffiles.
foreach (component IN LISTS CPACK_COMPONENTS_ALL)
    file( MAKE_DIRECTORY
        "${CMAKE_CURRENT_BINARY_DIR}/${component}"
        )

    set (conffiles_path "${CMAKE_CURRENT_BINARY_DIR}/${component}/conffiles")
    file (WRITE     "${conffiles_path}"
        "")

    foreach (config_file IN LISTS ${component}_CONFIGS)
        file (APPEND    "${conffiles_path}"
            "/etc/NasMonitor/${config_file}\n")

    endforeach ()
    string (TOUPPER "CPACK_DEBIAN_${component}_PACKAGE_CONTROL_EXTRA"
        control_extra
        )
    list (APPEND    "${control_extra}"
        "${conffiles_path}"
        )
    unset (control_extra)
    unset (conffiles_path)

endforeach ()
