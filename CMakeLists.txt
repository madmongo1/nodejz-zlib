cmake_minimum_required(VERSION 3.0)
set(CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS ON)

include (cmake/find_zlib_version.cmake)

if (NOT NODEJS_DEV_ROOT)
    message(FATAL_ERROR "NODEJS_DEV_ROOT not set")
endif ()

set(zlib_include_dir ${NODEJS_DEV_ROOT}/include)

find_zlib_version(${zlib_include_dir})


project(ZLIB VERSION ${ZLIB_VERSION} LANGUAGES CXX)

set(INSTALL_BIN_DIR "${CMAKE_INSTALL_PREFIX}/bin" CACHE PATH "Installation directory for executables")
set(INSTALL_LIB_DIR "${CMAKE_INSTALL_PREFIX}/lib" CACHE PATH "Installation directory for libraries")
set(INSTALL_INC_DIR "${CMAKE_INSTALL_PREFIX}/include" CACHE PATH "Installation directory for headers")
set(INSTALL_MAN_DIR "${CMAKE_INSTALL_PREFIX}/share/man" CACHE PATH "Installation directory for manual pages")
set(INSTALL_PKGCONFIG_DIR "${CMAKE_INSTALL_PREFIX}/share/pkgconfig" CACHE PATH "Installation directory for pkgconfig (.pc) files")

set(zlib_interface_files ${zlib_include_dir}/zlib.h ${zlib_include_dir}/zconf.h)

add_library(z src/dummy.cpp)

include(CMakePackageConfigHelpers)

####
# Installation (https://github.com/forexample/package-example)

# Layout. This works for all platforms:
#   * <prefix>/lib/cmake/<PROJECT-NAME>
#   * <prefix>/lib/
#   * <prefix>/include/
set(config_install_dir "lib/cmake/${PROJECT_NAME}")
set(include_install_dir "include")

set(generated_dir "${CMAKE_CURRENT_BINARY_DIR}/generated")

# Configuration
set(version_config "${generated_dir}/${PROJECT_NAME}ConfigVersion.cmake")
set(project_config "${generated_dir}/${PROJECT_NAME}Config.cmake")
set(targets_export_name "${PROJECT_NAME}Targets")
set(namespace "${PROJECT_NAME}::")

# Include module with fuction 'write_basic_package_version_file'
include(CMakePackageConfigHelpers)

# Configure '<PROJECT-NAME>ConfigVersion.cmake'
# Note: PROJECT_VERSION is used as a VERSION
#write_basic_package_version_file(
#        "${version_config}" COMPATIBILITY SameMajorVersion
#)

# Configure '<PROJECT-NAME>Config.cmake'
# Use variables:
#   * targets_export_name
#   * PROJECT_NAME
#configure_package_config_file(
#        "cmake/Config.cmake.in"
#        "${project_config}"
#        INSTALL_DESTINATION "${config_install_dir}"
#)

# Targets:
#   * <prefix>/lib/libbar.a
#   * <prefix>/lib/libbaz.a
#   * header location after install: <prefix>/include/foo/Bar.hpp
#   * headers can be included by C++ code `#include <foo/Bar.hpp>`
#install(
#        TARGETS z
#        EXPORT "${targets_export_name}"
#        LIBRARY DESTINATION "lib"
#        ARCHIVE DESTINATION "lib"
#        RUNTIME DESTINATION "bin"
#        INCLUDES DESTINATION "${include_install_dir}"
#)

install(
        TARGETS z
        LIBRARY DESTINATION "lib"
        ARCHIVE DESTINATION "lib"
        RUNTIME DESTINATION "bin"
        INCLUDES DESTINATION "${include_install_dir}"
)

# Headers:
#   * Source/foo/Bar.hpp -> <prefix>/include/foo/Bar.hpp
#   * Source/foo/Baz.hpp -> <prefix>/include/foo/Baz.hpp
#install(
#        DIRECTORY "Source/foo"
#        DESTINATION "${include_install_dir}"
#        FILES_MATCHING PATTERN "*.hpp"
#)

# Export headers:
#   * ${CMAKE_CURRENT_BINARY_DIR}/bar_export.h -> <prefix>/include/bar_export.h
#   * ${CMAKE_CURRENT_BINARY_DIR}/baz_export.h -> <prefix>/include/baz_export.h
install(
        FILES ${zlib_interface_files}
        DESTINATION "${include_install_dir}"
)

# Config
#   * <prefix>/lib/cmake/Foo/FooConfig.cmake
#   * <prefix>/lib/cmake/Foo/FooConfigVersion.cmake
#install(
#        FILES "${project_config}" "${version_config}"
#        DESTINATION "${config_install_dir}"
#)

# Config
#   * <prefix>/lib/cmake/Foo/FooTargets.cmake
#install(
#        EXPORT "${targets_export_name}"
#        NAMESPACE "${namespace}"
#        DESTINATION "${config_install_dir}"
#)
