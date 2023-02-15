#
# Install the package.xml file, and generate code for
# ``find_package`` so that other packages can get information about
# this package.
#
# @public
#
macro(la_package)
  # verify that project() has been called before
  if(NOT PROJECT_NAME)
    message(FATAL_ERROR "la_package() PROJECT_NAME is not set. You must "
      "call project() before calling la_package().")
  endif()
  if(PROJECT_NAME STREQUAL "Project")
    message(FATAL_ERROR "la_package() PROJECT_NAME is set to 'Project', "
      "which is not a valid project name. "
      "You must call project() before calling la_package().")
  endif()

  # mark that la_package() was called
  # in order to detect wrong order of calling
  set(_${PROJECT_NAME}_LA_PACKAGE TRUE)

  _la_package()
endmacro()

set(_LA_CMAKE_MODULE_BASE_DIR "${CMAKE_CURRENT_LIST_DIR}")

function(_la_package)
  # https://cmake.org/cmake/help/latest/guide/importing-exporting/index.html

  # export targets
  foreach(_target ${_LA_CMAKE_EXPORT_TARGETS})
    # install targets
    install(EXPORT ${_target}
      FILE ${_target}.cmake
      DESTINATION lib/cmake/${PROJECT_NAME}
    )
    # export targets from the build tree
    export(EXPORT ${_target}
      FILE ${CMAKE_CURRENT_BINARY_DIR}/${_target}.cmake)
  endforeach()

  include(CMakePackageConfigHelpers)

  # generate CMake config file
  configure_package_config_file(${_LA_CMAKE_MODULE_BASE_DIR}/nameConfig.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
    INSTALL_DESTINATION lib/cmake/${PROJECT_NAME}
  )

  # generate CMake config-version file
  write_basic_package_version_file(${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
    VERSION ${PROJECT_VERSION} COMPATIBILITY AnyNewerVersion)

  # install CMake config and config-version files
  install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
    DESTINATION lib/cmake/${PROJECT_NAME}
  )

  # install package.xml
  if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/package.xml)
    install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/package.xml DESTINATION share/${PROJECT_NAME})
  endif()
endfunction()