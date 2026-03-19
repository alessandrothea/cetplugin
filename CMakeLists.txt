cmake_minimum_required(VERSION 3.20)
project(cetlib CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Build bundled cetlib_except (avoids the cetmodules dependency chain)
add_library(cetlib_except
  cetlib_except/exception.cc
  cetlib_except/demangle.cc
)
target_include_directories(cetlib_except PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

configure_file(cetlib/shlib_utils.cc.in cetlib/shlib_utils.cc @ONLY)

add_library(cetlib
  cetlib/detail/wrapLibraryManagerException.cc
  cetlib/filesystem.cc
  cetlib/getenv.cc
  cetlib/LibraryManager.cc
  cetlib/PluginFactory.cc
  cetlib/search_path.cc
  ${CMAKE_CURRENT_BINARY_DIR}/cetlib/shlib_utils.cc
)

target_include_directories(cetlib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(cetlib PUBLIC cetlib_except ${CMAKE_DL_LIBS})
