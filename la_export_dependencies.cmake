#
# Export dependencies to downstream packages.
#
# Each package name must be find_package()-able with the exact same case.
#
# :param ARGN: a list of package names
# :type ARGN: list of strings
#
# @public
#
macro(la_export_dependencies)
  if(_${PROJECT_NAME}_LA_PACKAGE)
    message(FATAL_ERROR
      "la_export_dependencies() must be called before la_package()")
  endif()

  if(${ARGC} GREATER 0)
    foreach(_arg ${ARGN})
      list(APPEND _LA_CMAKE_EXPORT_DEPENDENCIES "${_arg}")
    endforeach()
  endif()
endmacro()