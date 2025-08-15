macro(add_subdirectories_from dir)
  file(
    GLOB APP_DIRS
    LIST_DIRECTORIES true
    ${dir}/*)
  foreach(APP_DIR ${APP_DIRS})
    if(IS_DIRECTORY ${APP_DIR} AND EXISTS ${APP_DIR}/CMakeLists.txt)
      add_subdirectory(${APP_DIR})
    endif()
  endforeach()
endmacro()
