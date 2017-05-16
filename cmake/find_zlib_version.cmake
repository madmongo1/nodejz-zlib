
#todo - deduce this from NODEJS_ROOT

macro(find_zlib_version zlib_include_dir)
    set(zlib_hdr ${zlib_include_dir}/zlib.h)
    if (NOT EXISTS ${zlib_hdr})
        message(FATAL_ERROR no such file: ${zlib_hdr})
    endif ()
    set(ZLIB_VERSION "0.0.0")

    file(STRINGS ${zlib_hdr} ZLIB_H REGEX "^#define ZLIB_VERSION \"[^\"]*\"$")

    string(REGEX REPLACE "^.*ZLIB_VERSION \"([0-9]+).*$" "\\1" ZLIB_VERSION_MAJOR "${ZLIB_H}")
    string(REGEX REPLACE "^.*ZLIB_VERSION \"[0-9]+\\.([0-9]+).*$" "\\1" ZLIB_VERSION_MINOR "${ZLIB_H}")
    string(REGEX REPLACE "^.*ZLIB_VERSION \"[0-9]+\\.[0-9]+\\.([0-9]+).*$" "\\1" ZLIB_VERSION_PATCH "${ZLIB_H}")
    set(ZLIB_VERSION_STRING "${ZLIB_VERSION_MAJOR}.${ZLIB_VERSION_MINOR}.${ZLIB_VERSION_PATCH}")
    set(ZLIB_VERSION ${ZLIB_VERSION_STRING})

    # only append a TWEAK version if it exists:
    set(ZLIB_VERSION_TWEAK "")
    if ("${ZLIB_H}" MATCHES "ZLIB_VERSION \"[0-9]+\\.[0-9]+\\.[0-9]+\\.([0-9]+)")
        set(ZLIB_VERSION_TWEAK "${CMAKE_MATCH_1}")
        string(APPEND ZLIB_VERSION_STRING ".${ZLIB_VERSION_TWEAK}")
    endif ()

    set(ZLIB_MAJOR_VERSION "${ZLIB_VERSION_MAJOR}")
    set(ZLIB_MINOR_VERSION "${ZLIB_VERSION_MINOR}")
    set(ZLIB_PATCH_VERSION "${ZLIB_VERSION_PATCH}")

endmacro()
