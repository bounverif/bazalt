include(FetchContent)

set(BAZALT_TOMLC17_VERSION
    "R250712"
    CACHE STRING "TomlC17 version")
set(BAZALT_TOMLC17_GIT_TAG
    ${BAZALT_TOMLC17_VERSION}
    CACHE STRING "TomlC17 git tag")

FetchContent_Declare(
  tomlc17
  GIT_REPOSITORY https://github.com/cktan/tomlc17.git
  GIT_TAG ${BAZALT_TOMLC17_GIT_TAG}
  EXCLUDE_FROM_ALL)
FetchContent_MakeAvailable(tomlc17)

add_library(tomlc17 "${tomlc17_SOURCE_DIR}/src/tomlc17.c")
add_library(tomlc17::tomlc17 ALIAS tomlc17)

# Set include directories so other targets can find the headers.
target_include_directories(tomlc17 PUBLIC "${tomlc17_SOURCE_DIR}/src")
