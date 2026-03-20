cmake_minimum_required(VERSION 3.20)
project(cetlib CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Build bundled cetlib_except (avoids the cetmodules dependency chain)
add_library(cetlib_except
  cetlib_except/exception.cc
  cetlib_except/demangle.cc
)
target_include_directories(cetlib_except PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:include>)

configure_file(cetlib/shlib_utils.cc.in cetlib/shlib_utils.cc @ONLY)

add_library(cetlib
  cetlib/BasicPluginFactory.cc
  cetlib/detail/wrapLibraryManagerException.cc
  cetlib/filesystem.cc
  cetlib/getenv.cc
  cetlib/LibraryManager.cc
  cetlib/PluginFactory.cc
  cetlib/search_path.cc
  ${CMAKE_CURRENT_BINARY_DIR}/cetlib/shlib_utils.cc
)

target_include_directories(cetlib PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:include>)
target_link_libraries(cetlib PUBLIC cetlib_except ${CMAKE_DL_LIBS})

# ── Install rules ─────────────────────────────────────────────────────────────
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

install(TARGETS cetlib_except cetlib

    EXPORT cetlibTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(DIRECTORY cetlib_except cetlib
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    FILES_MATCHING PATTERN "*.h"
)

install(EXPORT cetlibTargets
    FILE cetlibTargets.cmake
    NAMESPACE cetlib::
    DESTINATION ${CMAKE_INSTALL_DATADIR}/cetlib/cmake
)

configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/cetlibConfig.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cetlibConfig.cmake"
    INSTALL_DESTINATION ${CMAKE_INSTALL_DATADIR}/cetlib/cmake
    PATH_VARS CMAKE_INSTALL_INCLUDEDIR CMAKE_INSTALL_LIBDIR
)

write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/cetlibConfigVersion.cmake"
    VERSION 1.0.0
    COMPATIBILITY SameMajorVersion
)

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/cetlibConfig.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/cetlibConfigVersion.cmake"
    DESTINATION ${CMAKE_INSTALL_DATADIR}/cetlib/cmake
)
