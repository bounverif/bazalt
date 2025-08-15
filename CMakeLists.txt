cmake_minimum_required(VERSION 3.25)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR
   AND NOT CMAKE_BUILD_TYPE
   AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE
      Release
      CACHE STRING "Build type" FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release"
                                               "MinSizeRel" "RelWithDebInfo")
endif()

project(
  BAZALT
  VERSION 0.3.0
  LANGUAGES C CXX)

set(CMAKE_C_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_FLAGS_COVERAGE "-O0 --coverage")
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN ON)

# find_package(Threads REQUIRED) find_package( Boost 1.83 COMPONENTS json url
# program_options REQUIRED CONFIG )
add_subdirectory(external/tomlc17)

option(BAZALT_BUILD_SHARED_LIBS "Build shared libraries" ON)
option(BAZALT_BUILD_TESTS "Build tests" OFF)
option(BAZALT_BUILD_EXAMPLES "Build examples" OFF)

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)
include(cmake/utils.cmake)

set(BAZALT_SOURCES "src/bazalt/bazalt.c" "src/bazalt/logging.c"
                   "src/bazalt/tomlconf.c")

add_library(bazalt SHARED ${BAZALT_SOURCES})
add_library(bazalt::bazalt ALIAS bazalt)
target_include_directories(
  bazalt
  PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
         $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>
         $<INSTALL_INTERFACE:include>)
target_link_libraries(bazalt PRIVATE # Threads::Threads
                                     tomlc17::tomlc17)
# target_link_libraries(bazalt PUBLIC systemd)
set_target_properties(bazalt PROPERTIES OUTPUT_NAME "bazalt" VERSION
                                                             ${PROJECT_VERSION})
target_compile_definitions(bazalt PRIVATE BAZALT_EXPORTS)

add_subdirectories_from(${CMAKE_CURRENT_SOURCE_DIR}/examples)

if(BAZALT_BUILD_TESTS)
  include(CTest)
  enable_testing()
  add_subdirectory(tests)
endif()

if(PROJECT_IS_TOP_LEVEL AND UNIX)
  # Create symlink to compile_commands.json on the project directory
  execute_process(
    COMMAND
      ${CMAKE_COMMAND} -E create_symlink
      ${CMAKE_BINARY_DIR}/compile_commands.json
      ${CMAKE_PROJECT_DIR}/compile_commands.json)
endif()
